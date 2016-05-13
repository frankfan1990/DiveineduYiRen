//
//  LightDataCache.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/25.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit

class LightDataCache: NSObject {

    
    let isLogSucc = "isLogSucc"

    func recodeCacheData(data:AnyObject?,key:String)->Bool{
        if(data == nil){
            return false
        }
        NSUserDefaults().setObject(data, forKey: key)
        return true
    }
    
    func keyOfDataBeThere(key:String)->Bool{
        
        let result = NSUserDefaults().objectForKey(key)
        if(result != nil){
            
            return true
        }else{
            
            return false
        }
    }
    
    
}
