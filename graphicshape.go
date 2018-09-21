package main

import (
	"net/http"
    "log"
    "encoding/json"
    //"time"
)

type ShapeGraphic struct {
    ShapeId  int `json:"shape_id,omitempty"`
    ShapeName  string `json:"shape_name,omitempty"`
    ColorCode  string `json:"color_code,omitempty"`
    UserName  string `json:"user_name,omitempty"`
    //LastUpdatedAt  time.Time `json:"last_updated_at,omitempty"`
    LastUpdatedAt  string `json:"last_updated_at,omitempty"`
}

type Color struct {
    Id  int `json:"id,omitempty"`
    Name  string `json:"name,omitempty"`
    Code  string `json:"code,omitempty"`
}

func serveShapeGraphics(manager *ClientManager, res http.ResponseWriter, req *http.Request) {
    log.Println(req.URL)
    if req.Method != "GET" {
        http.Error(res, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }
    shapeGraphics := manager.database.GetShapesColorsUsers(400, 0)
    multishpGrphics := makeMultidimensionalArray(shapeGraphics, 20)
    res.Header().Set("Access-Control-Allow-Origin", "*")
    res.Header().Set("Content-Type", "application/json")
    res.WriteHeader(200)
    json.NewEncoder(res).Encode(multishpGrphics)
}

func serveColors(manager *ClientManager, res http.ResponseWriter, req *http.Request) {
    log.Println(req.URL)
    if req.Method != "GET" {
        http.Error(res, "Method not allowed", http.StatusMethodNotAllowed)
        return
    }
    colors := manager.database.GetColorCodes(18, 0)
    multicolors := makeMultidimensionalClrArray(colors, 3)
    res.Header().Set("Access-Control-Allow-Origin", "*")
    res.Header().Set("Content-Type", "application/json")
    res.WriteHeader(200)
    json.NewEncoder(res).Encode(multicolors)
}

func makeMultidimensionalArray(arr []ShapeGraphic, cols int) ([][]ShapeGraphic) {
  var multimatrix [][]ShapeGraphic;
  var limit int;
  jnx := 0
  for inx := 0; inx < len(arr); inx += cols {
    switch {
    case (len(arr)/cols > jnx):
      limit = cols + inx
    default:
      limit = len(arr)
    }
    //fmt.Println("jnx:", jnx, "start:", inx, "limit:", limit)
    multimatrix = append(multimatrix, arr[inx:limit])
    jnx++
  }
  return multimatrix
}

func makeMultidimensionalClrArray(arr []Color, cols int) ([][]Color) {
  var multimatrix [][]Color;
  var limit int;
  jnx := 0
  for inx := 0; inx < len(arr); inx += cols {
    switch {
    case (len(arr)/cols > jnx):
      limit = cols + inx
    default:
      limit = len(arr)
    }
    //fmt.Println("jnx:", jnx, "start:", inx, "limit:", limit)
    multimatrix = append(multimatrix, arr[inx:limit])
    jnx++
  }
  return multimatrix
}