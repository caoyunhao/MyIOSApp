//
//  TodoDB.swift
//  MyIOSApp
//
//  Created by Yunhao on 2019/7/22.
//  Copyright © 2019 Yunhao. All rights reserved.
//

import Foundation
import SQLite3

struct Task {
    var id: Int32!
    var title: String
    var detail: String
    var importent: Int32
    var emergency: Int32
    
    var projectId: Int32
    var projectName: String
    
    var kindId: Int32
    var kindName: String
}

struct Project {
    var id: Int32
    var name: String
    
    var kindId: Int32
    var kindName: String
}

struct Kind {
    var id: Int32
    var name: String
}

class TodoDB {
    static let `default` = TodoDB(filename: "todo.sqlite")
    
    private var filename: String
//    private var db: OpaquePointer!
    private var db: SQLiteDB!

    init(filename: String) {
        self.filename = filename
    }
    
    private lazy var filePath: String = {
        let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        return filePath + "/" + self.filename
    }()
    
    func open() {
        if db == nil {
            db = SQLiteDB(filename: filePath)
            _ = deleteAllTables()
            _ = creatAllTables()
            
            if insertSimpleData() {
                DLog("insert simple data success.")
            } else {
                DLog("insert simple data failed.")
            }
        }
    }
    
    // 创建与删除
    let T_Task = "c_task"
    let T_Kind = "c_kind"
    let T_Project = "c_project"
    let TR_ProjectKind = "c_r_project_kind"
    let TR_TaskProject = "c_r_task_project"
    
    func deleteAllTables() -> Bool {
        return deleteTaskTable() &&
        deleteProjectTable() &&
        deleteKindTable() &&
        deleteTaskProjectTable() &&
        deleteProjectKindTable()
    }
    
    func creatAllTables() -> Bool {
        return creatTaskTable()
        && creatProjectTable()
        && creatKindTable()
        && creatTaskProjectTable()
        && creatProjectKindTable()
    }
    
    func insertSimpleData() -> Bool {
        return addKind(name: "拼多多工作")
        && addProject(name: "DMP", kindId: Int32(1))
    }
    
    func creatTaskTable() -> Bool {
        let sql = """
        CREATE TABLE IF NOT EXISTS '\(T_Task)' (
            'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            'title' TEXT NOT NULL,
            'detail' TEXT NOT NULL DEFAULT '',
            'importent' int NOT NULL DEFAULT 0,
            'emergency' int NOT NULL DEFAULT 0,
            'deleted' tinyint(4) NOT NULL DEFAULT 0,
            'creation_time' TIMESTAMP NOT NULL DEFAULT current_timestamp,
            'modification_time' TIMESTAMP NOT NULL DEFAULT current_timestamp
        )
        """
        return db.execSql(sql: sql)
    }
    
    func deleteTaskTable() -> Bool {
        return db.deleteTable(tableName: T_Task)
    }
    
    func creatKindTable() -> Bool {
        let sql = """
        CREATE TABLE IF NOT EXISTS '\(T_Kind)' (
            'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            'name' TEXT NOT NULL,
            'deleted' tinyint(4) NOT NULL DEFAULT 0,
            'creation_time' TIMESTAMP NOT NULL DEFAULT current_timestamp,
            'modification_time' TIMESTAMP NOT NULL DEFAULT current_timestamp
        )
        """
        return db.execSql(sql: sql)
    }
    
    func deleteKindTable() -> Bool {
        return db.deleteTable(tableName: T_Kind)
    }
    
    func creatProjectTable() -> Bool {
        let sql = """
        CREATE TABLE IF NOT EXISTS '\(T_Project)' (
            'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            'name' TEXT NOT NULL,
            'deleted' tinyint(4) NOT NULL DEFAULT 0,
            'creation_time' TIMESTAMP NOT NULL DEFAULT current_timestamp,
            'modification_time' TIMESTAMP NOT NULL DEFAULT current_timestamp
        )
        """
        return db.execSql(sql: sql)
    }
    
    func deleteProjectTable() -> Bool {
        return db.deleteTable(tableName: T_Project)
    }
    
    // 关联表
    
    func creatProjectKindTable() -> Bool {
        let sql = """
        CREATE TABLE IF NOT EXISTS '\(TR_ProjectKind)' (
            'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            'pid' INTEGER NOT NULL,
            'kid' INTEGER NOT NULL,
            'deleted' tinyint(4) NOT NULL DEFAULT 0,
            'creation_time' TIMESTAMP NOT NULL DEFAULT current_timestamp,
            'modification_time' TIMESTAMP NOT NULL DEFAULT current_timestamp
        )
        """
        return db.execSql(sql: sql)
    }
    
