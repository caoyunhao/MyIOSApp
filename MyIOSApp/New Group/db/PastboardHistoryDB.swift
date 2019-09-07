//
//  PastboardHistoryDB.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/8/5.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import UIKit
import SQLite3

struct PasteboardHistoryItem {
    var id: Int32?
    var text: String?
    var textMd5: String?
    var imageId: String?
    var image: UIImage?
    
    var creationDate: Date?
}

class PastboardHistoryDB {
    
    static let `default` = PastboardHistoryDB(filepath: "PastboardHistoryDB.sqlite")
    
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
        
        _ = dropTable()
        _ = creatTable()
    }
    
    let TABLE = "c_pastboard_history"
    
    func creatTable() -> Bool {
        let sql = """
        CREATE TABLE IF NOT EXISTS '\(TABLE)' (
        'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        'text' TEXT,
        'text_md5' TEXT,
        'image_md5' VARCHAR(255)
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
    
    func insert(imageMD5: String) -> Bool {
        return true
    }
    
    func query(byImageMD5: String) -> PasteboardHistoryItem? {
        return nil
    }
    
    func query(byTextMD5: String) -> PasteboardHistoryItem? {
        return nil
    }
    
    func queryAll() -> [PasteboardHistoryItem] {
        let sqlString = """
        SELECT \(TABLE).id,\(TABLE).text,\(TABLE).text_md5,\(TABLE).image_id,\(TABLE).creation_time
        FROM \(TABLE)
        WHERE \(TABLE).deleted=0
        ORDER BY \(TABLE).creation_time DESC;
        """
        
        guard let stmt = db.prepare(sql: sqlString) else {
            return []
        }
        
        var models = [PasteboardHistoryItem]()
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let text = String(cString: sqlite3_column_text(stmt, 1)!)
            let textMd5 = String(cString: sqlite3_column_text(stmt, 2)!)
            let imageId = String(cString: sqlite3_column_text(stmt, 3)!)
            let creationTime = String(cString: sqlite3_column_text(stmt, 4)!)
            
            let model = PasteboardHistoryItem(id: id, text: text, textMd5: textMd5, imageId: imageId, image: nil, creationDate: Date(timeIntervalSince1970: TimeInterval(creationTime)!))
            
            models.append(model)
        }
        
        DLog("Query all pasteboard history items. Count \(models.count)")
        
        return models
    }
    
    func delete(byId id: Int32) -> Bool {
        let sql = """
        UPDATE \(TABLE) SET deleted=1 where id=?;
        """
        
        guard let stmt = db.prepare(sql: sql) else {
            return false
        }
        
        sqlite3_bind_int(stmt, 1, id)
        
        return db.stepAndFinalize(stmt: stmt)
    }
}
