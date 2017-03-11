//
//  AdressEditViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON


struct addressInfo {
    var name = ""
    var adress = ""
    var phone = ""
    var longitude = ""
    var latitude = ""
}
typealias backAdressSelectBlock = (address:addressInfo)->Void


class AdressEditViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var addressBlock = backAdressSelectBlock?()
    
    var isselected = Bool()
    let mytableView = UITableView()
    let rightButton = UIButton()
    var adressInfo :Array<JSON> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的地址"
        self.view.backgroundColor = LGBackColor

        self.mytableView.frame = CGRectMake(0, 10*px, WIDTH, HEIGHT-64-43*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.registerNib(UINib(nibName: "AdressEditTableViewCell",bundle: nil), forCellReuseIdentifier: "AdressEditTableViewCell")
        
        self.rightButton.frame = CGRectMake(0, 0, 80*px, 70*px)
        self.rightButton.titleLabel?.font = MainFont
        if isselected{
            self.rightButton.setTitle("编辑地址", forState: .Normal)
        }else{
            self.rightButton.setTitle("新增", forState: .Normal)
        }
        
        self.rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.rightButton.addTarget(self, action: #selector(self.rightButtonAction), forControlEvents: .TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: self.rightButton)
        
        
        self.view.addSubview(self.mytableView)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData(){
        if USERLC != nil&&USERLC!["userid"] != nil{
             AppRequestManager.shareManager.GetMyAddressList(USERLC!["userid"] as! String, handle: { (success, response) in
                if success{
                    let userinfo = JSON(data: response as! NSData)
                    if userinfo["data"] != nil{
                        self.adressInfo = userinfo["data"].array!
                        self.mytableView.reloadData()
                    }
                }else{
                    self.adressInfo = []
                    self.mytableView.reloadData()
                    Alert.shareManager.alert("你还没有地址信息，请添加", delegate: self)
                }
                
             })
        }
       
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 73*px
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if isselected{
            if self.addressBlock != nil{
                
                let addressinfo = addressInfo.init(name: self.adressInfo[indexPath.row]["name"].string!, adress: self.adressInfo[indexPath.row]["address"].string!, phone: self.adressInfo[indexPath.row]["phone"].string!, longitude: self.adressInfo[indexPath.row]["longitude"].string!, latitude: self.adressInfo[indexPath.row]["latitude"].string!)
                self.addressBlock!(address: addressinfo)
            }
        }
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return adressInfo.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("AdressEditTableViewCell", forIndexPath: indexPath)as!AdressEditTableViewCell
        if self.adressInfo[indexPath.row]["address"].string != nil{
            cell.adress.text = self.adressInfo[indexPath.row]["address"].string
        }
        if self.adressInfo[indexPath.row]["name"].string != nil{
            cell.name.text = self.adressInfo[indexPath.row]["name"].string
        }
        if self.adressInfo[indexPath.row]["phone"].string != nil{
            cell.phoneLabel.text = self.adressInfo[indexPath.row]["phone"].string
        }
        if isselected{
            cell.delButton.hidden = true
            cell.accessoryType = .DisclosureIndicator
        }else{
            cell.delButton.hidden = false
            cell.accessoryType = .None
        }
        cell.delButton.tag = indexPath.row
        cell.delButton.addTarget(self, action: #selector(self.delAction(_:)), forControlEvents: .TouchUpInside)
        cell.selectionStyle = .None
        return cell
    }

    
    //MARK:----ACTION
    
    func rightButtonAction(){
        if isselected{
            let vc = AdressEditViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = AddAdressViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    func delAction(sender:UIButton){
        if USERLC != nil&&USERLC!["userid"] != nil{
            if self.adressInfo[sender.tag]["id"].string != nil{
                AppRequestManager.shareManager.DeleteAddress(USERLC!["userid"] as! String, addressid: self.adressInfo[sender.tag]["id"].string!, handle: { (success, response) in
                    if success{
                        Alert.shareManager.MBAlert("已删除", view: self.view)
                        self.getData()
                    }else{
                        Alert.shareManager.alert("删除失败", delegate: self)
                        
                    }
                })
            }
            
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
