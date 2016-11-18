//
//  HPYCommunityCtrler.swift
//  HPY9Pasture
//
//  Created by xiaocool on 16/10/10.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class HPYCommunityCtrler: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate{
    
    var collectionView : UICollectionView?
    var dataArr = NSMutableArray()
    let textArray = ["社区简介","健康档案","第三方缴费","政府采购","社区信息查询","社区服务","远程服务大厅","信息墙","一键通"]
    let imageArray = ["icon1","icon2","icon3","icon4","icon5","icon6","icon7","icon8","icon9"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        configureUI()
    }
    
    func configureUI(){
        // 设置CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView = UICollectionView(frame: CGRectMake(0, 0, Screen_W, Screen_H-64-48), collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView! .registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: "headView")
        
        collectionView?.backgroundColor = LGBackColor
        
        view.addSubview(collectionView!)
    }
    //MARK: ----------collection----------
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake((Screen_W-4)/3, 100)
    }
    //返回多少个组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }
    //返回多少个cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    //返回自定义的cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        
        let headerCellView = MainImageAndTextButton.init(frame: CGRectMake(0, 0, (Screen_W-4)/3, (Screen_W-4)/3), imageFrame: CGRectMake(((Screen_W-4)/3-53*px)/2, 15*px, 53*px, 53*px), textFrame: CGRectMake(0, 68*px, (Screen_W-4)/3, 50), imageName: self.imageArray[indexPath.item], labelText: self.textArray[indexPath.item])
        headerCellView.tag = indexPath.item
        headerCellView.addTarget(self, action: #selector(self.headerCellViewAction(_:)), forControlEvents: .TouchUpInside)
        headerCellView.downTextLable.font = UIFont.systemFontOfSize(14)
        cell.addSubview(headerCellView)
//        cell.accessibilityLabel = String(indexPath.row)
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    //返回HeadView的宽高
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSizeMake(Screen_W, 170*px)
        
    }
    
    
    //返回自定义HeadView
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView{
        let cell = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headView", forIndexPath: indexPath) as UICollectionReusableView
        let myImageScroolView = SDCycleScrollView.init(frame: CGRectMake(0, 0, Screen_W, 160*px), delegate: self, placeholderImage: UIImage(named: "zhihui_tupainzanshiwufaxinashi"))
       
        myImageScroolView.imageURLStringsGroup = ["http://www.lagou.com/upload/webproduct/bd00394b005842dfa13364678d2ff6cd.jpg","http://imgsrc.baidu.com/forum/w%3D580/sign=35f5eb13f703738dde4a0c2a831ab073/80b0bd6eddc451da0d3f9858b7fd5266d1163219.jpg","http://s7.sinaimg.cn/mw690/005Xo3wSgy6WfLXd2n4c6&690","http://img5.duitang.com/uploads/item/201408/01/20140801115317_YSzEn.thumb.700_0.jpeg"]
        
        cell.addSubview(myImageScroolView)
        return cell
    }
    
    //返回cell 上下左右的间距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(1, 1, 1, 1)
    }
    //collectionView点击事件
    func headerCellViewAction(sender:UIButton){
        switch sender.tag {
        case 0:
            let vc = CommunityIntroductionViewController()
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
            break
        case 6:
            let vc = PublicTableViewController()//公共tableViewVC
            vc.cellHeight = 44
            vc.textDatasource = ["退休远程认证","医保远程认证","健康远程认证","婚育远程认证"]//tableView跳转的VC
            vc.vcArray = [RetireServerViewController(),UIViewController(),UIViewController(),UIViewController()]
            vc.title = "远程服务大厅"
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.hidesBottomBarWhenPushed = false
            break
        default:
            break
        }
            }
    
    
    
    
}
