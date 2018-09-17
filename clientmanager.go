// Copyright 2013 The Gorilla WebSocket Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package main


// ClientManager maintains the set of active clients and broadcasts messages to the
// clients.
type ClientManager struct {
	// Registered clients.
	clients map[*Client]bool

	// Inbound messages from the clients.
	broadcast chan Graphic

	// Register requests from the clients.
	register chan *Client

	// Unregister requests from clients.
	unregister chan *Client

    // Register requests from the clients.
    regClients map[int]*Client

    // Connected Database.
    database *DBManager
}

func newClientManager() *ClientManager {
	return &ClientManager{
		broadcast:  make(chan Graphic),
		register:   make(chan *Client),
		unregister: make(chan *Client),
		clients:    make(map[*Client]bool),
        regClients: make(map[int]*Client),
        //database: make(*DBManager),,
	}
}


func (manager *ClientManager) Process() {
    for {
        select {
        case client := <-manager.register:
            manager.clients[client] = true
            manager.regClients[client.id] = client
        case client := <-manager.unregister:
            if _, ok := manager.clients[client]; ok {
                close(client.sendMsg)
                delete(manager.clients, client)
            }
        case message := <-manager.broadcast:
            receClient := manager.regClients[message.UserId]
            receClient.sendMsg <- message
        }
    }
}

