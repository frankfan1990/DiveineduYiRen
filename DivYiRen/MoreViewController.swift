//
//  MoreViewController.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/25.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire

class MoreViewController: UIViewController {

    var addressBookRef:AddressBookViewController?
    
    let usermodel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
    private var dataSource = [String]()
    
    var tableView:UITableView?
    override func loadView() {
        
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView!.scrollEnabled = false
        tableView!.tableFooterView = UIView()
        view = tableView!
        tableView!.separatorStyle = .None
    }
    
    var item:UITabBarItem?
    var verifys:[String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataSource = ["等待验证","添加好友","清除缓存","注销","关于","昵称:\(usermodel.userName)"]
        
        self.title = "设置"
        
        self.fetchVerifyDataFromCache()
        item = self.tabBarController?.tabBar.items![2]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleSynVerifyNoti(_:)), name: ConstantPara.verify_notiKey, object: nil)
    }
    
    func fetchVerifyDataFromCache(){
    
        let usermodel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as! UserModel
        let tk = (usermodel.userName as String) + ConstantPara.verifyCachedKey
        verifys = ConstantPara.cachedObjForKey(tk) as? [String]

    }
    
    //接受更新待验证通知
    func handleSynVerifyNoti(noti:NSNotification?){
        
        self.fetchVerifyDataFromCache()
        self.tableView?.reloadData()
    }
    
    
}

extension MoreViewController:UITableViewDelegate,UITableViewDataSource{

    //
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        if(cell == nil){
        
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            
            let label = UILabel()
            label.tag = 1001
            cell?.contentView.addSubview(label)
            label.textAlignment = .Center
            label.textColor = UIColor.whiteColor()
            label.snp_makeConstraints(closure: { (make) in
                
                make.top.equalTo((cell?.contentView.snp_top)!).offset(10)
                make.right.equalTo((cell?.contentView.snp_right)!).offset(-10)
                make.size.equalTo(CGSizeMake(60, 30))
                
            })
            
            label.layer.cornerRadius = 15
            label.layer.masksToBounds = true
            
        }
        
        let label = cell?.contentView.viewWithTag(1001) as! UILabel
        if(indexPath.row == 0){
            
            label.hidden = false
            if let _ = self.verifys{
            
                if(verifys?.count != 0){
                    
                    label.hidden = false
                    label.backgroundColor = UIColor.redColor()
                    label.text = "\((verifys?.count)!)"
                }else{
                    
                    label.hidden = true
                    label.backgroundColor = UIColor.clearColor()
                    
                }
                
            }
            
            
        }else{
            
            label.hidden = true
        }

        
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 4{//关于

            let aboutVC = AboutUsViewController()
            self.navigationController?.pushViewController(aboutVC, animated: true)
        }else if(indexPath.row == 1){//添加好友
        
            let addFriendVC =  AddFriendViewController()
            
            addFriendVC.addressBookSecondeRef = self.addressBookRef
            addFriendVC.addressBookSecondeRef?.view.backgroundColor = addFriendVC.addressBookSecondeRef?.view.backgroundColor
            
            self.presentViewController(addFriendVC, animated: true, completion: nil)
        }else if(indexPath.row == 3){//注销
        
            HUD.show(.Progress)
            
            /*if中的逻辑现在是伪装的，release版本将被撤销*/
            if(true){
            
                ConstantPara.dealyWithTimeInterval(2, f: { 
                  
                    ConstantPara.clearCachedWithKey(ConstantPara.loginedKey)
                    
                    HUD.flash(.LabeledSuccess(title: "注销成功", subtitle: nil), delay: 1)
                    
                    #if false
                    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    
                    if(appdelegate.webSocket != nil){
                    
                        if(appdelegate.webSocket!.isConnected){
                            
                            appdelegate.webSocket!.disconnect()
                        }
                    }
                    #endif
                    //
                    if(WebSocketManager.shareWebSocketManager.webSocket!.isConnected == true){
                    
                        WebSocketManager.shareWebSocketManager.webSocket?.disconnect()
                    }
                    
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(ConstantPara.notiKey, object: nil)
                    
//                    ConstantPara.clearCachedWithKey(ConstantPara.loginedKey)
                    
                })
                
                return

            }
            
            
            
//            let userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as? UserModel
            
            Alamofire.request(.POST, ConstantPara.logoutAPI, parameters: [ConstantPara.loginedKey:(usermodel.userName),ConstantPara.session_token:(usermodel.session_token)], encoding: .JSON, headers: nil).responseJSON(completionHandler: { response in
                
                let resultDict = response.result.value
                if(resultDict == nil){
                    HUD.flash(.LabeledError(title: "网络错误", subtitle: nil), delay: 1.2)
                    return
                }
                let statusCode = resultDict!["status"] as? Int
                if(statusCode == StatusCode.logout_success.rawValue){
                    
                    ConstantPara.clearCachedWithKey(ConstantPara.loginedKey)
                    
                    HUD.flash(.LabeledSuccess(title: "注销成功", subtitle: nil), delay: 1)
                    
                    #if FASTTRAP_T_PUSHL_EBP
                    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    if(appdelegate.webSocket!.isConnected){
                    
                        appdelegate.webSocket!.disconnect()
                    }
                    #endif
                    
                    
                    if(WebSocketManager.shareWebSocketManager.webSocket?.isConnected == false){
                    
                        WebSocketManager.shareWebSocketManager.webSocket?.disconnect()
                    }
                    
                    
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(ConstantPara.notiKey, object: nil)
                    
                    debugPrint("注销:\(self.usermodel.userName)-->\(self.usermodel.session_token)")
                    return
                }
                
                let reason = StatusCode.reasonPhraseForStatusCode(StatusCode(rawValue: statusCode!)!)
                HUD.flash(.LabeledError(title: reason, subtitle: nil), delay: 1.2)
                
                
            })
        }else if (indexPath.row == 0){//等待验证
        
            if(self.verifys?.count != 0){
                
                let verifyVC = VerifyViewController()
//                verifyVC.tableView = self.tableView
                verifyVC.dataList = self.verifys
                verifyVC.viewController = self
                
                self.navigationController?.pushViewController(verifyVC, animated: true)
            }
            
        }else if(indexPath.row == 2){//这个清除缓存功能暂时还没有实现
        
            HUD.show(.Progress)
            ConstantPara.dealyWithTimeInterval(2, f: { 
                
                HUD.flash(.LabeledSuccess(title: "清除成功", subtitle: nil), delay: 1.2)
            })
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

    
    
}

