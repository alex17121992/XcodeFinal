//
//  ViewController3.swift
//  GestionAlumnos
//
//  Created by usuario on 19/02/2019.
//  Copyright © 2019 usuario. All rights reserved.
//

import UIKit
import SQLite3

class ViewController3: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtCurso: UITextField!
    @IBOutlet weak var txtCursoAcad: UITextField!
    @IBOutlet weak var txtNota: UITextField!
    var db: OpaquePointer?
    @IBOutlet weak var btnRegistrar: UIButton!
    
    @IBAction func btnRegistrar(_ sender: Any) {
        
        var stmt: OpaquePointer?
        var nombre = txtNombre.text
        var apell = txtApellidos.text
        var curso = txtCurso.text
        var cursoAcad = txtCursoAcad.text
        var nota = txtNota.text
        //the insert query
            let queryString = "INSERT INTO ALUMNOS (NOMBRE,APELLIDOS,CURSO,CURSOACAD,NOTAFINAL) VALUES ('"+nombre!+"','"+apell!+"','"+curso!+"','"+cursoAcad!+"','"+nota!+"')"
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
          txtNombre.text=""
          txtApellidos.text=""
          txtCurso.text=""
          txtCursoAcad.text=""
          txtNota.text=""
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
        btnRegistrar.layer.cornerRadius = 4
    }
    
}
