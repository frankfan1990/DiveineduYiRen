//
//  AddFriendViewController.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/2.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class AddFriendViewController: UIViewController {

    var nameInputText:UITextField?
    var addressBookSecondeRef:AddressBookViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        nameInputText = UITextField()
        view.addSubview(nameInputText!)
        nameInputText?.textColor = UIColor.whiteColor()
        nameInputText?.backgroundColor = UIColor.grayColor()
        nameInputText?.layer.cornerRadius = 25
        nameInputText?.placeholder = "请输入昵称"
        nameInputText?.returnKeyType = .Done
        nameInputText?.delegate = self
        
        nameInputText?.snp_makeConstraints(closure: { (make) in
            
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view.snp_top).offset(150)
            make.size.equalTo(CGSizeMake(250, 50))
        })
        
        let button = UIButton(type: .Custom)
        button.backgroundColor = UIColor.blueColor()
        button.setTitle("发送请求", forState:.Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Highlighted)
        view.addSubview(button)
        button.addTarget(self, action: #selector(addFriendButtonClicked(_:)), forControlEvents: .TouchUpInside)
        button.layer.cornerRadius = 10
        button.snp_makeConstraints { (make) in
            
            make.top.equalTo((nameInputText?.snp_bottom)!).offset(20)
            make.left.equalTo((nameInputText?.snp_left)!)
            make.right.equalTo((nameInputText?.snp_right)!)
            make.height.equalTo(50)
            
        }
        
    }
    
    //MARK: - 添加好友
    func addFriendButtonClicked(sender:UIButton){
    
        if((self.nameInputText?.text)!.characters.count == 0){
        
            HUD.flash(.LabeledError(title: "请完善信息", subtitle: nil), delay: 1.2)
            
            return
        }
        
        let usermodel = ConstantPara.cachedObjForKey(ConstantPara.loginedKey) as? UserModel
        
        HUD.show(.Progress)
        Alamofire.request(.POST, ConstantPara.addFriendAPI, parameters: [ConstantPara.loginedKey:(usermodel?.userName)!,ConstantPara.session_token:(usermodel?.session_token)!,ConstantPara.friend:(self.nameInputText?.text)!], encoding: .JSON, headers: nil).responseJSON { response in
            
            let resultDict = response.result.value
            let statusCode = resultDict![ConstantPara.status] as? Int
          
            if(statusCode! == StatusCode.get_or_add_success.rawValue)//添加朋友成功
            {
            
                let friendModel = FriendModel(address: "", nickname: (self.nameInputText?.text)!, username: (self.nameInputText?.text)!)
                self.addressBookSecondeRef?.dataList?.append(friendModel)
                self.addressBookSecondeRef?.tableView?.reloadData()
                
                ConstantPara.updateCachedWithKey(ConstantPara.friendListCachedKey, andObj: friendModel)
                
                HUD.flash(.LabeledSuccess(title: "添加成功", subtitle: nil), delay: 1.2)
                self.dismissViewControllerAnimated(true, completion: nil)
                print(resultDict!)
                return
            }
            
            let reason = StatusCode.reasonPhraseForStatusCode(StatusCode(rawValue: statusCode!)!)
            
            if(statusCode! == StatusCode.ready_confirm.rawValue){
                
                HUD.flash(.LabeledSuccess(title: "等待验证", subtitle: nil), delay: 1)
                self.dismissViewControllerAnimated(true, completion: nil)
                
                return
            }
            
            HUD.flash(.LabeledError(title: reason, subtitle: nil), delay: 1.2)
            
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension AddFriendViewController:UITextFieldDelegate{
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {//退出界面
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}







