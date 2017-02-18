//
//  SecurityAndOlderCareViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import PagingMenuController

class SecurityAndOlderCareViewController: UIViewController ,PagingMenuControllerDelegate{

    var pagingMenuController:PagingMenuController?
    var viewControllers:Array<UIViewController> = []
    var options = PagingMenuOptions()
    var cID = String()
    let childVC1 = SecurityAndOlderCareChildVC()
    let childVC2 = SecurityAndOlderCareChildVC()
    let childVC3 = SecurityAndOlderCareChildVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "安保+养老"
        self.view.backgroundColor = LGBackColor
        
        childVC1.title = "社区"
        childVC2.title = "家庭"
        childVC3.title = "公共"
        
        viewControllers = [childVC1,childVC2,childVC3]
        
        options.menuHeight = 40*px
//        options.selectedBackgroundColor = NavColor
//        options.backgroundColor = NavColor
        options.menuItemMode = .Underline(height: 3, color: NavColor, horizontalPadding: 0, verticalPadding: 0)
        options.selectedTextColor = NavColor
//        options.textColor = RGBACOLOR(208, g: 231, b: 255, a: 1)
        options.selectedFont = UIFont.systemFontOfSize(13)
        options.font = UIFont.systemFontOfSize(13)
        options.menuItemMargin = 3
        options.menuDisplayMode = .SegmentedControl
        pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController!.delegate = self
        
        self.addChildViewController(pagingMenuController!)
        self.view.addSubview(pagingMenuController!.view)
        pagingMenuController!.didMoveToParentViewController(self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    //MARK:PagingMenuControllerDelegate
    func didMoveToMenuPage(page: Int){
        NSLOG(page)
        switch page {
        case 0:
            childVC1.getData(cID, type: "1")
            break
        case 1:
            childVC2.getData(cID, type: "2")
            break
        case 2:
            childVC3.getData(cID, type: "3")
            break
        default:
            break
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
