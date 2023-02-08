//
//  DBManager.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 1/17/23.
//

import Foundation
import SQLite3
    
class DBManager
{
    init()
    {
        db = openDatabase()
        createTable()
    }
  
  
    let dbPath: String = "usersDB.sqlite"
    var db:OpaquePointer?
  
  
    func openDatabase() -> OpaquePointer?
    {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
        print(filePath)
        var db: OpaquePointer? = nil
        
       // let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
       //     .appendingPathComponent(dbPath)
       //var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK
        {
            debugPrint("can't open database")
            return nil
        }
        else
        {
            print("Successfully created connection to database at \(dbPath)")
            return db
        }
    }
      
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user(Id INTEGER PRIMARY KEY, name TEXT, email TEXT, age INTEGER, weight DOUBLE, split TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user table created.")
            } else {
                print("user table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insert(name: String, email: String) {
        let users = read()
        for user in users {
            if user.email == email {
                print("User already Exists")
                return
            }
        }
        let highestId = users.map { $0.id }.max() ?? 0
        let insertStatementString = "INSERT INTO user (Id, name, email) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(highestId + 1))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (email as NSString).utf8String, -1, nil)

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
      
    func read(id: Int? = nil) -> [User] {
        var queryStatementString = "SELECT * FROM user"
        if id != nil {
            queryStatementString += " WHERE id = \(id!)"
        }
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let email = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let age = sqlite3_column_int(queryStatement, 3)
                let weight = sqlite3_column_double(queryStatement, 4)

                let split =  sqlite3_column_text(queryStatement, 5)
                var splitValue = [String]()
                    
                    if let split = split {
                        do {
                            let splitData = Data(bytes: split, count: Int(strlen(split)))
                            splitValue = try JSONDecoder().decode([String].self, from: splitData)
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                let splitString = splitValue.joined(separator: ",")
                
                users.append(User(id: Int(id), name: name, age: Int(age), email: email, weight: weight, split: splitString))
                
                print("Query Result:")
                print("\(id) | \(name) | \(age) | \(weight) | \(String(describing: split)) | \(email)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
    func update(id: Int, age: Int? = nil, weight: Double? = nil, split: [String]? = nil) {
        let updateStatementString = "UPDATE user SET age = ?, weight = ?, split = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if let age = age {
                sqlite3_bind_int(updateStatement, 1, Int32(age))
            } else {
                sqlite3_bind_null(updateStatement, 1)
            }
            if let weight = weight {
                sqlite3_bind_double(updateStatement, 2, Double(Int32(weight)))
            } else {
                sqlite3_bind_null(updateStatement, 2)
            }
            if let split = split {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: split, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: .utf8)
                    sqlite3_bind_text(updateStatement, 3, (jsonString! as NSString).utf8String, -1, nil)
                } catch {
                    print("Error: \(error)")
                    sqlite3_bind_null(updateStatement, 3)
                }
            } else {
                sqlite3_bind_null(updateStatement, 3)
            }
            
            sqlite3_bind_int(updateStatement, 4, Int32(id))

            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
        }
        sqlite3_finalize(updateStatement)
    }
      
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
      
}

