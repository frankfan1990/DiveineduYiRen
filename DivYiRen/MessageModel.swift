//
//  MessageModel.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/2.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit

enum MessageStyle:Int{
    case MessageStyeLeft = 1
    case MessageStyleRight = 2
}
class MessageModel: NSObject,NSCoding{

    var contents:String = ""
    var messageStyle:Int = 1
    
    init(contents:String,messageStyle:MessageStyle){
        
        self.contents = contents
        self.messageStyle = messageStyle.rawValue
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.contents = (aDecoder.decodeObjectForKey("kcontents") as? String)!
        
        self.messageStyle = aDecoder.decodeIntegerForKey("kstyle")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.contents, forKey: "kcontents")
        aCoder.encodeInteger(self.messageStyle, forKey: "kstyle")
    }
    
}





