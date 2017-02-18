//
//  FamilyServerVC.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import PagingMenuController
class FamilyServerVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "家庭服务"
        self.view.backgroundColor = LGBackColor
        let familyServerForChildVC = FamilyServerForChildVC()
        let familyCareForChildVC = FamilyCareForChildVC()
        let clothesWashServerForChildVC = ClothesWashServerForChildVC()
        familyServerForChildVC.title = "家政服务"
        familyCareForChildVC.title = "家庭陪护"
        clothesWashServerForChildVC.title = "洗衣服务"
        
        let viewControllers = [familyServerForChildVC,familyCareForChildVC,clothesWashServerForChildVC]
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
