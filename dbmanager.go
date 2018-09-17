package main

import (
	"fmt"
	"database/sql"
    _ "github.com/mattn/go-sqlite3"
    "strconv"
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

func (manager *DBManager) CreateRecord(guid, sender, receiver, content int) {
    statement, err := manager.database.Prepare("INSERT OR REPLACE INTO messages (guid, sender, receiver, content, status) VALUES (?, ?, ?, ?, ?)")
    if err != nil {
        fmt.Println("Sqlite3 DB Insert Error:", err)
        return
    }
    statement.Exec(guid, sender, receiver, content, "UnSent")
}

func (manager *DBManager) UpdateRecord(guid, status string) {
    statement, err := manager.database.Prepare("UPDATE messages SET status = ? WHERE guid = ?")
    if err != nil {
        fmt.Println("Sqlite3 DB Update Error:", err)
        return
    }
    statement.Exec(status, guid)
}

func (manager *DBManager) GetRecordStatus(guid int) (status string) {
    Id := strconv.Itoa(guid)
    query := "SELECT status FROM messages WHERE guid = " + Id + " LIMIT 1 OFFSET 0;"
    fmt.Println(query)
    rows, err := manager.database.Query(query) 
    if err != nil {
        fmt.Println("Sqlite3 DB Query Error:", err)
        return
    }
    for rows.Next() {
        rows.Scan(&status)
    }
    return status
}


