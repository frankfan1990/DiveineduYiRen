//
//  ChatHistoryListModel.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/8.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit

class ChatHistoryListModel: NSObject,NSCoding{

    var friendName:String = ""
    var message:String = ""
    
    init(friendName:String,message:String) {
        
        self.friendName = friendName
        self.message = message
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.friendName = aDecoder.decodeObjectForKey("kname") as! String
        self.message = aDecoder.decodeObjectForKey("kmessage") as! String
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.friendName, forKey: "kname")
        aCoder.encodeObject(self.message, forKey: "kmessage")
        
    }
}
