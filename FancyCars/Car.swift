//
//  Car.swift
//  FancyCars
//
//  Created by Michael Chung on 4/24/19.
//  Copyright © 2019 Michael Chung. All rights reserved.
//

import Foundation


class Car: Codable {
    var id:Int
    var img:String
    var name:String
    var make:String
    var model:String
    var year:Int
    var available: String?
}

class Availability: Codable {
    var available: String
    var id: Int
}
