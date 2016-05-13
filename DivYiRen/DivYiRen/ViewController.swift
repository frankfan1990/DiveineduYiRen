//
//  ViewController.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/25.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Starscream


protocol ViewControllSynChatMessageHistoryDelegate{
    
    func synChatMessageHistory(history:NSMutableArray,tableView:UITableView)
}

class ViewController: UIViewController{

    
    var chatHistoryList:NSMutableArray = []
    var delegate:ViewControllSynChatMessageHistoryDelegate?
    var tableView:UITableView?
    
    override func loadView() {
        
        tableView = UITableView(frame: UIScreen.mainScreen().bounds, style: .Plain)
        tableView?.separatorStyle = .None
        tableView?.tableFooterView = UIView()
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.registerClass(RecentMessageTableViewCell.self, forCellReuseIdentifier: "cell")
        view = tableView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        self.createTopSelectItem("最近", item2: "发现")
        let segeItem = self.navigationItem.titleView as! UISegmentedControl
        segeItem.selectedSegmentIndex = 0
        
        //
        
        let usermodel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        self.handleSynNoti(nil)
        
        if(ConstantPara.isKeyCached((usermodel.userName as String) + ConstantPara.friendListCachedKey)){
        
            //开始建立连接
            #if false
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if(appdelegate.webSocket!.isConnected == false){
                
                appdelegate.webSocket!.connect()
            }
            #endif
            
            
            if(WebSocketManager.shareWebSocketManager.webSocket!.isConnected == false){
            
                let userModel:UserModel = (ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as? UserModel)!
                let socektAPI = ConstantPara.baseSocketChatAPI + "/\((userModel.userName))" + "/\((userModel.session_token))"

                WebSocketManager.shareWebSocketManager.webSocket =  WebSocket(url: NSURL(string: socektAPI)!, protocols: ["chat"])
                WebSocketManager.shareWebSocketManager.webSocket?.delegate = ChatMessageDispathCenter.shareMessageCenter
                WebSocketManager.shareWebSocketManager.webSocket?.connect()
            }
            

        }
        
        
        let addressVCNV = self.tabBarController?.viewControllers![1] as! UINavigationController
        let addressVC = addressVCNV.viewControllers.first as! AddressBookViewController
        addressVC.tableView?.reloadData()
        
        
        let chatHistoryCacheKey = (usermodel.userName as String) + ConstantPara.chatHistoryListCache
        if(ConstantPara.isKeyCached(chatHistoryCacheKey) == false){
        
            let t:NSMutableArray = []
            ConstantPara.updateCachedWithKey(chatHistoryCacheKey, andObj: t)
        }
        
        self.chatHistoryList = ConstantPara.cachedObjForKey(chatHistoryCacheKey) as! NSMutableArray
        
        self.delegate = addressVC
        self.delegate?.synChatMessageHistory(self.chatHistoryList, tableView: self.tableView!)
        
        
    }
    
    
    //MARK: - view将要出现
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(){
    
        super.init(nibName: nil, bundle: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleSynNoti(_:)), name: ConstantPara.synFriendsListKey, object: nil)
    }
    
  
    deinit{
    
        #if false
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if(appdelegate.webSocket != nil){
        
            if(appdelegate.webSocket!.isConnected){
                
                appdelegate.webSocket!.disconnect()
            }

        }
        #endif
        
        if(WebSocketManager.shareWebSocketManager.webSocket!.isConnected == true){
        
            WebSocketManager.shareWebSocketManager.webSocket?.disconnect()
        }
        
        
        print("主页面被销毁...")
    }
    
    //处理验证请求的回调
    func handleSynNoti(noti:NSNotification?){
    
        // MARK: -
        let usermodel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        let tk = (usermodel.userName as String) + ConstantPara.verifyCachedKey
        if(ConstantPara.isKeyCached(tk) == false){
            
            return
        }
        let verifys = ConstantPara.cachedObjForKey(tk) as! [String]
        
        let item = self.tabBarController?.tabBar.items![2]
        if(verifys.count != 0){
            
            item?.badgeValue = "\(verifys.count)"
        }

    }
    
    
    
    
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- create top segement
    func createTopSelectItem(item1:String,item2:String){
        
        var uisege = UISegmentedControl(frame:CGRectMake(0, 0, 100, 50))
        uisege = UISegmentedControl(items: [item1,item2])
        uisege.addTarget(self, action: #selector(whichIndexSelect(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = uisege
    }
    
    
    func whichIndexSelect(sele:UISegmentedControl){
        
        print("\(sele.selectedSegmentIndex)")
    }
    
    //MARK：- uitableView代理
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.chatHistoryList.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! RecentMessageTableViewCell
        
        let chathistoryModel = self.chatHistoryList[indexPath.row] as! ChatHistoryListModel
        
        cell.senderLabel.text = chathistoryModel.friendName
        cell.contentLabel.text = chathistoryModel.message
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    
    //MARK: - tableViewCell 被点击
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let chatHistoryListModel = self.chatHistoryList[indexPath.row] as! ChatHistoryListModel
        
        let usermodel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        let unreadedMessageCachedKey = (usermodel.userName as String) + ConstantPara.unreadMessageCacheKey
        if(ConstantPara.isKeyCached(unreadedMessageCachedKey)){
        
//            let unreadedMessageList:NSMutableArray = (ConstantPara.cachedObjForKey(unreadedMessageCachedKey) as? NSMutableArray)!
            
            let detaiVC = DetailMessageViewController()
            
            detaiVC.titleName = chatHistoryListModel.friendName
            
         
//            detaiVC.unreadedMessageList = unreadedMessageList.mutableCopy() as! NSMutableArray
           
            
            self.navigationController?.pushViewController(detaiVC, animated: true)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
    }
    
}






