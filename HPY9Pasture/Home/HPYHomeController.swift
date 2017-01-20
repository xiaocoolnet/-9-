//
//  HPYHomeController.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import SACollectionViewVerticalScalingFlowLayout


class HPYHomeController: UIViewController ,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    var collectionView : UICollectionView!
    let kCellIdentifier = "Cell"
    var scrolling = false
    let backImageView = UIImageView()//背景图
    
    // 懒加载(毛玻璃效果)
    lazy var lasyEffectView:UIVisualEffectView = {
        // iOS8 系统才有
        let tempEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.ExtraLight))
        tempEffectView.frame = self.view.bounds;
        tempEffectView.alpha = 0.8
        // 添加手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.effectViewTouch(_:)))
        tempEffectView.addGestureRecognizer(tap)
        return tempEffectView
    }()
    
    
    let textArray = ["医疗保健","服务商城","便民商城","远程管理","视频认证","智慧养老"]
    let imageArray = ["yilioabaopjian","fuwushangcheng","bianminshangcheng","shouye_yuanchengguanli","shouye_shipinrenzheng","shouye_zhihuiyanglao"]
    
    
    func effectViewTouch(tap:UITapGestureRecognizer) {
        // 移除毛玻璃
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
        }
    }
    func showEffectView() {
        // 点击显示毛玻璃的判断
        
        if (lasyEffectView.superview != nil) {
            lasyEffectView.removeFromSuperview()
        }else{
            self.view.addSubview(lasyEffectView)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor.whiteColor()
        self.title = "快乐9号"
        self.tabBarItem.title = "首页"
        //导航右侧按钮
        //TODO:添加毛玻璃效果测试用，方便以后使用
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "毛玻璃", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.showEffectView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "email"),style: UIBarButtonItemStyle.Plain,target: self, action: #selector(self.showEffectView))
        createUI()
        // Do any additional setup after loading the view.
    }
    
    
    
    func createUI(){
        backImageView.frame = CGRectMake(0, 0, WIDTH, 295*px)
        backImageView.image = UIImage(named:"首页圆形")
        self.view.addSubview(backImageView)
        
        let layout = UICollectionViewFlowLayout.init()
        
//         let layout = SACollectionViewVerticalScalingFlowLayout.init()
//        layout.scaleMode = .Hard
//        layout.alphaMode = .Hard
        
        layout.scrollDirection = .Horizontal
        layout.itemSize = CGSizeMake(110*px, 110*px)
        layout.sectionInset = UIEdgeInsetsMake(5*px, 5*px, 5*px, 5*px)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame:CGRectMake(0, backImageView.height, WIDTH, 110*px),collectionViewLayout:layout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(SACollectionViewVerticalScalingCell.self, forCellWithReuseIdentifier: kCellIdentifier)
        //        collectionView.tag = 10003
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        //        collectionView.frame =
        self.view.addSubview(collectionView)
        
        //智慧养老
        let downButton = MainImageAndTextButton.init(frame: CGRectMake((WIDTH-100*px)/2, collectionView.frame.origin.y+collectionView.height+10*px, 100*px, 100*px), imageFrame: CGRectMake(9*px, 0, 82*px, 82*px), textFrame: CGRectMake(0, 82*px, 100*px, 28*px), imageName: self.imageArray[self.textArray.count-1], labelText: self.textArray[self.textArray.count-1])
        downButton.downTextLable.font = UIFont.systemFontOfSize(14)
        
        downButton.tag = self.textArray.count-1
        downButton.addTarget(self, action: #selector(self.myButtonAction(_:)), forControlEvents: .TouchUpInside)
        downButton.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(downButton)
        
//        for index in 0...5 {
//            let myButton = UIBounceButton.init(frame: CGRectMake(WIDTH/2, -300, 150*px, 110*px))
//            myButton.tag = index
//            myButton.addTarget(self, action: #selector(self.myButtonAction(_:)), forControlEvents: .TouchUpInside)
//            myButton.backgroundColor = UIColor.clearColor()
//            let backView = UIView.init(frame:myButton.frame)
//            backView.backgroundColor = UIColor.whiteColor()
//            backView.alpha = 0
//            backView.layer.masksToBounds = true
//            backView.layer.cornerRadius = 5
//            self.view.addSubview(backView)
//            let imageViews = UIImageView.init(frame: CGRectMake(45*px, 10*px, 60*px, 60*px))
//            imageViews.image = UIImage(named: imageArray[index])
//            myButton.addSubview(imageViews)
//            
//            let textLabel = FXLabel.init(frame: CGRectMake(0, 75*px, 150*px, 35*px))
//            textLabel.text = textArray[index]
//            textLabel.textAlignment = .Center
//            textLabel.font = MainFont
//            textLabel.textColor = UIColor.whiteColor()
//            textLabel.shadowColor = nil
//            textLabel.shadowOffset = CGSizeMake(0.0, 2.0)
//            textLabel.shadowColor = RGBACOLOR(0, g: 0, b: 0, a: 0.75)
//            textLabel.shadowBlur = 5.0
//            myButton.addSubview(textLabel)
//            myButton.alpha = 0
//            self.view.addSubview(myButton)
//            
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(1)
//            //
//            myButton.frame = CGRectMake(20*px + CGFloat((index)%2)*(WIDTH/2-10*px), 40*px+CGFloat(index/2)*140*px, 150*px, 110*px)
//            backView.frame = myButton.frame
//            myButton.alpha = 1
//            backView.alpha = 0.65
//            UIView.commitAnimations()
//        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func myButtonAction(sender:UIButton){
        switch sender.tag {
        case 0:
            break
        case 1:
            break
        case 2:
            break
        case 3:
            break
        case 4:
            break
        case 5:
            let vc = WisdomControllerViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let tagNumber = indexPath.item
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! SACollectionViewVerticalScalingCell
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath)
        
//        if let cell = cell as? SACollectionViewVerticalScalingCell {
        for myview in (cell.containerView?.subviews)! {
            myview.removeFromSuperview()
        }
        
        let headerCellView = MainImageAndTextButton.init(frame: CGRectMake(0, 0, 110*px, 110*px), imageFrame: CGRectMake(9*px, 0, 82*px, 82*px), textFrame: CGRectMake(0, 82*px, 100*px, 28*px), imageName: self.imageArray[tagNumber], labelText: self.textArray[tagNumber])
        headerCellView.downTextLable.font = UIFont.systemFontOfSize(14)
    
        headerCellView.tag = tagNumber
        headerCellView.addTarget(self, action: #selector(self.myButtonAction(_:)), forControlEvents: .TouchUpInside)
        headerCellView.backgroundColor = UIColor.whiteColor()
        cell.containerView?.addSubview(headerCellView)
        
            //            let number = (indexPath as NSIndexPath).row % 7 + 1
//        NSLOG(cell.bounds)
        return cell
    }
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        scrolling = true
//        navigationController?.setNavigationBarHidden(true, animated: true)
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        scrolling = false
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
//            if !self.scrolling {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//            }
//        })
//        
//        
//    }

    
}