    func deleteProjectKindTable() -> Bool {
        return db.deleteTable(tableName: TR_ProjectKind)
    }
    
    func creatTaskProjectTable() -> Bool {
        let sql = """
        CREATE TABLE IF NOT EXISTS '\(TR_TaskProject)' (
            'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            'tid' INTEGER NOT NULL,
            'pid' INTEGER NOT NULL,
            'deleted' tinyint(4) NOT NULL DEFAULT 0,
            'creation_time' TIMESTAMP NOT NULL DEFAULT current_timestamp,
            'modification_time' TIMESTAMP NOT NULL DEFAULT current_timestamp
        )
        """
        return db.execSql(sql: sql)
    }
    
    func deleteTaskProjectTable() -> Bool {
        return db.deleteTable(tableName: TR_TaskProject)
    }
    
    // query
    
    func queryTasks() -> [Task] {
        DLog("query tasks")
        
        let sql = """
        SELECT \(T_Task).id,\(T_Task).title,\(T_Task).detail,\(T_Task).importent,\(T_Task).emergency,
        \(T_Project).`id`,\(T_Project).`name`,
        \(T_Kind).id,\(T_Kind).`name`
        FROM `\(T_Task)`
        LEFT JOIN \(TR_TaskProject)
        ON \(TR_TaskProject).tid = \(T_Task).id
        LEFT JOIN \(T_Project)
        ON \(T_Project).id = \(TR_TaskProject).pid
        LEFT JOIN \(TR_ProjectKind)
        ON \(TR_ProjectKind).pid = \(T_Project).id
        LEFT JOIN \(T_Kind)
        ON \(T_Kind).id = \(TR_ProjectKind).kid
        WHERE \(T_Task).deleted=0
        ORDER BY \(T_Task).creation_time DESC;
        """
        
        guard let stmt = db.prepare(sql: sql) else {
            return []
        }
        
        DLog("query start")
        
        var ret = [Task]()
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1)!)
            let detail = String(cString: sqlite3_column_text(stmt, 2)!)
            let importent = sqlite3_column_int(stmt, 3)
            let emergency = sqlite3_column_int(stmt, 4)
            let pid = sqlite3_column_int(stmt, 5)
            let pname = String(cString: sqlite3_column_text(stmt, 6)!)
            let kid = sqlite3_column_int(stmt, 7)
            let kname = String(cString: sqlite3_column_text(stmt, 8)!)
            
            let task = Task(id: id, title: title, detail: detail, importent: importent, emergency: emergency, projectId: pid, projectName: pname, kindId: kid, kindName: kname)
            
            ret.append(task)
        }
        
        return ret
    }
    
    func addTask(title: NSString,
                 detail: NSString,
                 importent: Int32,
                 emergency: Int32,
                 projectId: Int32) -> Bool {
        return db.transaction(exec: { () -> Bool in
            let sql = """
            INSERT INTO \(T_Task) (`title`, `detail`,`importent`,`emergency`)
            VALUES (?1,?2,?3,?4);
            """
            
            guard let stmt = db.prepare(sql: sql) else {
                return false
            }
            
            sqlite3_bind_text(stmt, 1, title.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, detail.utf8String, -1, nil)
            sqlite3_bind_int(stmt, 3, importent)
            sqlite3_bind_int(stmt, 4, emergency)
            
            if db.stepAndFinalize(stmt: stmt) {
                let sql = """
                INSERT INTO \(TR_TaskProject) (`pid`, `tid`)
                VALUES (?1, LAST_INSERT_ROWID());
                """
                
                guard let stmt = db.prepare(sql: sql) else {
                    return false
                }
                sqlite3_bind_int(stmt, 1, projectId)
                
                return db.stepAndFinalize(stmt: stmt)
            }
            
            return false
        })
    }
    
    // project
    
    func queryProjectKinds() {
        let sql = """
        SELECT COUNT(*) FROM \(TR_ProjectKind);
        """
        
        guard let stmt = db.prepare(sql: sql) else {
            return
        }
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let cnt = sqlite3_column_int(stmt, 0)
            DLog("project kind count: \(cnt)")
        }

        sqlite3_finalize(stmt)
    }
    
    func queryProjects() -> [Project] {
        queryProjectKinds()
        
        let sql = """
        SELECT \(T_Project).`id`,\(T_Project).`name`,\(T_Kind).id,\(T_Kind).`name`
        FROM \(T_Project)
        LEFT JOIN \(TR_ProjectKind)
        ON \(TR_ProjectKind).pid = \(T_Project).id
        LEFT JOIN \(T_Kind)
        ON \(T_Kind).id = \(TR_ProjectKind).kid
        WHERE \(T_Project).deleted=0
        ORDER BY \(T_Project).creation_time DESC;
        """
        
        guard let stmt = db.prepare(sql: sql) else {
            return []
        }
        
        return parseProjectRows(stmt: stmt)
    }

    func queryProjects(byKindId kindId: Int32) -> [Project] {
        let sql = """
        SELECT \(T_Project).`id`,\(T_Project).`name`,\(T_Kind).id,\(T_Kind).`name`
        FROM \(T_Project)
        LEFT JOIN \(TR_ProjectKind)
        ON \(TR_ProjectKind).pid = \(T_Project).id
        LEFT JOIN \(T_Kind)
        ON \(T_Kind).id = \(TR_ProjectKind).kid
        WHERE \(T_Project).deleted=0 AND \(T_Kind).id=?1
        ORDER BY \(T_Project).creation_time DESC;
        """
        
        guard let stmt = db.prepare(sql: sql) else {
            return []
        }
        
        sqlite3_bind_int(stmt, 1, kindId)
        
        return parseProjectRows(stmt: stmt)
    }
    
    private func parseProjectRows(stmt: OpaquePointer) -> [Project] {
        var ret = [Project]()
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1)!)
            let kid = sqlite3_column_int(stmt, 2)
            let kname = String(cString: sqlite3_column_text(stmt, 3)!)
            
            let model = Project(id: id, name: name, kindId: kid, kindName: kname)
            ret.append(model)
        }
        
        DLog("projects count: \(ret.count)")
        
        sqlite3_finalize(stmt)
        
        return ret
    }
    
    func addProject(name: String, kindId: Int32) -> Bool {
        return db.transaction(exec: { () -> Bool in
            let sql = """
            INSERT INTO \(T_Project) (`name`)
            VALUES (?1);
            """
            
            guard let stmt = db.prepare(sql: sql) else {
                return false
            }
            
            let name = name as NSString
            
            sqlite3_bind_text(stmt, 1, name.utf8String, -1, nil)
            
            if db.stepAndFinalize(stmt: stmt) {
                let sql = """
                INSERT INTO \(TR_ProjectKind) (`pid`, `kid`)
                VALUES (LAST_INSERT_ROWID(), ?1);
                """
                
                guard let stmt2 = db.prepare(sql: sql) else {
                    return false
                }
                sqlite3_bind_int(stmt2, 1, 1)
                
                return db.stepAndFinalize(stmt: stmt2)
            }
            
            return false
        })
    }
    
    func addKind(name: String) -> Bool {
        let sql = """
        INSERT INTO c_kind (name) VALUES (?);
        """
        
        guard let stmt = db.prepare(sql: sql) else {
            return false
        }
        
        let name = name as NSString
        
        sqlite3_bind_text(stmt, 1, name.utf8String, -1, nil)
        
        return db.stepAndFinalize(stmt: stmt)
    }
    
    func queryKinds() -> [Kind] {
        let sql = """
        SELECT \(T_Kind).id,\(T_Kind).`name`
        FROM \(T_Kind)
        WHERE \(T_Kind).deleted=0
        ORDER BY \(T_Kind).creation_time DESC;
        """
        
        guard let stmt = db.prepare(sql: sql) else {
            return []
        }
        
        var ret = [Kind]()
        
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1)!)
            
            let model = Kind(id: id, name: name)
            ret.append(model)
        }
        
        sqlite3_finalize(stmt)
        
        return ret
    }
    
    func delete(taskId: Int32) -> Bool {
        return db.transaction(exec: {
            let sql = """
            UPDATE \(T_Task) SET deleted=1 where id=?;
            """
            
            guard let stmt = db.prepare(sql: sql) else {
                return false
            }
            
            sqlite3_bind_int(stmt, 1, taskId)
            
            if db.stepAndFinalize(stmt: stmt) {
                let sql = """
                UPDATE \(TR_TaskProject) SET deleted=1 where tid=?;
                """
                guard let stmt = db.prepare(sql: sql) else {
                    return false
                }
                sqlite3_bind_int(stmt, 1, taskId)
                return db.stepAndFinalize(stmt: stmt)
            }
            return false
        })
    }
}
