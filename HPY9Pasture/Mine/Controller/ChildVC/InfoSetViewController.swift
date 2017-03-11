//
//  InfoSetViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class InfoSetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let mytableView = UITableView()
    let textArray:Array<String> = ["我的地址","清除缓存"]
    let imageArray:Array<String> = ["ic_wodedizhi","ic_qinglihuancun"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设置"
        self.view.backgroundColor = LGBackColor
        self.navigationController?.navigationBar.hidden = false
        self.mytableView.frame = CGRectMake(0, 0*px, WIDTH, HEIGHT-64)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.registerNib(UINib(nibName: "PublicTableViewCell",bundle: nil), forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(self.mytableView)
        // Do any additional setup after loading the view.
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44*px
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row {
        case 0:
            let vc = AdressEditViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return textArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style:.Default)
        cell.textLabel?.text = textArray[indexPath.row]
        cell.textLabel?.font = MainFont
        cell.textLabel?.textColor = MainTextBackColor
        cell.imageView?.image = UIImage(named: imageArray[indexPath.row])
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        return cell
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
