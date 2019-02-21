//
//  ViewController5.swift
//  GestionAlumnos
//
//  Created by usuario on 19/02/2019.
//  Copyright © 2019 usuario. All rights reserved.
//

import UIKit
import SQLite3
class ViewController5: UIViewController {
    var db: OpaquePointer?
    var alumno : Alumno?

    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtApell: UILabel!
    @IBOutlet weak var txtCurso: UILabel!
    @IBOutlet weak var txtCursoAcad: UILabel!
    @IBOutlet weak var txtNota: UILabel!
    @IBOutlet weak var txtId: UILabel!
    
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
        readValues()

    }
    func readValues(){
        
        //this is our select query
        let queryString = "SELECT * FROM ALUMNOS WHERE ID=" + String(alumno!.id)
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let nombre = String(cString: sqlite3_column_text(stmt, 1))
            let apell = String(cString: sqlite3_column_text(stmt, 2))
            let curso = String(cString: sqlite3_column_text(stmt, 3))
            let cursoAcad = String(cString: sqlite3_column_text(stmt, 4))
            let nota = String(cString: sqlite3_column_text(stmt, 5))
            txtId.text=String(id)
            txtNombre.text=nombre
            txtApell.text=apell
            txtCurso.text=curso
            txtCursoAcad.text=cursoAcad
            txtNota.text=nota
            
        }
    }
}
