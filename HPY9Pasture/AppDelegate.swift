//
//  AppDelegate.swift
//  ASwiftProduct
//
//  Created by xiaocool on 16/4/15.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate ,NIMNetCallManagerDelegate{

    var window: UIWindow?
    var _mapManager: BMKMapManager?
    let NAVC = HPYRootController()
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        /***********************阿里云推送********************************/
        // APNs注册，获取deviceToken并上报
        self
        
        
        
        
        
        /***************** ******网易云信********************************/
        
        NIMSDK.sharedSDK().registerWithAppID("45c6af3c98409b18a84451215d0bdd6e", cerName: "ENTERPRISE")
      
        //视频通话接听回调添加代理
        NIMSDK.sharedSDK().netCallManager.addDelegate(self)
        
        //        NIMSDK.sharedSDK().loginManager.login(<#T##account: String##String#>, token: <#T##String#>, completion: <#T##NIMLoginHandler##NIMLoginHandler##(NSError?) -> Void#>)
        
        /***********************百度地图********************************/
        // 要使用百度地图，请先启动BaiduMapManager
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("ZYrOi8YPt6NoNBvaYV5b2RxC1r0z0Bxv", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = NAVC
        window!.makeKeyAndVisible()
        //set Style
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = NavColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics:.Default)
        UITabBar.appearance().translucent = false
        
        let ud = NSUserDefaults.standardUserDefaults()
        if ud.boolForKey("ISLogin") {//判断是否需要登录
            
        }else{
            //为登录跳转登录页面
            let NAV1 = UINavigationController.init(rootViewController: HPYLoginController())
            NAVC.presentViewController(NAV1, animated: true, completion: {
            
            })
        }
        
        
        return true
    }
    //MARK:-- NIMNetCallManagerDelegate//视频通话接听回调代理
    func onReceive(callID: UInt64, from caller: String, type: NIMNetCallType, message extendMessage: String?) {
        NSLOG("1212121212121")
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
 
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        
       
            
        return true
        
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        
        return true
    }
    
    // MARK:- 阿里云推送
    func initCloudPush() {
        CloudPushSDK.asyncInit("23598585", appSecret: "1c4a3ca3811066dddfa6bade4503b0be") { (res) in
            if (res?.success)! {
                print("Push SDK init success, deviceId: %@.", CloudPushSDK.getDeviceId())
            }else{
                print("Push SDK init failed, error: %@", res?.error ?? "error")
            }
        }
    }
    
    /**
     *    注册苹果推送，获取deviceToken用于推送
     *
     *    @param     application
     */
    func registerAPNS(application:UIApplication) {
        
        // iOS 8 Notifications
        let userSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert],
                                                      categories: nil)
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: userSettings.types,
            categories: nil))
        application.registerForRemoteNotifications()
        
    }
    
    /*
     *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
     */
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        CloudPushSDK.registerDevice(deviceToken) { (res) in
            if (res?.success)! {
                print("Register deviceToken success.")
            }else{
                print("Register deviceToken failed, error: %@", res?.error ?? "error")
            }
        }
    }
    
    
    /*
     *  苹果推送注册失败回调
     */
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotificationsWithError %@", error)
    }
    /**
     *	注册推送通道打开监听
     */
    func listenerOnChannelOpened() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onChannelOpened(_:)), name:"CCPDidChannelConnectedSuccess", object: nil)
        }
    
    /**
     *	推送通道打开回调
     *
     *	@param 	notification
     */
    func onChannelOpened(notification:NSNotification) {
        print("温馨提示:消息通道建立成功")
    }
    
    /**
     *    注册推送消息到来监听
     */
    func registerMessageReceive() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(onMessageReceived(_:)), name: "CCPDidReceiveMessageNotification", object: nil)
        }

    /**
     *    处理到来推送消息
     *
     *    @param     notification
     */
    func onMessageReceived(notification:NSNotification) {
        let message = notification.object as! CCPSysMessage
        let title = NSString(data: message.title, encoding: NSUTF8StringEncoding)
        let body = NSString(data: message.body, encoding: NSUTF8StringEncoding)
        
        print("Receive message title: \(title), content: \(body).")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("App处于启动状态时，通知打开回调")
        // 取得APNS通知内容
        let aps = userInfo["aps"] as? NSDictionary
        // 内容
        let content = aps!["alert"] as? NSString
        // badge数量
        let badge = aps!["badge"] as? NSInteger
        // 播放声音
        let sound = aps!.objectForKey("sound") as? NSString
    }
}

