//
//  VerifyViewController.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/4.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

/*在这个界面可以接受请求和拒绝请求*/

class VerifyViewController: UIViewController {

    var tableView:UITableView?
    var dataList:[String]?
    var viewController:MoreViewController?
    
    var userModel:UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRectZero, style: .Plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView!)
        tableView?.registerClass(VerifyTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView?.rowHeight = 60
        tableView?.snp_makeConstraints(closure: { (make) in
            
            make.edges.equalTo(self.view)
        })
        
        tableView?.allowsSelection = false
        
        
        /********************/
        
        userModel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as? UserModel
  
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VerifyViewController:UITableViewDelegate,UITableViewDataSource,VerifyTableViewButtonClickedDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (self.dataList?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! VerifyTableViewCell
        cell.delegate = self
        cell.textLabel?.text = self.dataList![indexPath.row]
        
        if(cell.tableViewRef == nil){
            
            cell.tableViewRef = self.tableView
            
        }
        return cell
    }
    
    //MARK: - 拒绝或接受按钮点击
    func buttonClicked(title:String,andIndexPath:NSIndexPath){
    
        
        let friendName = self.dataList![andIndexPath.row] 
         let item = self.viewController!.tabBarController?.tabBar.items![2]
        
        if(title == "接受"){
        
            HUD.show(.Progress)
            Alamofire.request(.POST, ConstantPara.addFriendAPI, parameters: [ConstantPara.loginedKey:(userModel?.userName)!,ConstantPara.session_token:(userModel?.session_token)!,ConstantPara.friend:friendName], encoding: .JSON, headers: nil).responseJSON(completionHandler: { response in
                
                let resultDict = response.result.value
                let statusCode = resultDict![ConstantPara.status] as? Int
                
                print(resultDict)
                if(statusCode == StatusCode.get_or_add_success.rawValue){//获取成功
                    
                    let friendModel = FriendModel(address: "", nickname: friendName, username: friendName)
                    
                    let tk = ((self.userModel?.userName)! as String) + ConstantPara.friendListCachedKey
          
                    var friends = ConstantPara.cachedObjForKey(tk) as! [FriendModel]
                    
                    friends.append(friendModel)
                    
                    ConstantPara.updateCachedWithKey(tk, andObj:
                        friends)
                    
                    //
                    let key = (self.userModel!.userName as String) + ConstantPara.unreadMessageCacheKey
                    let unreadedMessage = ConstantPara.cachedObjForKey(key) as! NSMutableArray
                    
                    let tmutiArray:NSMutableArray = []
                    unreadedMessage.addObject(tmutiArray)
                    
                    ConstantPara.updateCachedWithKey(key, andObj: unreadedMessage)
                    
                    //
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(ConstantPara.synFriendsListKey, object: nil)
                    
                   
                   
                    self.dataList?.removeAtIndex(andIndexPath.row)
                    if((self.dataList?.count)! == 0){
                    
                        item?.badgeValue = nil
                    }else{
                        item?.badgeValue = "\((self.dataList?.count)!)"
                    }

                    
                    let t = (self.userModel?.userName as! String) + ConstantPara.verifyCachedKey
                    
                    ConstantPara.updateCachedWithKey(t, andObj: self.dataList)
                    
                    //更新上页信息
                    NSNotificationCenter.defaultCenter().postNotificationName(ConstantPara.verify_notiKey, object: nil)
                    //                    self.viewController?.tableView!.reloadData()
                    self.tableView?.reloadData()
                    
                    HUD.flash(.LabeledSuccess(title: "添加成功", subtitle: nil), delay: 1.2)
                    return
                   
                }
                
                let reason = StatusCode.reasonPhraseForStatusCode(StatusCode(rawValue: statusCode!)!)
                HUD.flash(.LabeledError(title: reason, subtitle: nil), delay: 1.2)
                
            })
            
            
        }else{//拒绝
        
            
            HUD.show(.Progress)
            Alamofire.request(.POST, ConstantPara.delFriendAPI, parameters: [ConstantPara.loginedKey:(userModel?.userName)!,ConstantPara.session_token:(userModel?.session_token)!,ConstantPara.friend:friendName], encoding: .JSON, headers: nil).responseJSON(completionHandler: { response in
                
                let resultDict = response.result.value
                let statusCode = resultDict![ConstantPara.status] as! Int
                
                if(statusCode == StatusCode.get_or_add_success.rawValue){//拒绝成功
                
                    self.dataList?.removeAtIndex(andIndexPath.row)
                    
                    if((self.dataList?.count)! == 0){
                        
                        item?.badgeValue = nil
                    }else{
                        item?.badgeValue = "\((self.dataList?.count)!)"
                    }
                    
                    let t = (self.userModel?.userName as! String) + ConstantPara.verifyCachedKey
                    
                    ConstantPara.updateCachedWithKey(t, andObj: self.dataList)
                    
                    //更新上页信息
                    NSNotificationCenter.defaultCenter().postNotificationName(ConstantPara.verify_notiKey, object: nil)
                    //                    self.viewController?.tableView!.reloadData()
                    self.tableView?.reloadData()
                    
                    HUD.flash(.LabeledSuccess(title: "成功拒绝", subtitle: nil), delay: 1.2)
                    return
                }
                
                let reason = StatusCode.reasonPhraseForStatusCode(StatusCode(rawValue: statusCode)!)
                
                HUD.flash(.LabeledError(title: reason, subtitle: nil), delay: 1.2)
                
                
            })
            
            
            
        }
    }
  
    
}




