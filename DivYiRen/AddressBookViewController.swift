//
//  AddressBookViewController.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/25.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

/*好友列表*/
/*在这个列表里:
 
 未读消息会在这里显示，每一个row都有对应的未读消息数量【为0时不显示】，这个控制器对应的tabBarItem上会有未读消息总量
 点击好友row，会跳转到聊天界面，同时对应的未读消息清零
 
 在这个界面中，左划可以删除对应的好友
 */
protocol addressBookFriendListDelegate {
    
    func syndtheFriendList(friendList:Array<String>,unreadMessages:NSMutableArray,tableView:UITableView)
}

class AddressBookViewController: UIViewController {

    
    var tempFriendModel:FriendModel?
    
    var tempTableView:UITableView?
    var tempChatHistory:NSMutableArray?
    
    
    var dataList:[FriendModel]? = [FriendModel]()
    var tableView:UITableView?
    
    var unreadedMessageList:NSMutableArray?
    var delegate:addressBookFriendListDelegate?
    
    private var unreadedMessageCachedKey:String = ""
    override func loadView() {
        
        tableView!.separatorStyle = .None
       
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.tableFooterView = UIView()
        view = tableView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usermodel:UserModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        
        let k = (usermodel.userName as String) + ConstantPara.friendListCachedKey
       
        if(ConstantPara.isKeyCached(k)){
        
             dataList = ConstantPara.cachedObjForKey(k) as? [FriendModel]
        }
        
        self.navigationItem.title = "联系人"
        
    }
    
    
    
    //MARK: - view将要出现
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        if(self.tempFriendModel != nil){
        
            self.wrap_fetchChatMessageList(self.tempFriendModel!)
        }
        
    }
    
    
    //处理好友列表的同步通知
    func notificationHandle(noti:NSNotification){
        
        let usermodel:UserModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        self.dataList = ConstantPara.cachedObjForKey((usermodel.userName as String) + ConstantPara.friendListCachedKey) as? [FriendModel]
        self.tableView?.reloadData()
        
        //开始建立连接
        if(WebSocketManager.shareWebSocketManager.webSocket?.isConnected == false){
        
            WebSocketManager.shareWebSocketManager.webSocket?.connect()
        }
        
        
        //在内存建立一个未读消息列表，并同步到磁盘
        unreadedMessageCachedKey = (usermodel.userName as String) + ConstantPara.unreadMessageCacheKey
        if(ConstantPara.isKeyCached(unreadedMessageCachedKey) == false){
        
            let tempList:NSMutableArray = []
            
            for _ in self.dataList!{
            
                let innerList:NSMutableArray = [] as NSMutableArray
                tempList.addObject(innerList)
            }
            
            ConstantPara.updateCachedWithKey(unreadedMessageCachedKey, andObj: tempList)
        }
        
        self.unreadedMessageList = ConstantPara.cachedObjForKey(unreadedMessageCachedKey) as? NSMutableArray
        
        
        var friendsName = [String]()
        for t:FriendModel in self.dataList!{
        
            friendsName.append(t.username)
        }
        
        self.delegate = ChatMessageDispathCenter.shareMessageCenter
        self.delegate?.syndtheFriendList(friendsName, unreadMessages: self.unreadedMessageList!, tableView: self.tableView!)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(){
    
        super.init(nibName: nil, bundle: nil)
        
       tableView = UITableView(frame:UIScreen.mainScreen().bounds, style: .Plain)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(notificationHandle(_:)), name: ConstantPara.synFriendsListKey, object: nil)
        
        
        //
        self.wrap_synWithChatMessageDispatchCenter()
        
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func wrap_synWithChatMessageDispatchCenter(){
    
        let userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        let k = (userModel.userName as String)+ConstantPara.friendListCachedKey
        
        unreadedMessageCachedKey = (userModel.userName as String) + ConstantPara.unreadMessageCacheKey
        if(ConstantPara.isKeyCached(k) && ConstantPara.isKeyCached(unreadedMessageCachedKey)){
            
            dataList = ConstantPara.cachedObjForKey(k) as? [FriendModel]
            
            self.unreadedMessageList = ConstantPara.cachedObjForKey(unreadedMessageCachedKey) as? NSMutableArray
            
            var friendsName = [String]()
            for t:FriendModel in self.dataList!{
                
                friendsName.append(t.username)
            }
            
            self.delegate = ChatMessageDispathCenter.shareMessageCenter
            self.delegate?.syndtheFriendList(friendsName, unreadMessages: self.unreadedMessageList!, tableView: self.tableView!)
        }

    }
   
}

