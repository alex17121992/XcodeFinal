//
//  ViewController2.swift
//  GestionAlumnos
//
//  Created by usuario on 19/02/2019.
//  Copyright © 2019 usuario. All rights reserved.
//

import UIKit
import SQLite3

class ViewController2: UIViewController {

    @IBOutlet weak var alumnosSearch: UISearchBar!
    
    @IBOutlet weak var tblAlumnos: UITableView!

    var db: OpaquePointer?
    var alumnos=[Alumno]()
    var searchedAlumno = [Alumno]()
    var searching = false
    var  currentItem :String?
    var alumno : Alumno?
    
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
}
extension ViewController2: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedAlumno.count
        } else {
            return alumnos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if searching {
            cell?.textLabel?.text = searchedAlumno[indexPath.row].nombre
        } else {
            cell?.textLabel?.text = alumnos[indexPath.row].nombre
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            alumno=alumnos[indexPath.row]
            alumnos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            deleteElementFromDataBase(cod: (alumno?.id)!)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath=tableView.indexPathForSelectedRow
        alumno=alumnos[indexPath!.row]
        let currentCell=tableView.cellForRow(at: indexPath!)! as UITableViewCell
        currentItem=currentCell.textLabel!.text
        alumnosSearch.text=currentItem
        performSegue(withIdentifier: "detalles", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalles"{
            if let viewChat = segue.destination as? ViewController5{
                viewChat.alumno = alumno
            }
        }
    }
    
    func deleteElementFromDataBase(cod:Int){
        var stmt: OpaquePointer?
        var codigo = String(cod)
        print(codigo)
        let queryString = "DELETE FROM ALUMNOS WHERE ID="+codigo+""
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
    }
    
}
extension ViewController2: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tblAlumnos.isHidden=false
        searchedAlumno = alumnos.filter({$0.nombre!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tblAlumnos.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tblAlumnos.isHidden=true
        searching = false
        alumnosSearch.text = ""
        tblAlumnos.reloadData()
    }
    
    func readValues(){
        
        
        //this is our select query
        let queryString = "SELECT * FROM ALUMNOS"
        
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
            if sqlite3_column_text(stmt, 4) != nil{
            let cursoAcad = String(cString: sqlite3_column_text(stmt, 4))
            let nota = String(cString: sqlite3_column_text(stmt, 5))
        alumnos.append(Alumno(id:Int(id),nombre:nombre,apellidos:apell,curso:curso,cursoAcad:cursoAcad,nota:nota))
            }
        }
        
    }
}

