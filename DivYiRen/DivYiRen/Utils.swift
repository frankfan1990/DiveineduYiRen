//
//  Utils.swift
//  DivYiRen
//
//  Created by frankfan on 16/4/25.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import Foundation

struct Utils {
    
    static func dataToHexString(data:NSData)->NSString{
        
        var baseString = "\(data)" as NSString
        baseString = baseString.substringWithRange(NSRange(location: 1,length: baseString.length - 2))
        baseString = baseString.stringByReplacingOccurrencesOfString(" ", withString: "")
        return baseString
    }
    
    static func timeStamp_now()->Int{

        let timeInterVal = NSDate().timeIntervalSince1970
        return Int(timeInterVal)
    }
  
    
}