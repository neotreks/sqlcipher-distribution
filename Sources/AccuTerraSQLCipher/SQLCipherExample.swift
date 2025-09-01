import Foundation
import AccuTerraSQLCipher

/// Example usage of AccuTerraSQLCipher Swift Package
class SQLCipherExample {
    
    /// Demonstrates basic SQLCipher database operations
    static func example() {
        var db: OpaquePointer?
        let dbPath = NSTemporaryDirectory() + "test.db"
        
        // Open database
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            print("Database opened successfully")
            
            // Set encryption key
            let key = "your-encryption-key"
            if sqlite3_key(db, key, Int32(key.count)) == SQLITE_OK {
                print("Encryption key set successfully")
                
                // Create a test table
                let createTableSQL = """
                    CREATE TABLE IF NOT EXISTS users (
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        name TEXT NOT NULL,
                        email TEXT NOT NULL
                    );
                """
                
                if sqlite3_exec(db, createTableSQL, nil, nil, nil) == SQLITE_OK {
                    print("Table created successfully")
                    
                    // Insert test data
                    let insertSQL = "INSERT INTO users (name, email) VALUES (?, ?)"
                    var statement: OpaquePointer?
                    
                    if sqlite3_prepare_v2(db, insertSQL, -1, &statement, nil) == SQLITE_OK {
                        sqlite3_bind_text(statement, 1, "John Doe", -1, nil)
                        sqlite3_bind_text(statement, 2, "john@example.com", -1, nil)
                        
                        if sqlite3_step(statement) == SQLITE_DONE {
                            print("User inserted successfully")
                        }
                    }
                    sqlite3_finalize(statement)
                    
                    // Query data
                    let querySQL = "SELECT id, name, email FROM users"
                    if sqlite3_prepare_v2(db, querySQL, -1, &statement, nil) == SQLITE_OK {
                        while sqlite3_step(statement) == SQLITE_ROW {
                            let id = sqlite3_column_int(statement, 0)
                            let name = String(cString: sqlite3_column_text(statement, 1))
                            let email = String(cString: sqlite3_column_text(statement, 2))
                            print("User: \(id), \(name), \(email)")
                        }
                    }
                    sqlite3_finalize(statement)
                }
            } else {
                print("Failed to set encryption key")
            }
        } else {
            print("Failed to open database")
        }
        
        // Close database
        sqlite3_close(db)
    }
}
