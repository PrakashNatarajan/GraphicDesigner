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


