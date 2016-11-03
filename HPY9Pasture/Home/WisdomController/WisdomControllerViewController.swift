//
//  WisdomControllerViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/11/1.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class WisdomControllerViewController: UIViewController,SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource {
    
    let mytableView = UITableView()
    
    
    let imageArray = ["zhihuishequ","jigouyanglao","jujiayanglao","shishangshegnhuo"]
    let mainTitleArray = ["智慧社区","机构养老","居家养老","时尚生活"]
    let titleArray = ["涵盖了社区全部内容","涵盖了社区全部内容","涵盖了社区全部内容","你可以在这里看电影，看话剧..."]
    let textColorArray = [RGBACOLOR(255, g: 112, b: 67, a: 1),RGBACOLOR(144, g: 195, b: 86, a: 1),RGBACOLOR(243
        , g: 209, b: 51, a: 1),RGBACOLOR(248, g: 132, b: 162, a: 1)]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "智慧养老"
        self.view.backgroundColor = LGBackColor
        self.createUI()
        // Do any additional setup after loading the view.
    }

    func createUI(){
        
        mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        mytableView.backgroundColor = LGBackColor
        mytableView.delegate = self
        mytableView.dataSource = self
        mytableView.sectionHeaderHeight = 10
        mytableView.separatorStyle = .None
        mytableView.tableFooterView = UIView()
        mytableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(mytableView)
        
        
        let myImageScroolView = SDCycleScrollView.init(frame: CGRectMake(0, 0, Screen_W, 160*px), delegate: self, placeholderImage: UIImage(named: "zhihui_tupainzanshiwufaxinashi"))
        
        myImageScroolView.imageURLStringsGroup = ["http://www.lagou.com/upload/webproduct/bd00394b005842dfa13364678d2ff6cd.jpg","http://imgsrc.baidu.com/forum/w%3D580/sign=35f5eb13f703738dde4a0c2a831ab073/80b0bd6eddc451da0d3f9858b7fd5266d1163219.jpg","http://s7.sinaimg.cn/mw690/005Xo3wSgy6WfLXd2n4c6&690","http://img5.duitang.com/uploads/item/201408/01/20140801115317_YSzEn.thumb.700_0.jpeg"]
        
        self.mytableView.tableHeaderView = myImageScroolView
    }
    
    
    //MARK: ------TableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 87*px
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row {
        case 0:
            let homeCareViewController = MapSelectViewController()
            //        homeCareViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeCareViewController, animated: true)
            break
        case 2:
            let homeCareViewController = HPYHomeCareViewController()
            //        homeCareViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeCareViewController, animated: true)
            break
        default:
            break
        }
        
        print(indexPath)
    }
    
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return mainTitleArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
//        let cell = tableView.dequeueReusableCellWithIdentifier("mytableViewCell", forIndexPath: indexPath)
        let cell = PublicTableViewCell.init(style: .Subtitle)
        cell.detailTextLabel?.text = titleArray[indexPath.row]
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(13)
        cell.detailTextLabel?.textColor = UIColor.grayColor()
        cell.imageView?.image = UIImage(named: imageArray[indexPath.row])
        cell.textLabel?.text = mainTitleArray[indexPath.row]
        cell.textLabel?.font = MainFont
        cell.textLabel?.textColor = textColorArray[indexPath.row]
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        return cell
        
        
        
        
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mysectionView = UILabel()
        mysectionView.backgroundColor = LGBackColor
        mysectionView.frame = CGRectMake(0, 0, Screen_W, 10)
        return mysectionView
        
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
