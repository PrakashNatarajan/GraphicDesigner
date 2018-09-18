package main

import (
	"fmt"
	"database/sql"
    _ "github.com/mattn/go-sqlite3"
    "strconv"
    "time"
)

// DBManager maintains the set of active db connection

type DBManager struct {
	// Connected Database.
	database *sql.DB
}

func newDBManager() *DBManager {
	database, err := sql.Open("sqlite3", "../../../RubyProjects/GraphicDesigner/db/development.sqlite3")
	if err != nil {
		fmt.Println("Sqlite3 DB Connection Error:", err)
		return nil
	}
	return &DBManager{
		database:  database,
	}
}

func (manager *DBManager) CreateRecord(shape_id, user_id, color_id int) {
    statement, err := manager.database.Prepare("INSERT OR REPLACE INTO graphics (shape_id, user_id, color_id, created_at, updated_at) VALUES (?, ?, ?, ?, ?)")
    if err != nil {
        fmt.Println("Sqlite3 DB Insert Error:", err)
        return
    }
    dateTime := time.Now()
    statement.Exec(shape_id, user_id, color_id, dateTime, dateTime)
}

func (manager *DBManager) UpdateRecord(guid, status string) {
    statement, err := manager.database.Prepare("UPDATE graphics SET status = ? WHERE guid = ?")
    if err != nil {
        fmt.Println("Sqlite3 DB Update Error:", err)
        return
    }
    statement.Exec(status, guid)
}

func (manager *DBManager) GetColorCode(clrId int) (code string) {
    Id := strconv.Itoa(clrId)
    query := "SELECT code FROM colors WHERE id = " + Id + " LIMIT 1 OFFSET 0;"
    fmt.Println(query)
    rows, err := manager.database.Query(query) 
    if err != nil {
        fmt.Println("Sqlite3 DB Query Error:", err)
        return
    }
    for rows.Next() {
        rows.Scan(&code)
    }
    return code
}

func (manager *DBManager) GetShapesColorsUsers(limit, offset int) (shapesgraphics []ShapeGraphic) {
    sLimit := strconv.Itoa(limit)
    sOffset := strconv.Itoa(offset)
    query := "SELECT shapes.id AS shape_id, shapes.name AS shape_name, graphics_colors_users.color_code AS color_code, graphics_colors_users.user_name AS user_name, graphics_colors_users.last_updated_at AS last_updated_at FROM shapes LEFT OUTER JOIN (SELECT graphics.shape_id AS grp_shape_id, colors.code AS color_code, users.name AS user_name, MAX(graphics.updated_at) AS last_updated_at FROM graphics INNER JOIN colors ON graphics.color_id = colors.id INNER JOIN users ON graphics.user_id = users.id GROUP BY graphics.shape_id) AS graphics_colors_users ON shapes.id = graphics_colors_users.grp_shape_id LIMIT " + sLimit + " OFFSET " + sOffset
    fmt.Println(query)
    rows, err := manager.database.Query(query) 
    if err != nil {
        fmt.Println("Sqlite3 DB Query Error:", err)
        return
    }
    var shape_id int
    var shape_name string
    var color_code string
    var user_name string
    var last_updated_at time.Time
    for rows.Next() {
        err = rows.Scan(&shape_id, &shape_name, &color_code, &user_name, &last_updated_at)
        if err != nil {
            fmt.Println(err)
            return
        }
        shgrp := ShapeGraphic{ShapeId: shape_id, ShapeName: shape_name, ColorCode: color_code, UserName: user_name, LastUpdatedAt: last_updated_at}
        fmt.Println(shgrp)
        shapesgraphics = append(shapesgraphics, shgrp)
    }
    rows.Close()
    return shapesgraphics
}