extension AddressBookViewController:UITableViewDelegate,UITableViewDataSource,ViewControllSynChatMessageHistoryDelegate{
    
    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _ = dataList{
            
            guard dataList!.count > 0 else{
                
                return 0
            }
            
        }else{
        
            return 0
        }
        
        let item = self.tabBarController?.tabBar.items![1]
        var unreadedCount:Int = 0
        
        let tarray:NSMutableArray = []
        
        let userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        if(ConstantPara.isKeyCached((userModel.userName as String) + ConstantPara.unreadMessageCacheKey)){
        
            tarray.addObjectsFromArray(self.unreadedMessageList! as [AnyObject])
            
            
            if(tarray.count != 0){
                
                for index in 0...tarray.count - 1{
                    
                    let targetArray:NSMutableArray = self.unreadedMessageList![index] as! NSMutableArray
                    
                    unreadedCount += targetArray.count
                }
            }
            
            if(unreadedCount == 0){
                
                item?.badgeValue = nil
            }else{
                
                item?.badgeValue = "\(unreadedCount)"
            }

        }
        
        return dataList!.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if(cell == nil){
            
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
            
            let unreadedMessageCountLabel = UILabel()
            unreadedMessageCountLabel.textColor = UIColor.clearColor()
            unreadedMessageCountLabel.textAlignment = .Center
            unreadedMessageCountLabel.textColor = UIColor.whiteColor()
            cell?.contentView.addSubview(unreadedMessageCountLabel)
            unreadedMessageCountLabel.font = UIFont.systemFontOfSize(12)
            
            unreadedMessageCountLabel.snp_makeConstraints(closure: { (make) in
            
                make.centerY.equalTo((cell?.contentView)!)
                make.right.equalTo((cell?.contentView.snp_right)!).offset(-10)
                make.size.equalTo(CGSizeMake(20, 20))
                
            })
            
            
            unreadedMessageCountLabel.layer.cornerRadius = 10
            unreadedMessageCountLabel.layer.masksToBounds = true
            unreadedMessageCountLabel.tag = 2002
        }
        
        let unreadedMessageLabel:UILabel = cell?.contentView.viewWithTag(2002) as! UILabel
        
        if(self.unreadedMessageList != nil){
        
            let t:NSMutableArray = self.unreadedMessageList![indexPath.row] as! NSMutableArray
            
            if(t.count == 0){
                
                unreadedMessageLabel.backgroundColor = UIColor.clearColor()
                unreadedMessageLabel.text = ""
                
            }else{
                
                unreadedMessageLabel.backgroundColor = UIColor.redColor()
                unreadedMessageLabel.text = "\(t.count)"
            }

        }
        
