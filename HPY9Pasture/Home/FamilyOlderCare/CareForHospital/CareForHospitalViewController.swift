//
//  CareForHospitalViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/27.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import PagingMenuController

class CareForHospitalViewController: UIViewController {

    let rightButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "医院陪护"
        self.view.backgroundColor = LGBackColor
        let assignSeverVC = AssignSeverForHosViewController()
        let selfHelpServerVC = SelfHelpServerViewController()
        assignSeverVC.title = "自助服务"
        selfHelpServerVC.title = "点名服务"
        
        
        let viewControllers = [selfHelpServerVC,assignSeverVC]
        let options = PagingMenuOptions()
        options.menuHeight = 40*px
        options.menuItemMode = .Underline(height: 2, color: NavColor, horizontalPadding: 0, verticalPadding: 0)
        options.selectedTextColor = NavColor
        options.selectedFont = UIFont.systemFontOfSize(13)
        options.font = UIFont.systemFontOfSize(13)
        options.menuItemMargin = 3
        options.menuDisplayMode = .SegmentedControl
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        
        self.addChildViewController(pagingMenuController)
        self.view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
        
        self.rightButton.frame = CGRectMake(0, 0, 50*px, 70*px)
        self.rightButton.titleLabel?.font = MainFont
        self.rightButton.setTitle("黑名单", forState: .Normal)
        self.rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.rightButton.addTarget(self, action: #selector(self.rightButtonAction), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.rightButton)

        // Do any additional setup after loading the view.
    }
    
    func rightButtonAction(){
        
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
