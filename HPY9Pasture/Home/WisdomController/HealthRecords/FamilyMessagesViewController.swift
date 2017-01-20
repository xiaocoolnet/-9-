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
    var textArray = NSMutableArray()//源数据
    var deleteArr = NSMutableArray()//需要删除的数据
    var buttonText = String()
    var VC = UIViewController()
    let selectAllBtn = UIButton()
    
    let addButton = UIButton()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
//        self.title = "家族信息"
        self.mytableView.frame = CGRectMake(0, 10*px, WIDTH, HEIGHT-64-60*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.editing = false
        self.mytableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(self.mytableView)
        
        addButton.frame = CGRectMake(0, HEIGHT-64-50*px, WIDTH, 50*px)
        addButton.backgroundColor = NavColor
        addButton.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        addButton.setTitle(buttonText, forState: .Normal)
        addButton.addTarget(self, action: #selector(self.addButtonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(addButton)
        
        let selectedBtn = UIButton.init(type: .System)
        selectedBtn.frame = CGRectMake(0, 0, 60, 30)
        selectedBtn.setTitle("编辑", forState: .Normal)
        selectedBtn.titleLabel?.font = MainFont
        selectedBtn.addTarget(self, action: #selector(self.selectedBtnAction(_:)), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: selectedBtn)
        
        self.selectAllBtn.frame = CGRectMake(0, 0, 60, 30)
        
        self.selectAllBtn.setTitle("返回", forState: .Normal)
        selectAllBtn.titleLabel?.font = MainFont
        self.selectAllBtn.addTarget(self, action: #selector(self.selectAllBtnAction), forControlEvents: .TouchUpInside)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.selectAllBtn)
        self.selectAllBtn.hidden = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style:.Plain, target: self, action: nil)
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 44*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if self.mytableView.editing {
            //选中时将选中行的在self.dataArray 中的数据添加到删除数组self.deleteArr中
            self.deleteArr.addObject(self.textArray[indexPath.row])
        }else{
            self.myIndexFunc!(selectIndex:indexPath.row,selectArray:NSDictionary())
        }
        
        
            
        
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
//        cell.selectionStyle = .None
        
        return cell
    }
    
    
    
    //MARK:-------tableViewEdit
    //是否可以编辑  默认的时YES
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    //选择编辑的方式,按照选择的方式对表进行处理
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        }
    }
    //选择你要对表进行处理的方式  默认是删除方式
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        return .Insert
    }
    
    //取消选中时 将存放在self.deleteArr中的数据移除
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if self.mytableView.editing {
            NSLOG(deleteArr)
            NSLOG(textArray)
            self.deleteArr.removeObject(self.textArray[indexPath.row])
        }
    }
    
    //MARK:--------ACTION
    func addButtonAction(){
        if self.mytableView.editing {
            if self.deleteArr.count<1 {
                alert("请选中需要删除的数据", delegate: self)
                return
            }
            self.textArray.removeObjectsInArray(self.deleteArr as [AnyObject])
            self.mytableView.reloadData()
        }else{
            if self.myFunc != nil{
                self.myFunc!()
            }
        }
        
    }
    
    func selectedBtnAction(sender:UIButton){
        
        self.mytableView.allowsMultipleSelectionDuringEditing = true
        self.mytableView.editing = !self.mytableView.editing
        if self.mytableView.editing {
//            self.selectAllBtn.hidden = false
            self.addButton.setTitle("删除", forState: .Normal)
            self.addButton.backgroundColor = UIColor.redColor()
            self.selectAllBtn.setTitle("全选", forState: .Normal)
            sender.setTitle("完成", forState: .Normal)
        }else{
//            self.selectAllBtn.hidden = true
            self.addButton.setTitle(buttonText, forState: .Normal)
            self.addButton.backgroundColor = NavColor
            
            self.selectAllBtn.setTitle("返回", forState: .Normal)
            sender.setTitle("编辑", forState: .Normal)
        }
        
    }
    func selectAllBtnAction(){
        
        if self.mytableView.editing{
            for index in 0...self.textArray.count-1 {
                let indexPath = NSIndexPath.init(forRow: index, inSection: 0)
                self.mytableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .Top)
                self.deleteArr.addObject(self.textArray[index])
            }
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        
//        self.deleteArr = self.textArray
       
            
        
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
