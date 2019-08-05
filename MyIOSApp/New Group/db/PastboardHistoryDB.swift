//
//  PastboardHistoryDB.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/5.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation

class PastboardHistoryDB {
    
    private var filename: String
    private var db: SQLiteDB!
    
    init(filepath: String) {
        self.filename = filepath
    }
    
    private lazy var filePath: String = {
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return filePath + "/" + self.filename
    }()
    
    func open() {
        if db == nil {
            db = SQLiteDB(filename: filePath)
        }
    }
    
    let TABLE = "c_pastboard_history"
    
    func creatTable() -> Bool {
        let sql = """
        CREATE TABLE IF NOT EXISTS '\(TABLE)' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        'text' TEXT NOT NULL DEFAULT '',
        'text_md5' TEXT NOT NULL DEFAULT '',
        'image_id' INTEGER NOT NULL DEFAULT 0,
        'deleted' tinyint(4) NOT NULL DEFAULT 0,
        'creation_time' TIMESTAMP NOT NULL DEFAULT current_timestamp,
        'modification_time' TIMESTAMP NOT NULL DEFAULT current_timestamp
        )
        """
        return db.execSql(sql: sql)
    }
    
    func dropTable() -> Bool {
        return db.dropTable(tableName: TABLE)
    }
    
    func has(textMd5: String) -> Bool {
        return false
    }
    
    func insert(text: String, textMd5: String) -> Bool {
        return true
    }
    
    func insert(imageId: Int32) -> Bool {
        return true
    }
}
