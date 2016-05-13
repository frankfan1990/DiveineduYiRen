//
//  ConstantPara.swift
//  DivYiRen
//
//  Created by frankfan on 16/4/25.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import Foundation

/**
 *  @author frankfan, 16-04-25 10:04:07
 *
 *  这个文件中是一些常量key/[宏信息],以及对这些信息的操作
 */

struct ConstantPara {
    
    
    static private let baseDocPath = NSHomeDirectory().stringByAppendingString("/Documents")
    
    static let notiKey = "changeViewController"
    static let loginedKey = "username"
    static let device_token = "device_token"
    static let session_token = "session_token"
    static let password = "password"
    static let captcha_value = "captcha_value"
    static let platform = "platform"
    static let type = "type"
    static let friend = "friend"//添加好友时的字段
    static let status = "status"
    static let friendListCachedKey = "friendListCachedKey"
    static let friendsKey = "friends"
    
    static let address = "address"
    static let nickname = "nickname"
    static let username = "username"
    
    static let verify_friends = "verify_friends"
    static let verifyCachedKey = "verifyCachedKey"
    static let verify_notiKey = "verify_notiKey" //当验证请求回调完成时，发送同步更新的消息
    
    static let synFriendsListKey = "synFriendsListKey"
    
    static let messageHistoryKey = "messageHistoryKey"
    
    static let chatSynNotiKey = "chatSynNotiKey" //聊天ing同步通知key
    
    static let unreadMessageCacheKey = "unreadMessageCacheKey"
    
    static let password_md5_cachedKey = "password_md5_cachedKey"
    
    static let chatHistoryListCache = "chatHistoryListCache"
    
    
    
    
    /// 请求接口
    static let serverHost = "http://vpn.diveinedu.com:8080"
    static let registerAPI = serverHost + "/captcha/" //post_获取验证码
    static let registerAPI2 = serverHost + "/register/" //post_注册接口
    static let loginAPI = serverHost + "/login/" //post_登陆接口
    
    static let logoutAPI = serverHost + "/logout/" //post_注销
    
    static let getFriendAPI = serverHost + "/friend/get" //post_获取朋友列表
    
    static let addFriendAPI = serverHost + "/friend/add"//post_添加朋友
    
    static let delFriendAPI = serverHost + "/friend/del"//post_删除好友
    
    static let offlineMessage = serverHost + "/offline_msg/"//post_离线消息
    
    //socket接口
    static let baseSocketChatAPI = serverHost + "/chat"
    
    
    static func isKeyCached(key:String)->Bool{
        
        let testPath = baseDocPath + "/" + key
         print(testPath)
        if(NSFileManager.defaultManager().fileExistsAtPath(testPath) == true){
        
            return true
            
        }else{
        
            return false
        }
       

        /*
        let obj =  NSUserDefaults.standardUserDefaults().objectForKey(key)
        guard let _ = obj else{
        
            return false
        }
        
        return true
         */
    }
    
    static func keyCaching(key:String,withObj obj:AnyObject)->Bool{
        
        if isKeyCached(key) == true{
        
            return false
        }
        
        let cachePath = baseDocPath + "/" + key

        NSKeyedArchiver.archiveRootObject(obj, toFile: cachePath)
        
        return true
    }
    
    
    static func cachedObjForKey(key:String)->AnyObject?{

        
        let targetPath = baseDocPath + "/" + key
        let obj = NSKeyedUnarchiver.unarchiveObjectWithFile(targetPath)
       
        return obj
    }
    
    
    
    static func clearCachedWithKey(key:String){
        
        let cachedPath = baseDocPath + "/" + key
        let fileManager = NSFileManager.defaultManager()
        if(fileManager.fileExistsAtPath(cachedPath)){
            
            do{
                
                try fileManager.removeItemAtPath(cachedPath)
            }catch{
                
                
            }
        }
    }

    
    static func updateCachedWithKey(key:String,andObj:AnyObject?)->Bool{
        
        let targetPath = baseDocPath + "/" + key
        let result = NSKeyedArchiver.archiveRootObject(andObj!, toFile: targetPath)
        return result
        
    }
    
    
       
    
    static func dealyWithTimeInterval(time:NSTimeInterval,f:()->Void){
      
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            f()
        }
    }
    
    
    
}




