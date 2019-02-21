//
//  Alumno.swift
//  GestionAlumnos
//
//  Created by usuario on 19/02/2019.
//  Copyright © 2019 usuario. All rights reserved.
//

import Foundation

class Alumno {
    
    var id: Int
    var nombre: String?
    var apellidos: String?
    var curso: String?
    var cursoAcad: String?
    var nota: String?
    
    init(id: Int, nombre: String?,apellidos: String?,curso: String?,cursoAcad: String?,nota: String?){
        self.id = id
        self.nombre = nombre
        self.apellidos=apellidos
        self.curso=curso
        self.cursoAcad=cursoAcad
        self.nota=nota
    }
}
