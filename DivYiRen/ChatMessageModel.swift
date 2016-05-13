//
//  ChatMessageModel.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/5.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit

class ChatMessageModel: NSObject{

    var from = ""
    var to = ""
    var timestamp:Int = 0
    var msgtype = ""
    var msgcontent = ""
    
    init(from:String,to:String,timestamp:Int,msgtype:String = "text",msgcontent:String){
    
        super.init()
        self.from = from
        self.to = to
        self.timestamp = timestamp
        self.msgtype = msgtype
        self.msgcontent = msgcontent
       
    }
    
    //
    static func messageModelWithDict(dict:NSDictionary)->ChatMessageModel{
        
        let tempChatMessageModel = ChatMessageModel(from: dict["from"] as! String, to: dict["to"] as! String, timestamp: dict["timestamp"] as! Int, msgtype: dict["msgtype"] as! String, msgcontent: dict["msgcontent"] as! String)
        
        return tempChatMessageModel
    }
    
    
    
    
    #if false
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        self.from = aDecoder.decodeObjectForKey("kfrom") as! String
        self.to = aDecoder.decodeObjectForKey("kto") as! String
        self.timestamp = aDecoder.decodeIntegerForKey("ktime") 
        self.msgtype = aDecoder.decodeObjectForKey("ktype") as! String
        self.msgcontent = aDecoder.decodeObjectForKey("kcontent") as! String
       
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.from, forKey: "kfrom")
        aCoder.encodeObject(self.to, forKey: "kto")
        aCoder.encodeInteger(self.timestamp, forKey: "ktime")
        aCoder.encodeObject(self.msgtype, forKey: "ktype")
        aCoder.encodeObject(self.msgcontent, forKey: "kcontent")
       
    }
    #endif
    
    
    
    
    
    
}
