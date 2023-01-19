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
    var age: Int?
    var weight: Double?
    var split: String? 
    var id: Int = 0
      
    init(id:Int, name:String, age:Int?, email:String, weight:Double?, split: String? ) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.weight = weight
        self.split = split
        
    }
}
