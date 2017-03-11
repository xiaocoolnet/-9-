//
//  RightsAndInterestsEnsureViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import PagingMenuController

class RightsAndInterestsEnsureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "权益保障"
        self.view.backgroundColor = LGBackColor
        let childVC1 = LawHelpViewController()
        childVC1.type = "1"
        let childVC2 = LawHelpViewController()
        childVC2.type = "2"
        let childVC3 = LawHelpViewController()
        childVC3.type = "3"
        childVC1.title = "法律咨询"
        childVC2.title = "家庭纠纷"
        childVC3.title = "经济争端"
        
        
        let viewControllers = [childVC1,childVC2,childVC3]
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

        // Do any additional setup after loading the view.
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
