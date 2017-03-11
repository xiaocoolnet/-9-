//
//  PublicTableViewViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/12/21.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit
typealias callbackfunc=(selectText:String,index:Int)->Void
typealias getListData=()->Void

class PublicTableViewViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var myFunc = callbackfunc?()
    var dataBlock = getListData?()
    
    let myTableView = UITableView()
    var myArray :Array<String> = []
    var nationArray = NSArray()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = LGBackColor
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        myTableView.separatorStyle = .None
        self.myTableView.registerNib(UINib(nibName: "PublicTableViewCell",bundle: nil), forCellReuseIdentifier: "PublicTableViewCell")
        self.view.addSubview(myTableView)
        if dataBlock != nil{
           self.dataBlock!() 
        }
        
        // Do any additional setup after loading the view.
    }
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 44*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if self.myFunc != nil{
            if self.myArray.count < 1 {
                self.myFunc!(selectText:self.nationArray[indexPath.row].objectForKey("name") as! String,index: indexPath.row)
            }else{
                self.myFunc!(selectText:self.myArray[indexPath.row] ,index: indexPath.row)
            }
            
        }
    }
    
    
    //MARK: ------TableViewDatasource
    func  tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.myArray.count < 1 {
            
          return self.nationArray.count
        }else{
          return self.myArray.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = PublicTableViewCell.init(style: .Default)
        cell.accessoryType = .DisclosureIndicator
        if self.myArray.count < 1 {
            cell.textLabel?.text = self.nationArray[indexPath.row].objectForKey("name") as? String

        }else{
            cell.textLabel?.text = self.myArray[indexPath.row]

        }
        cell.textLabel?.font = MainFont
        cell.selectionStyle = .None
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
