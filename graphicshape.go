package main

import (
	"net/http"
    "log"
    "encoding/json"
    "time"
)

type ShapeGraphic struct {
    ShapeId  int `json:"shape_id,omitempty"`
    ShapeName  string `json:"shape_name,omitempty"`
    ColorCode  string `json:"color_code,omitempty"`
    UserName  string `json:"user_name,omitempty"`
    LastUpdatedAt  time.Time `json:"last_updated_at,omitempty"`
}

func serveShapeGraphics(manager *ClientManager, res http.ResponseWriter, req *http.Request) {
    log.Println(req.URL)
    if req.Method != "GET" {
        http.Error(res, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }
    shapeGraphics := manager.database.GetShapesColorsUsers(400, 0)
    res.Header().Set("Content-Type", "application/json")
    res.WriteHeader(200)
    json.NewEncoder(res).Encode(shapeGraphics)
}