        let friendModel = dataList![indexPath.row]
        cell?.textLabel?.text = friendModel.username
        return cell!
        
    }
    
    
    //MARK:删除好友回调
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?{
    
        let deleteAction = UITableViewRowAction(style: .Normal, title: "删除好友") { (action, indexPath) in
            
            let friendModel = self.dataList![indexPath.row]
            let userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
            
            HUD.show(.Progress)
            //MARK:- 删除好友
            Alamofire.request(.POST, ConstantPara.delFriendAPI, parameters: [ConstantPara.loginedKey:userModel.userName,ConstantPara.friend:friendModel.username,ConstantPara.session_token:userModel.session_token], encoding: .JSON, headers: nil).responseJSON(completionHandler: { response in
                
                let resultDict = response.result.value
                let statusCode = resultDict![ConstantPara.status] as! Int
               
                if(statusCode == StatusCode.get_or_add_success.rawValue){//删除成功
                    
                    self.dataList?.removeAtIndex(indexPath.row)
                    
                    let usermodel:UserModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel

                    ConstantPara.updateCachedWithKey((usermodel.userName as String) + ConstantPara.friendListCachedKey, andObj: self.dataList)
                    
                    tableView.reloadData()
                    
                    //也要将对应的聊天记录缓存清除和对应的未读消息列表清除
                    //begin
                    self.unreadedMessageList?.removeObjectAtIndex(indexPath.row)
                    
                    let unreadedMessaheCacheKey = (userModel.userName as String) + ConstantPara.unreadMessageCacheKey
                    ConstantPara.updateCachedWithKey(unreadedMessaheCacheKey, andObj: self.unreadedMessageList)
                    
                    let friendModel = self.dataList![indexPath.row]
                    
                    let messageHistoryCacheKey = ((userModel.userName) as String) + ConstantPara.messageHistoryKey + friendModel.username
                    
                    ConstantPara.clearCachedWithKey(messageHistoryCacheKey)
                    //end
                    
                    
                    HUD.flash(.LabeledSuccess(title: "删除成功", subtitle: nil), delay: 1.2)
                    return
                }
                
                HUD.flash(.LabeledError(title: StatusCode.reasonPhraseForStatusCode(StatusCode(rawValue: statusCode)!), subtitle: nil), delay: 1.2)
                
            })
            
        
            print("删除好友")
        }
        
        return [deleteAction]
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return .Delete
    }
    
    
    
    //MARK: - cell被点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let unreadedMessge = self.unreadedMessageList![indexPath.row] as! NSMutableArray
        
        let detailMessageVC = DetailMessageViewController()
        let friendModel = dataList![indexPath.row]
        detailMessageVC.titleName = friendModel.username
      
        detailMessageVC.unreadedMessageList = unreadedMessge.mutableCopy() as! NSMutableArray
        unreadedMessge.removeAllObjects()
        self.tableView?.reloadData()
        
        ConstantPara.updateCachedWithKey(unreadedMessageCachedKey, andObj: self.unreadedMessageList)
        
       
        //最近与谁聊天数据获取&更新
        /*begin*/
        self.wrap_fetchChatMessageList(friendModel)
        /*end*/
     
        
        self.navigationController?.pushViewController(detailMessageVC, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: - 包裹方法 最近与谁聊天数据获取&更新
    func wrap_fetchChatMessageList(friendModel:FriendModel){
    
        self.tempFriendModel = friendModel
        
        //最近与谁聊天数据获取&更新
        /*begin*/
        var beThere = false
        var t_index:Int = -1
        for t in self.tempChatHistory!{
            
            t_index += 1
            
            let tempT:ChatHistoryListModel = t as! ChatHistoryListModel
            if(tempT.friendName == friendModel.username){
                
                beThere = true
                break
            }
        }
        
        
        if(beThere){
            
            self.tempChatHistory?.removeObjectAtIndex(t_index)
        }
        
        
        let userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as? UserModel
        let cachedMessagesKey = ((userModel?.userName)! as String) + ConstantPara.messageHistoryKey + friendModel.username
        
        if(ConstantPara.isKeyCached(cachedMessagesKey)){
            
            let t_messages = ConstantPara.cachedObjForKey(cachedMessagesKey) as! [MessageModel]
            
            let lastmessageModel = t_messages.last
            
            //FIXME: - 修复
            
            if(lastmessageModel != nil){
            
                let chatHistoryListModel = ChatHistoryListModel(friendName: friendModel.username, message: (lastmessageModel?.contents)!)
                
                self.tempChatHistory?.insertObject(chatHistoryListModel, atIndex: 0)
                self.tempTableView?.reloadData()
                
                
                let chatHistoryCacheKey = (userModel!.userName as String) + ConstantPara.chatHistoryListCache
                ConstantPara.updateCachedWithKey(chatHistoryCacheKey, andObj: self.tempChatHistory)
            }
            
            /*end*/

    }
    
}
    
    
    
    func synChatMessageHistory(history: NSMutableArray, tableView: UITableView) {
        
        self.tempTableView = tableView
        self.tempChatHistory = history
    }
    
    
    
}



