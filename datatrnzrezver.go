// Copyright 2013 The Gorilla WebSocket Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main

import (
    "net/http"
    "time"
    "encoding/json"
    "github.com/gorilla/websocket"
    //"golang.org/x/net/websocket"
    "fmt"
    "strconv"
)

const (
    // Time allowed to write a message to the peer.
    writeWait = 10 * time.Second

    // Time allowed to read the next pong message from the peer.
    pongWait = 60 * time.Second

    // Send pings to peer with this period. Must be less than pongWait.
    pingPeriod = (pongWait * 9) / 10

    // Maximum message size allowed from peer.
    maxMessageSize = 512
)

var (
    newline = []byte{'\n'}
    space   = []byte{' '}
)

var upgrader = websocket.Upgrader{
    ReadBufferSize:  1024,
    WriteBufferSize: 1024,
}

// Client is a middleman between the websocket connection and the hub.
type Client struct {
    // The websocket Id.
    id int

    // The websocket connection.
    socket *websocket.Conn

    // Buffered channel of outbound messages.
    sendMsg chan Graphic
}

type Graphic struct {
    Id  int `json:"id,omitempty"`
    ShapeId  int `json:"shape_id,omitempty"`
    UserId  int `json:"user_id,omitempty"`
    ColorId  int `json:"color_id,omitempty"`
    CreatedAt  time.Time `json:"created_at,omitempty"`
    UpdatedAt  time.Time `json:"updated_at,omitempty"`
}

type ShapeColorUser struct {
    ShapeId  int `json:"shape_id,omitempty"`
    ClrCode  string `json:"clrcode,omitempty"`
    UsrName  string `json:"usrname,omitempty"`
    LastUpdatedAt  string `json:"last_updated_at,omitempty"`
}

// readPump pumps messages from the websocket connection to the hub.
//
// The application runs readPump in a per-connection goroutine. The application
// ensures that there is at most one reader on a connection by executing all
// reads from this goroutine.
func (client *Client) read(manager *ClientManager) {
    defer func() {
        manager.unregister <- client
        client.socket.Close()
    }()

    var graphic Graphic
    database := manager.database

    for {
        _, message, err := client.socket.ReadMessage()
        if err != nil {
            manager.unregister <- client
            client.socket.Close()
            break
        }
        err = json.Unmarshal(message, &graphic)
        if err != nil {
            fmt.Println("error:", err)
            manager.unregister <- client
            client.socket.Close()
            break
        }
        //fmt.Println("recicont:", recicont.Content, "Receiver: ", recicont.Receiver)
        database.CreateRecord(graphic.ShapeId, graphic.UserId, graphic.ColorId)
        manager.broadcast <- graphic
    }
}

// writePump pumps messages from the hub to the websocket connection.
//
// A goroutine running writePump is started for each connection. The
// application ensures that there is at most one writer to a connection by
// executing all writes from this goroutine.
func (client *Client) write(manager *ClientManager) {
    
    database := manager.database
    for {
        select {
        case graphic, ok := <-client.sendMsg:
            if !ok {
                client.socket.WriteMessage(websocket.CloseMessage, []byte{})
                return
            }
            shpClrUsr := database.GetColorShapeUser(graphic.ShapeId, graphic.ColorId, graphic.UserId)
            receClient := manager.regClients[graphic.UserId]
            defer func() {
                receClient.socket.Close()
            }()
            jsonGraphic, err := json.Marshal(&shpClrUsr)
            if err != nil {
                fmt.Println("Write function error:", err)
                manager.unregister <- client
                client.socket.Close()
                break
            }
            receClient.socket.WriteMessage(websocket.TextMessage, jsonGraphic)  
        }
    }
}

// serveWs handles websocket requests from the peer.
func serveWs(manager *ClientManager, res http.ResponseWriter, req *http.Request) {
    conn, err := (&websocket.Upgrader{CheckOrigin: func(req *http.Request) bool { return true }}).Upgrade(res, req, nil)
    if err != nil {
        fmt.Println(err)
        http.NotFound(res, req)
        return
    }
    //userid := req.URL.Query().Get("userid")
    usrid, err := strconv.Atoi(req.FormValue("userid"))
    if err != nil {
        http.NotFound(res, req)
        return
    }
    client := &Client{id: int(usrid), socket: conn, sendMsg: make(chan Graphic)}
    if manager.regClients[usrid] != nil {
        oldClient := manager.regClients[int(usrid)]
        oldClient.socket.Close()
        manager.unregister <- oldClient
        manager.register <- client
    } else {
        manager.register <- client
    }
    go client.read(manager)
    go client.write(manager)
}
