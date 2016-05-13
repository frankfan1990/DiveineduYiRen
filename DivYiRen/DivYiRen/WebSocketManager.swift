//
//  WebSocketManager.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/8.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Starscream

class WebSocketManager{

    static let shareWebSocketManager = WebSocketManager()
    var webSocket:WebSocket?
    private init(){
    
        if((ConstantPara.cachedObjForKey(ConstantPara.loginedKey)) != nil){
            
            let userModel:UserModel = (ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as? UserModel)!
            let socektAPI = ConstantPara.baseSocketChatAPI + "/\((userModel.userName))" + "/\((userModel.session_token))"
            
           print("websocket:\(socektAPI)")
            
            var webSockett:WebSocket?
            webSockett = WebSocket(url: NSURL(string: socektAPI)!, protocols: ["chat"])
            webSockett!.delegate = ChatMessageDispathCenter.shareMessageCenter
            
            self.webSocket = webSockett
        }
    
    }
    
    deinit{
    
        print("webSocket 单例死亡")
    }
    
    
    
}
