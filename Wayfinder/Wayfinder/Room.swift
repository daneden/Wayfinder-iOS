//
//  Room.swift
//  Wayfinder
//
//  Created by Daniel Eden on 10/09/2014.
//  Copyright (c) 2014 Daniel Eden. All rights reserved.
//

import UIKit

class Room: NSObject {
    var name: String!
    var landmarks = []
    var size: String!
    var floor: String!
    
    init(json: Dictionary<String, AnyObject>) {
        name = json["name"] as! NSString as String
        landmarks = json["landmarks"] as! NSArray
        floor = json["floor"] as! NSString as String
        
    }
}
