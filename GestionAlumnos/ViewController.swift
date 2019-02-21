//
//  ViewController.swift
//  GestionAlumnos
//
//  Created by usuario on 19/02/2019.
//  Copyright © 2019 usuario. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    @IBOutlet weak var TrailingC: NSLayoutConstraint!
    var hamburguerMenuIsVisible = false
    var db: OpaquePointer?
    @IBAction func hamburguerBtnTapped(_ sender: Any) {
        if !hamburguerMenuIsVisible{
            LeadingC.constant = 200
            TrailingC.constant = -200
            hamburguerMenuIsVisible=true
        }else{
            LeadingC.constant = 0
            TrailingC.constant = 0
            hamburguerMenuIsVisible=false
        }
        UIView.animate(withDuration: 0.6, delay:0.0,options: .curveEaseIn,animations: {
            self.view.layoutIfNeeded()
        }){(animationComplete) in
            print("Animation is complete!")
        }
    }
    @IBOutlet weak var LeadingC: NSLayoutConstraint!
   
    
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
    
}



