//
//  HPYRootController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYRootController: UITabBarController {
    
    let community = HPYCommunityCtrler()
    let convenience = HPYConvenienceCtrler()
    let home = HPYHomeController()
    let mine = HPYMineController()
    let video = HPYVideoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configerUI()
        // Do any additional setup after loading the view.
    }
    
    func configerUI(){
        //title
        community.title = "社区"
        convenience.title = "商城"
        home.title = "首页"
        mine.title = "我的"
        video.title = "视频大厅"
        //controller
        setTabbarItemAttribute(community, normalImageName: "community", selectedImageName: "community拷贝")
        setTabbarItemAttribute(convenience, normalImageName: "Convenience", selectedImageName: "Convenience拷贝")
        setTabbarItemAttribute(home, normalImageName: "homepage拷贝", selectedImageName: "homepage")
        setTabbarItemAttribute(mine, normalImageName: "my", selectedImageName: "my拷贝")
        setTabbarItemAttribute(video, normalImageName: "video", selectedImageName: "video拷贝")
        //nav
        let communityNav = UINavigationController(rootViewController: community)
        let convenienceNav = UINavigationController(rootViewController: convenience)
        let homeNav = UINavigationController(rootViewController: home)
        let mineNav = UINavigationController(rootViewController: mine)
        let videoNav = UINavigationController(rootViewController: video)
        
        setViewControllers([homeNav,communityNav,convenienceNav,videoNav,mineNav], animated: true)
    }
    func setTabbarItemAttribute(controller:UIViewController,normalImageName:String,selectedImageName:String){
        
        controller.tabBarItem.image = UIImage(named: normalImageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        controller.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:NavColor], forState: .Selected)
        controller.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.blackColor()],forState: .Normal)
        controller.tabBarItem.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(13)], forState: .Normal)
    }
}
