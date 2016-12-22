//
//  FamilyMessagesViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/20.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
typealias callBackWithIndexFunc = (selectIndex:Int,selectArray:NSDictionary)->Void
typealias callBackWithViodFunc = () ->Void
class FamilyMessagesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myIndexFunc = callBackWithIndexFunc?()
    var myFunc = callBackWithViodFunc?()
    let mytableView = UITableView()
    var textArray = NSArray()
    var buttonText = String()
    var VC = UIViewController()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "家族信息"
        self.mytableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64-50*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(self.mytableView)
        let addButton = UIButton()
        addButton.frame = CGRectMake(0, HEIGHT-64-50*px, WIDTH, 50*px)
        addButton.backgroundColor = NavColor
        addButton.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        addButton.setTitle(buttonText, forState: .Normal)
        addButton.addTarget(self, action: #selector(self.addButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton)
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        self.myIndexFunc!(selectIndex:indexPath.row,selectArray:NSDictionary())
            
        
    }
    
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return textArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style:.Default)
        cell.textLabel?.font = UIFont.systemFontOfSize(13)
        cell.textLabel?.text = textArray[indexPath.row] as? String
        
        cell.accessoryType = .DisclosureIndicator
        cell.selectionStyle = .None
        
        return cell
    }
    //MARK:--------ACTION
    func addButtonAction(){
        if self.myFunc != nil{
            self.myFunc!()
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
