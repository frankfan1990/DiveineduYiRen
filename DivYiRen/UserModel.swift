//
//  UserModel.swift
//  DivYiRen
//
//  Created by frankfan on 16/4/30.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import Foundation
class UserModel:NSObject,NSCoding{
    
    var userName:NSString
    var session_token:NSString
    
    init(userName:String,session_token:String){

        self.userName = userName
        self.session_token = session_token
    }
    
    required init?(coder aDecoder: NSCoder) {
    
       
        self.userName = (aDecoder.decodeObjectForKey("kname") as? NSString)!
        self.session_token = (aDecoder.decodeObjectForKey("ksession") as? NSString)!
        
        
    
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.userName, forKey: "kname")
        aCoder.encodeObject(self.session_token, forKey: "ksession")
    }

}





