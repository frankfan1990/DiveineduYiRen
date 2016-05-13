//
//  KeepLoginedManager.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/7.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Alamofire


/*保持登陆功能先不实现*/
class KeepLoginedManager{

    static let shareLoginedManager = KeepLoginedManager()
    private init(){}
    
    
    typealias fType = ()->Void
    
    
    func getCaptchaWithUserModel(usermodel:UserModel){
        

    }
    
    func loginWithCaptcha(captch:String){
    
        
    }
    
    
    func keepLogined(){
    
        #if false
        let userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        let password_md5Value = ConstantPara.cachedObjForKey(ConstantPara.password_md5_cachedKey) as! String
        #endif
    }
    
    
    
    
    
    
    
}
