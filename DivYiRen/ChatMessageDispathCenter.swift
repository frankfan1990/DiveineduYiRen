//
//  ChatMessageDispathCenter.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/5.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Starscream
import Alamofire

class ChatMessageDispathCenter:WebSocketDelegate,DetailMessageWhoWithChatDelegate,addressBookFriendListDelegate{

    static let shareMessageCenter = ChatMessageDispathCenter()
    private var whoWithChat:String = ""
    
    private var friendList:[String]?
    private var unreadMessageList:NSMutableArray?
    private var tableView:UITableView?
    
    private init(){}
    
   
    //MARK: - websocket 代理方法
    func websocketDidConnect(socket: WebSocket) {
        
        print("已经连上服务器:\(socket)")
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        
//        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        Alamofire.request(.GET, "http://www.baidu.com", parameters: nil, encoding: .JSON, headers: nil).responseJSON { response in
            
            if(response.result.error == nil){
            
                if(ConstantPara.isKeyCached(ConstantPara.loginedKey)){
                    
                    WebSocketManager.shareWebSocketManager.webSocket!.connect()
                }

            }
        }
        
        print("已经断开连接:\(socket)-->\(error)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        
        let result = try! JSONSerializer.toDictionary(text)
        if(result.count == 2){//说明不是对方发过来的消息，而是自己
            
            
            return
        }
        
        //好友们发来的消息
        let chatMessageModel = ChatMessageModel.messageModelWithDict(result)
        
        let messageModel = MessageModel(contents: chatMessageModel.msgcontent, messageStyle: MessageStyle.MessageStyeLeft)
        
        if(chatMessageModel.from == self.whoWithChat){//正在聊天的好友发来的消息
        
            let userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
            let notiName = (userModel.userName as String) + ConstantPara.chatSynNotiKey + self.whoWithChat
            
            NSNotificationCenter.defaultCenter().postNotificationName(notiName, object: messageModel)
       
        }else{//非聊天ing好友发来的消息
        
            if(self.friendList == nil){
            
                return
            }
            
            let friend = chatMessageModel.from
            let index = (self.friendList?.indexOf(friend))!
            
            let t_list = self.unreadMessageList?.objectAtIndex(index) as! NSMutableArray
            
            t_list.addObject(messageModel)
            
            let usermodel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
            let cacheUnreadedMessageKey = (usermodel.userName as String) + ConstantPara.unreadMessageCacheKey
            ConstantPara.updateCachedWithKey(cacheUnreadedMessageKey, andObj: self.unreadMessageList!)
            
            self.tableView?.reloadData()
        
        }
        
        
        print("接受到文字消息:\(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        
        print("接受到数据消息:\(data)")
    }

    //
    func whoWithChat(friendName: String) {
        
      self.whoWithChat = friendName
    }

    
    //
    func syndtheFriendList(friendList: Array<String>, unreadMessages: NSMutableArray, tableView: UITableView) {
        
        self.friendList = friendList
        self.unreadMessageList = unreadMessages
        self.tableView = tableView
    }
    
    
    
    
}
