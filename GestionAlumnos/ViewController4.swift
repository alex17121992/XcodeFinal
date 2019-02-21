//
//  ViewController4.swift
//  GestionAlumnos
//
//  Created by usuario on 19/02/2019.
//  Copyright © 2019 usuario. All rights reserved.
//

import UIKit
import SQLite3

class ViewController4: UIViewController {

    @IBOutlet weak var txtCodigo: UITextField!
    var db: OpaquePointer?
    @IBAction func btnBaja(_ sender: Any) {
        var stmt: OpaquePointer?
        var codigo = txtCodigo.text
        
        let queryString = "DELETE FROM ALUMNOS WHERE ID="+codigo!+""
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        txtCodigo.text=""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("alumnos.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS ALUMNOS (id INTEGER PRIMARY KEY AUTOINCREMENT, NOMBRE TEXT,APELLIDOS TEXT,CURSO TEXT,CURSOACAD TEXT,NOTAFINAL TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
       
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
