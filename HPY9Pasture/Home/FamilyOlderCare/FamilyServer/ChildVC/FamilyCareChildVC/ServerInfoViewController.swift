//
//  ServerInfoViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/21.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import PagingMenuController

class ServerInfoViewController: UIViewController {
    
    var pagingMenuController : PagingMenuController! = nil
    var headerBackImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true

        self.title = "丁优雅的资料"
        self.view.backgroundColor = LGBackColor
        let serverInfoVC = InfoForServerViewController()
        let evaluateListVC = EvaluateListForServerViewController()
        serverInfoVC.title = "基本信息"
        evaluateListVC.title = "他的评价"
        self.CreatUI()
        
        let viewControllers = [serverInfoVC,evaluateListVC]
        let options = PagingMenuOptions()
        options.menuHeight = 40*px
        options.menuItemMode = .Underline(height: 3, color: NavColor, horizontalPadding: 0, verticalPadding: 0)
        options.selectedTextColor = NavColor
        options.selectedFont = UIFont.systemFontOfSize(13)
        options.font = UIFont.systemFontOfSize(13)
        options.menuItemMargin = 3
        options.menuDisplayMode = .SegmentedControl
        pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController.view.frame = CGRectMake(0, 106, WIDTH, HEIGHT-106)
        
        
        
        self.addChildViewController(pagingMenuController)
        self.view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
        serverInfoVC.changeView = {(indexss,types)->CGFloat in
            self.pagingMenuController.view.frame = CGRectMake(0, types+indexss, WIDTH, HEIGHT-types-indexss)
            self.headerBackImageView.alpha =  self.pagingMenuController.view.frame.height/106
            if self.pagingMenuController.view.frame.origin.y<20{
                self.pagingMenuController.view.frame = CGRectMake(0, 20, WIDTH, HEIGHT)
                return 20
            }else if self.pagingMenuController.view.frame.origin.y>106{
                self.pagingMenuController.view.frame = CGRectMake(0, 106, WIDTH, HEIGHT)
                return 106
            }else{
                return self.pagingMenuController.view.frame.origin.y
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    func CreatUI(){
        headerBackImageView = UIImageView.init(image: UIImage(named: "ic_beijing-1"))
        headerBackImageView.frame = CGRectMake(0, -20, WIDTH, 130)
        self.view.addSubview(headerBackImageView)
        
        //返回按钮
       
        //头像
        let headerImageView = UIImageView.init(image: UIImage(named: ""))
        headerImageView.layer.masksToBounds = true
        headerImageView.layer.cornerRadius = 21
        headerImageView.backgroundColor = UIColor.redColor()
        //名字
        let nameLabel = UILabel()
        nameLabel.text = "丁优雅"
        nameLabel.font = MainFont
        nameLabel.textAlignment = .Left
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.sizeToFit()
        
        //地址
        let adressLabel = UILabel()
        adressLabel.text = "青岛市 市北区"
        adressLabel.font = UIFont.systemFontOfSize(12)
        adressLabel.textAlignment = .Left
        adressLabel.textColor = UIColor.whiteColor()
        adressLabel.sizeToFit()
        
        let prestigeLabel = UILabel()
        prestigeLabel.text = "信誉度"
        prestigeLabel.font = UIFont.systemFontOfSize(11)
        prestigeLabel.textAlignment = .Left
        prestigeLabel.textColor = UIColor.whiteColor()
        prestigeLabel.sizeToFit()
        
        let scoreBackView = UIView()
        scoreBackView.backgroundColor = UIColor.clearColor()
        
        for index in 1...5 {
            let xingImageView = UIImageView.init(frame: CGRectMake(CGFloat((index-1)*15), 1, 13, 13))
            xingImageView.image = UIImage(named: "ic_xing")
            scoreBackView.addSubview(xingImageView)
        }
        let titleLabel = UILabel()
        titleLabel.text = "丁优雅的个人资料"
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.sizeToFit()
        
        
        //添加约束
        headerBackImageView.sd_addSubviews([headerImageView,nameLabel,adressLabel,prestigeLabel,scoreBackView,titleLabel])
        headerImageView.sd_layout()
        .topSpaceToView(headerBackImageView,85*px)
        .leftSpaceToView(headerBackImageView,20*px)
        .heightIs(42)
        .widthIs(42)
        nameLabel.sd_layout()
        .topSpaceToView(headerBackImageView,95*px)
        .leftSpaceToView(headerImageView,10*px)
        .heightIs(20)
        .widthIs(nameLabel.frame.width)
        adressLabel.sd_layout()
            .topSpaceToView(headerBackImageView,100*px)
            .leftSpaceToView(nameLabel,10*px)
            .heightIs(16)
            .widthIs(adressLabel.frame.width)
        prestigeLabel.sd_layout()
            .topSpaceToView(nameLabel,3*px)
            .leftEqualToView(nameLabel)
            .heightIs(15)
            .widthIs(prestigeLabel.frame.width)
        scoreBackView.sd_layout()
            .topSpaceToView(nameLabel,3*px)
            .leftEqualToView(adressLabel)
            .heightIs(15)
            .widthIs(150*px)
        titleLabel.sd_layout()
            .topSpaceToView(headerBackImageView,40*px)
            .leftSpaceToView(headerBackImageView,0)
            .heightIs(25)
            .widthIs(WIDTH)
        
        
        let backButton = UIButton.init(frame: CGRectMake(10, 20, 30, 30))
        backButton.setImage(UIImage(named: "ic_fanhui"), forState: .Normal)
        backButton.backgroundColor = RGBACOLOR(50, g: 50, b: 50, a: 0.5)
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 15
        backButton.addTarget(self, action: #selector(self.backButtonAction), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(backButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:ACTION
    func backButtonAction(){
        self.navigationController?.popViewControllerAnimated(true)
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
