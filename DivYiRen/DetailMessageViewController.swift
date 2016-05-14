//
//  DetailMessageViewController.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/27.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Starscream

/*聊天界面*/
/*在这个界面里，利用protocol告知消息分发中心此时正在与谁聊天，消息中心会将收到的消息对应的发送到正在与之聊天的对象*/

protocol DetailMessageWhoWithChatDelegate {
    
    func whoWithChat(friendName:String)
}

class DetailMessageViewController: UIViewController{

    private var tableView:UITableView?
    let textInput = UITextField()
    var titleName:String?
    var messageHistory:[String]?
    var userModel:UserModel?
    var key = ""
    var socket:WebSocket?
    
    var delegate:DetailMessageWhoWithChatDelegate?
    
    private var messages:[MessageModel] = [MessageModel]()
    var unreadedMessageList:NSMutableArray = []//未读消息
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as? UserModel
        key = ((userModel?.userName)! as String) + ConstantPara.messageHistoryKey + titleName!
        
        //一登录就告知消息中心跟谁在聊天
        self.delegate = ChatMessageDispathCenter.shareMessageCenter
        self.delegate?.whoWithChat(titleName!)
        
    
        let notiName = (userModel!.userName as String) + ConstantPara.chatSynNotiKey + titleName!
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(dispathMessageCenterNotificationHandle(_:)), name: notiName, object: nil)
        
        
        
        let timeI = Utils.timeStamp_now()
        print(timeI)
        
        
        
        
        #if false //暂废弃处理
        if(ConstantPara.isKeyCached(key) == false){
        
            let messageHistory = [String]()
            ConstantPara.updateCachedWithKey(key, andObj: messageHistory)
        }
        
        self.messageHistory = ConstantPara.cachedObjForKey(key) as? [String]
        #endif
        
    //
        
        if(ConstantPara.isKeyCached(key) == false){
            
            let message = [MessageModel]()
            ConstantPara.updateCachedWithKey(key, andObj: message)
        }
        
        self.messages = (ConstantPara.cachedObjForKey(key) as? [MessageModel])!
        
        for t in self.unreadedMessageList{
        
            self.messages.append(t as! MessageModel)
        }
        
        if(self.unreadedMessageList.count > 0){
        
            ConstantPara.updateCachedWithKey(key, andObj: self.messages)
        }

        
        view.addSubview(textInput)
        textInputConfig()
        tableViewBaseConfig()
        self.view.backgroundColor = UIColor.whiteColor()
        //
        self.navigationItem.title = titleName!
        
        //
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyBoardCallBackHandle), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyBoardClosehandle(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        self.edgesForExtendedLayout = .None
        
        self.scrollToBottom()
    }
      
    func textInputConfig(){
        
        textInput.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        textInput.returnKeyType = .Send
        textInput.delegate = self
        textInput.placeholder = "请输入消息"
        textInput.snp_makeConstraints { (make) in
            
            make.left.right.equalTo(self.view)
            make.height.equalTo(50)
            make.bottom.equalTo(self.view.snp_bottom)
        }
    }
    
    func tableViewBaseConfig(){
    
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView!.separatorStyle = .None
        tableView!.registerClass(DetailMessageTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView?.allowsSelection = false
        self.view.addSubview(tableView!)
       
        tableView!.rowHeight = UITableViewAutomaticDimension
        tableView!.estimatedRowHeight = 2.0
        tableView!.tableFooterView = UIView()
        
        tableView!.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.view.snp_top)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(textInput.snp_top)
        }
    }
    
    //MARK:- keyBoard noti callBack-Handle 键盘出现
    func keyBoardCallBackHandle(notification:NSNotification){
        
        
        let userInfo = notification.userInfo! as NSDictionary
        let rect = userInfo["UIKeyboardFrameEndUserInfoKey"]! as! NSValue
        let offset = rect.CGRectValue().height
        
        let timeDict = notification.userInfo! as NSDictionary
        let animalDur = timeDict["UIKeyboardAnimationDurationUserInfoKey"]! as! NSNumber
        let animaltime = animalDur.doubleValue as NSTimeInterval
        
        
        textInput.snp_updateConstraints { (make) in
            
            make.bottom.equalTo(self.view.snp_bottom).offset(-offset+50)
        }
        
        UIView.animateWithDuration(animaltime) { 
            
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        }

        
    }
    
    //键盘收起回调
    func keyBoardClosehandle(noti:NSNotification){
    
        let timeDict = noti.userInfo! as NSDictionary
        let animalDur = timeDict["UIKeyboardAnimationDurationUserInfoKey"]! as! NSNumber
        let animaltime = animalDur.doubleValue as NSTimeInterval
        
        textInput.snp_updateConstraints { (make) in
            
            make.bottom.equalTo(self.view.snp_bottom).offset(0)
        }
        
        UIView.animateWithDuration(animaltime) {
            
            self.view.layoutIfNeeded()
        }
        
    }
   
    //MARK: - 消息回调
    //接受从消息分发中心发过来的消息_notiCallBack【消息body为MessageModel】
    func dispathMessageCenterNotificationHandle(noti:NSNotification){

        let messageModel = noti.object as! MessageModel
        self.messages.append(messageModel)
        
        self.scrollToBottom()

        ConstantPara.updateCachedWithKey(key, andObj: self.messages)
    }
    
    
    
    
    deinit{
    
        if((self.socket?.isConnected) != nil){
        
            self.socket?.disconnect()
        }
        
        self.delegate?.whoWithChat("")
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

extension DetailMessageViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        guard messages.count > 0 else{
            
            return 0
        }
        
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DetailMessageTableViewCell
        
        let messageModel = messages[indexPath.row]
        cell.contentLabel.text = messageModel.contents
        if(messageModel.messageStyle == MessageStyle.MessageStyeLeft.rawValue){
        
            cell.isLeftMode = true
        }else{
            
            cell.isLeftMode = false
        }
        
        return cell
    }
    
    //MARK: - 发送消息
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if(textField.text?.characters.count == 0){
        
            return true
        }
        
        //发送信息
        let chatModel = ChatMessageModel(from: (userModel?.userName)! as String, to: titleName!, timestamp: Utils.timeStamp_now(), msgtype:"text", msgcontent: (self.textInput.text)!)
        
        let jsonString = JSONSerializer.toJson(chatModel)
 
        if(WebSocketManager.shareWebSocketManager.webSocket!.isConnected == true){
        
            print(WebSocketManager.shareWebSocketManager.webSocket!)
            WebSocketManager.shareWebSocketManager.webSocket!.writeString(jsonString)
        }else{
            WebSocketManager.shareWebSocketManager.webSocket!.connect()
        }

        let messModel = MessageModel(contents: textField.text!, messageStyle: MessageStyle.MessageStyleRight)
        
        messages.append(messModel)
        
        self.scrollToBottom()
       
        //同步消息到本地
        ConstantPara.updateCachedWithKey(key, andObj: self.messages)
        
        
        textInput.text = nil
        print("send message")
        return true
    }
    

    //滚动到底部
    func scrollToBottom(){
    
        if(messages.count == 0){
            
            return
        }
        let indexPath = NSIndexPath(forRow: (messages.count-1), inSection: 0)
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.tableView?.reloadData()
            ConstantPara.dealyWithTimeInterval(0.05) {
                
                self.tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            }
            
        }

    }
    

    //向下滚动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if(scrollView.dragging){
        
            self.view.endEditing(true)
            self.view.layoutIfNeeded()
        }
    }
    
}





