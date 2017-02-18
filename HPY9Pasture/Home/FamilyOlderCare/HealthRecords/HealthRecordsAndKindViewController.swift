//
//  HealthRecordsViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/20.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
import PagingMenuController

class HealthRecordsAndKindViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "健康档案"
        self.view.backgroundColor = LGBackColor
        let recordsViewController = RecordsVC()
        let kindViewController = KindVC()
        recordsViewController.title = "健康档案"
        kindViewController.title = "病种归类"
        
        let viewControllers = [recordsViewController,kindViewController]
        let options = PagingMenuOptions()
        options.menuHeight = 40*px
        options.menuItemMode = .Underline(height: 3, color: NavColor, horizontalPadding: 0, verticalPadding: 0)
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
