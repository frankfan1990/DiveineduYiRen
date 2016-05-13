//
//  FriendModel.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/3.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit

class FriendModel: NSObject,NSCoding {

    var address:String = ""
    var nickname:String = ""
    var username:String = ""
    
    init(address:String,nickname:String,username:String) {
        
        super.init()
        self.address = address
        self.nickname = nickname
        self.username = username
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.address = aDecoder.decodeObjectForKey("kaddress") as! String
        
        self.nickname = aDecoder.decodeObjectForKey("knickname") as! String
        
        self.username = aDecoder.decodeObjectForKey("kusername") as! String
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.address, forKey: "kaddress")
        aCoder.encodeObject(self.nickname, forKey: "knickname")
        aCoder.encodeObject(self.username, forKey: "kusername")
        
    }
    
    
}
