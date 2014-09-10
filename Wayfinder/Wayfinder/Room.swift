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
        name = json["name"] as NSString
        landmarks = json["landmarks"] as NSArray
//        size = json["size"] as NSString
        floor = json["floor"] as NSString
        
        switch floor {
        case "B4":
            floor = "Berry St building, 4th floor"
        case "B5":
            floor = "Berry St building, 5th floor"
        case "W6":
            floor = "Wharfside building, 6th floor"
        default:
            floor = "Dropbox HQ"
        }
    }
}
