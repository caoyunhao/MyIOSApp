//
//  sqlite3.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/21.
//  Copyright © 2019 Yunhao. All rights reserved.
//
import Foundation
import SQLite3

class User {
    let id = SQLiteField<Int>()
    
    func getAllPropertys() -> [String] {
        var result = [String]()
        let count = UnsafeMutablePointer<UInt32>.allocate(capacity: 0)
        let buff = class_copyPropertyList(object_getClass(self), count)
        let countInt = Int(count[0])
        for i in 0..<countInt {
            let temp = buff![i]
            let tempPro = property_getName(temp)
            let proper = String(utf8String: tempPro)
            result.append(proper!)
        }
        return result
    }
}

class SQLite {
    
}

class SQLiteField<FieldType: SQLiteType> {
    
    
}

protocol SQLiteType {
    associatedtype T

    func decode() -> T
}

extension String: SQLiteType {
    typealias T = String
    
    func decode() -> String {
        return ""
    }
}

extension Int: SQLiteType {
    typealias T = Int
    
    func decode() -> Int {
        return 0
    }
}

extension Bool: SQLiteType {
    typealias T = Bool
    
    func decode() -> Bool {
        return false
    }
}

extension Date: SQLiteType {
    typealias T = Date
    
    func decode() -> Date {
        return Date()
    }
}

extension UInt8: SQLiteType {
    typealias T = UInt8
    
    func decode() -> UInt8 {
        return 0
    }
}

class SQLiteDB {
    private var db: OpaquePointer!
    
    init(filename: String) {
        DLog("SQLiteDB filename: \(filename)")
        let state = sqlite3_open(filename.cString(using: .utf8), &db)
        if state != SQLITE_OK {
            DLog("打开数据库失败")
        }
    }
    
    func deleteTable(tableName: String) -> Bool {
        let sql = """
        DROP TABLE '\(tableName)'
        """
        return execSql(sql: sql)
    }
    
    func execSql(sql:String) -> Bool {
        let csql = sql.cString(using: .utf8)
        let isSuccess = sqlite3_exec(db, csql, nil, nil, nil) == SQLITE_OK
        if isSuccess {
            DLog("[SQL]执行成功\n---\n\(sql)\n\\--")
        } else {
            DLog("[SQL]执行失败!!!\(errmsg())\n\(sql)")
        }
        return isSuccess
    }
    
    func prepare(sql: String) -> OpaquePointer? {
        var stmt:OpaquePointer? = nil
        
        DLog("prepare sql\n---\n\(sql)\n\\--")
        
        if sqlite3_prepare_v2(db, sql.cString(using: .utf8), -1, &stmt, nil) != SQLITE_OK {
            DLog("未准备好, \(String(describing: stmt))")
            return nil
        }
        if stmt == nil {
            DLog("stmt == nil")
            return nil
        }
        return stmt
    }
    
    func stepAndFinalize(stmt: OpaquePointer) -> Bool {
        let result = sqlite3_step(stmt)
        
        if result != SQLITE_DONE {
            DLog("result: \(result), errMsg: \(errmsg())")
        }
        
        sqlite3_finalize(stmt)
        
        return result == SQLITE_DONE
    }
    
    func transaction(exec: () -> Bool) -> Bool {
        if execSql(sql: "BEGIN TRANSACTION") {
            let re = exec()
            if re && execSql(sql: "COMMIT TRANSACTION") {
                DLog("COMMIT success")
                return true
            } else {
                if execSql(sql: "ROLLBACK TRANSACTION") {
                    DLog("ROLLBACK success")
                }
            }
        } else {
            if execSql(sql: "ROLLBACK TRANSACTION") {
                DLog("ROLLBACK success")
                
            }
        }
        return false
    }
    
    func finalize(stmt: OpaquePointer) {
        sqlite3_finalize(stmt)
    }
    
    func errmsg() -> String {
        return String(cString: sqlite3_errmsg(db))
    }
    
    func close() -> Bool {
        return sqlite3_close(db) == SQLITE_OK
    }
}
