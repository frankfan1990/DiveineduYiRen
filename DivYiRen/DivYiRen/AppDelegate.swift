//
//  AppDelegate.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/25.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit
import Starscream

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

        
    var window: UIWindow?
    var item3:UITabBarItem?
    var vc:UIViewController{
    
        
        if(ConstantPara.isKeyCached(ConstantPara.loginedKey)){
            
        
            let tabBarCV = UITabBarController()
            
            let addressBookVC = AddressBookViewController()
            addressBookVC.view.backgroundColor = addressBookVC.view.backgroundColor
            let moreViewController = MoreViewController()
            moreViewController.addressBookRef = addressBookVC
            
            tabBarCV.viewControllers = [UINavigationController(rootViewController: ViewController()),UINavigationController(rootViewController:addressBookVC),UINavigationController(rootViewController: moreViewController)]
            
            let item1 = tabBarCV.tabBar.items![0]
            let item2 = tabBarCV.tabBar.items![1]
            item3 = tabBarCV.tabBar.items![2]
            
            item1.title = "首页"
            item2.title = "通讯录"
            item3!.title = "更多"
            tabBarCV.tabBar.translucent = false
            tabBarCV.tabBar.tintColor = UIColor.greenColor()
            
            return tabBarCV
            
        }else{
        
            let lg = LoginViewController()
            let nvCV = UINavigationController(rootViewController: lg)
            nvCV.navigationBar.hidden = true
            return nvCV
        }
    
        
    }
    
    func changeViewControllerNoti(noti:NSNotification){
    
        self.window?.rootViewController = self.vc
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeViewControllerNoti(_:)), name: ConstantPara.notiKey, object: nil)
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = self.vc
        
       
        
        UIApplication.sharedApplication().registerForRemoteNotifications()
        return true
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        
        let tokenString = Utils.dataToHexString(deviceToken)
        if(ConstantPara.isKeyCached(ConstantPara.device_token) == false){
            
            ConstantPara.keyCaching(ConstantPara.device_token, withObj: tokenString)
        }
        print(tokenString)
    }

    func applicationWillTerminate(application: UIApplication) {
        
        if(WebSocketManager.shareWebSocketManager.webSocket?.isConnected == true){
        
            WebSocketManager.shareWebSocketManager.webSocket?.disconnect()
        }
    }

}

