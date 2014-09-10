//
//  ArrayExtension.swift
//  Wayfinder
//
//  Created by Daniel Eden on 9/10/14.
//  Copyright (c) 2014 Daniel Eden. All rights reserved.
//

import Foundation

extension Array {
    func combine(separator: String) -> String{
        var str : String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count-1 {
                str += separator
            }
        }
        return str
    }
}