//
//  UserModel.swift
//  Fitness and Nutrition Personal Project
//
//  Created by Matthew Ramirez on 1/17/23.
//

import Foundation
  
class User
{
      
    var name: String = ""
    var email: String = ""
    var age: Int = 0
    var weight: Double = 0.0
    var split: Dictionary = ["Mon": "", "Tue": "", "Wed": "", "Thu": "", "Fri": "", "Sat": "", "Sun": "", ]
    var id: Int = 0
      
    init(id:Int, name:String, age:Int, email:String) {
        self.id = id
        self.name = name
        self.age = age
        self.email = email
    }
}
