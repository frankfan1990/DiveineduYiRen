//
//  LoginViewController.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/25.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire

//MARK: 
/*
这个页面主要是处理登陆注册，若登陆成功则发送通知，切换根视图控制器，并在本地创建一个以用户名为名称的本地文件，该文件中记录用户的用户的用户名和session_toekn
 之后的逻辑中利用该文件存不存在为依据来判断用户是否登陆/注销
*/
class LoginViewController: UIViewController {
    
    var loginLabel:UILabel?
    var nameLable:UILabel?
    var passLabel:UILabel?
    var nameInput:UITextField?
    var passInput:UITextField?
    var confirmField:UITextField?
    var confirmCodeImage:UIImageView?
    
    var recodeStrign:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
         IQKeyboardManager.sharedManager().enable = true
        
        //
        let imageView = UIImageView (frame: self.view.bounds)
        view.addSubview(imageView)
        imageView.image = UIImage(named: "backgroundImage2.png")
        
        
        basicUIConfig()
        
       
    }
    
    
    
    
    
    func basicUIConfig(){
        
        
        //MARK: - 用户名输入
        nameInput = self.createTextFieldWith(2001, placeholder: "请输入用户名")
        view.addSubview(nameInput!)
        nameInput?.snp_makeConstraints(closure: { (make) in
            
            make.top.equalTo(self.view).offset(100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.left.equalTo(self.view.snp_left).offset(50)
            make.right.equalTo(self.view.snp_right).offset(-50)
            
        })
 

       
        //MARK: - 密码输入
        passInput = self.createTextFieldWith(2002, placeholder: "请输入密码")
        passInput!.secureTextEntry = true
        view.addSubview(passInput!)
        passInput?.snp_makeConstraints(closure: { (make) in
            
            make.top.equalTo((nameInput?.snp_bottom)!).offset(35)
            make.height.equalTo(50)
            make.left.right.equalTo(nameInput!)
            
        })
        
        
        
        //
        let regi = UIButton(type: UIButtonType.Custom)
        regi.tag  = 1001
        regi.setTitle("注册", forState: UIControlState.Normal)
        regi.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
        regi.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        regi.backgroundColor = UIColor.orangeColor()
        view.addSubview(regi)
        regi.snp_makeConstraints { (make) in
            
        make.top.equalTo((passInput?.snp_bottom)!).offset(180)
            make.left.equalTo(passInput!.snp_left)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        regi.layer.cornerRadius = 25
        regi.layer.masksToBounds = true
        
        
        //
        let login = UIButton(type: UIButtonType.Custom)
        login.tag  = 1002
        login.setTitle("登陆", forState: UIControlState.Normal)
        login.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
        login.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        login.backgroundColor = UIColor.orangeColor()
        view.addSubview(login)
        login.snp_makeConstraints { (make) in
            
            make.top.equalTo(regi.snp_top)
            make.right.equalTo((passInput?.snp_right)!)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }

        login.layer.cornerRadius = 25
        login.layer.masksToBounds = true
        
        
        //MARK: - 验证码
        confirmField = self.createTextFieldWith(2003, placeholder: "请输入验证码")
        view.addSubview(confirmField!)
        confirmField!.snp_makeConstraints { (make) in
            
            make.top.equalTo(passInput!.snp_bottom).offset(35)
            make.left.equalTo(passInput!.snp_left).offset(100)
            make.right.equalTo(passInput!.snp_right)
            make.height.equalTo(50)
            
        }
        
       
        confirmCodeImage = UIImageView()
        confirmCodeImage!.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.65)
        confirmCodeImage?.layer.cornerRadius = 5
        confirmCodeImage?.layer.masksToBounds = true
        view.addSubview(confirmCodeImage!)
        confirmCodeImage!.snp_makeConstraints { (make) in
            
            make.top.equalTo(confirmField!.snp_top).offset(5)
            make.left.equalTo(passInput!.snp_left)
            make.right.equalTo((confirmField?.snp_left)!).offset(-20)
            make.height.equalTo(40)
        }
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(wrapFetchConfirmData))
        confirmCodeImage?.userInteractionEnabled = true
        confirmCodeImage?.addGestureRecognizer(tapgesture)
        
        //
        let label = UILabel()
        view.addSubview(label)
        label.font = UIFont.systemFontOfSize(10)
        label.textColor = UIColor.whiteColor()
        label.snp_makeConstraints { (make) in
            
            make.top.equalTo((confirmCodeImage?.snp_bottom)!).offset(3)
            make.left.right.equalTo(confirmCodeImage!)
            make.height.equalTo(8)
        }
        label.textAlignment = .Center
        label.text = "点击图片刷新"
        
        
        
    }
    
    func createTextFieldWith(tag:Int,placeholder:String?)->UITextField{
    
        let textField = UITextField()
        textField.tag = tag
        textField.delegate = self
        textField.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.6)
        textField.font = UIFont.systemFontOfSize(14)
        textField.textColor = UIColor.whiteColor()
        textField.placeholder = placeholder
        textField.textAlignment = .Center
        textField.clearButtonMode = .Always
        textField.layer.cornerRadius = 25
        textField.layer.masksToBounds = true
        
        return textField
    }
    
    
    
    //MARK:- 注册登录按钮点击
    func buttonClicked(sender:UIButton){
        
        self.view.endEditing(true)
        
        if(nameInput?.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || passInput?.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || confirmField?.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0){
        
            HUD.flash(.LabeledError(title: "错误", subtitle: "请完善信息"), delay: 2)
            return
        }
        
     
       
        if(sender.tag == 1001){//rege
            
            //MARK: 注册
            self.regFunc()
            
            
        }else{//login
            
            //MARK: 登录
            self.loginFunc()
            
            
        
        }
        
    }
    
    
    //MARK: 注册处理
    func regFunc(){
    
        self.view.endEditing(true)
        let password_md5 = passInput?.text?.digestHex(DigestAlgorithm.MD5)
        Alamofire.request(.POST, ConstantPara.registerAPI2, parameters: ["username":(nameInput?.text)!,"nickname":(nameInput?.text)!,"captcha_value":(confirmField?.text)!,"gender":"male","password":password_md5!], encoding: .JSON, headers: nil).responseJSON{ response in
            
            
            
            do{
                
                let resultDict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                
                let status = resultDict["status"] as! Int
                
                let reason = StatusCode.reasonPhraseForStatusCode(StatusCode(rawValue: status)!)
                if(status == 200){
                
                    self.clearTheInputField()
                    
                }else if(status == 202){
                
                    self.wrapFetchConfirmData()
                }
                
                HUD.flash(.LabeledError(title: reason, subtitle: nil), delay: 1.2)
                
              
                #if false
                switch status{
                    
                case 200:
                    HUD.flash(.LabeledSuccess(title: "注册成功", subtitle: nil), delay: 2)
                    
                    self.clearTheInputField()
                    break
                    
                case 201:
                    HUD.flash(.LabeledError(title: "用户名已存在", subtitle: nil), delay: 2, completion: nil)
                    break
                    
                case 202:
                    
                    self.wrapFetchConfirmData()
                    HUD.flash(.LabeledError(title: "验证码错误", subtitle: nil), delay: 2, completion: nil)
                    break
                    
                default:
                    break
                }
                #endif
                
                
            }catch{
                
                
            }
            
        }

        
    }
    
    
    //MARK:处理登陆
    func loginFunc(){
        
        HUD.show(.Progress)
        let password_md5 = passInput?.text?.digestHex(DigestAlgorithm.MD5)
        Alamofire.request(.POST, ConstantPara.loginAPI, parameters: [ConstantPara.username:(nameInput?.text)!,ConstantPara.password:password_md5!,ConstantPara.captcha_value:(confirmField?.text)!,ConstantPara.platform:"ios",ConstantPara.device_token:"token_sample"], encoding: .JSON, headers: nil).responseJSON { response in
            
            HUD.hide(animated: true)
            
            let resultDict = response.result.value
         
            guard let _ = response.result.value else{
                
                HUD.flash(.LabeledError(title: "网络错误", subtitle: nil))
                return
            }
        
            let statusCode = resultDict!["status"] as! Int
            if(statusCode != StatusCode.login_success.rawValue){
                
                let reason = StatusCode.reasonPhraseForStatusCode(StatusCode(rawValue: statusCode)!)
                
                self.wrapFetchConfirmData()
                
                HUD.flash(HUDContentType.LabeledError(title: reason, subtitle: nil), delay: 2)
                
                return;
            }
            
            //MARK: - 登陆成功
            //将登陆成功信息同步到本地
            
            print(response.result.value)
            let jsonDict = response.result.value!
            
            let username = (self.nameInput?.text)!
            
            let userm = UserModel(userName: username, session_token: jsonDict["session_token"] as! String)


            //同步本地用户信息
            ConstantPara.updateCachedWithKey(ConstantPara.loginedKey, andObj: userm)
            
            //获取好友列表
            Alamofire.request(.POST, ConstantPara.getFriendAPI, parameters: [ConstantPara.loginedKey:(self.nameInput?.text)!,ConstantPara.session_token:userm.session_token], encoding: .JSON, headers: nil).responseJSON(completionHandler: { response in
                
                let resultDict = response.result.value
                print(resultDict)
                guard resultDict != nil else{
                
                    return
                }
                let statusCode = resultDict![ConstantPara.status] as? Int
                if(statusCode == StatusCode.get_or_add_success.rawValue){//获取成功
                    
                  
                    let friendsList = (resultDict![ConstantPara.friendsKey]) as! [Dictionary<String,AnyObject>]
                    
                    var friends = [FriendModel]()
                    
                    for dict in friendsList{
                      
                        let finalDict = dict 
                        let friendModel = FriendModel(address: (finalDict[ConstantPara.address] as! String), nickname: (finalDict[ConstantPara.nickname] as! String), username: (finalDict[ConstantPara.username] as! String))
                      
                        friends.append(friendModel)
                    }
                    
                    let key = (userm.userName as String) + ConstantPara.friendListCachedKey
                    
                    ConstantPara.updateCachedWithKey(key, andObj: friends)
                    
//                    //这里的网络是异步的，因此为了保证好友列表能够得到及时的更新，当获取到数据时实时发送通知
//                    NSNotificationCenter.defaultCenter().postNotificationName(ConstantPara.synFriendsListKey, object: nil)
                    
                    
                    //请求添加好友
                    let verifys = resultDict![ConstantPara.verify_friends] as! [String]
                    let tkey = (userm.userName as String) + ConstantPara.verifyCachedKey
                    if(ConstantPara.isKeyCached(tkey)){
                    
                        var t_verify = ConstantPara.cachedObjForKey(tkey) as! [String]
                        
                        for t in verifys{
                        
                            if(t_verify.contains(t) == false){
                            
                                t_verify.append(t)
                            }
                            
                        }
                        
                        ConstantPara.updateCachedWithKey(tkey, andObj: t_verify)
                        
                    }else{
                    
                        ConstantPara.updateCachedWithKey(tkey, andObj: verifys)
                    }
                    
                    /*这个地方的逻辑是:
                     等到登陆成功才去获取好友列表，而只有获取到好友列表才切换根视图控制器，意味着进入到主界面时，已经获取到好友列表了【好友列表中可以没有好友】，获取后，好友列表保存在本地
                     */
                    
                    //切换控制器
                    NSNotificationCenter.defaultCenter().postNotificationName(ConstantPara.notiKey, object: nil)
                    
                    
                    //重构后这里没必要了
                    NSNotificationCenter.defaultCenter().postNotificationName(ConstantPara.synFriendsListKey, object: nil)
                    
                    return
                }
                
                HUD.flash(.LabeledError(title: "获取好友列表失败", subtitle: nil), delay: 1.2)
                print(resultDict)
            })
            
            print(NSHomeDirectory())
        }
        
    }
    
    
    
    
}



extension LoginViewController:UITextFieldDelegate{
    
 
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if(textField.tag == 2001){
            
            if(textField.text != recodeStrign){
            
                recodeStrign = textField.text!
                
                wrapFetchConfirmData()
                
            }
            
        

        }
    }
    
    //MARK:封装请求验证码
    func wrapFetchConfirmData(){
        
        Alamofire.request(.POST, ConstantPara.registerAPI, parameters: [ConstantPara.username:(nameInput?.text)!,"type":"image"], encoding: .JSON, headers: nil).responseJSON{ response in
            
            do{
                
                let json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .AllowFragments)
                
                let jsonData = json["captchaimage"] as? String
                let imageData = NSData(base64EncodedString: jsonData!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                self.confirmCodeImage?.image = UIImage(data: imageData!)
                
            }catch {
                
                HUD.show(.Error)
                HUD.hide(afterDelay: 2)
                
            }
            
        }
    }
    
    func clearTheInputField(){
        
        nameInput?.text = ""
        passInput?.text = ""
        confirmField?.text = ""
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
            self.view.endEditing(true)
        
    }
}

