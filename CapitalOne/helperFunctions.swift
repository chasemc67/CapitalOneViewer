//
//  helperFunction.swift
//  CapitalOne
//
//  Created by Chase McCarty on 2015-08-24.
//  Copyright (c) 2015 Chase McCarty. All rights reserved.
//

import Foundation

func isInteger(char: String) -> Bool{
    var numbers: String = "0123456789.,"
    if numbers.rangeOfString(char) != nil{
        return true
    } else {
        return false
    }
}