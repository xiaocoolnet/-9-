//
//  FamilyKitchenViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/1/13.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit
import SwiftyJSON
import MJRefresh
class FamilyKitchenViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    
    var searchBar = UISearchBar.init(frame: CGRectMake(0, 0, WIDTH, 50))
    var userLocationCenter = NSUserDefaults.standardUserDefaults()
    var searchHistory = NSMutableArray()
    
    let searchHistoryTableview = UITableView()
    let mainTableview = UITableView()
    var restaurantInfo:Array<JSON> = []
    var keyWord = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.title = "家庭厨房"
        setSearchBar()
        creatUI()
        self.mainTableview.mj_header.beginRefreshing()
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.hidden = false
    }
    
    func getData(beginId:String){
        
        AppRequestManager.shareManager.getHomekitchenListByCommunityId("1",beginID:beginId,keyWord: self.keyWord) { (success, response) in
            if success{
                let userInfo1 = JSON(data: response as! NSData)
                if beginId == "0"{
                    self.restaurantInfo = userInfo1["data"].array!
                }else{
                    self.restaurantInfo = self.restaurantInfo + userInfo1["data"].array!
                }
                self.mainTableview.mj_header.endRefreshing()
                self.mainTableview.mj_footer.endRefreshing()
                if userInfo1["data"].array == nil{
                    self.mainTableview.mj_footer.endRefreshingWithNoMoreData()
                }
                
                self.mainTableview.reloadData()
                
            }else{
                self.mainTableview.mj_header.endRefreshing()
                self.mainTableview.mj_footer.endRefreshing()
                Alert.shareManager.alert("数据加载错误！", delegate: self)
            }
        }
    }
    
    func creatUI(){
        
        
        mainTableview.frame = CGRectMake(0, searchBar.height, WIDTH, HEIGHT-searchBar.height)
        mainTableview.delegate = self
        mainTableview.dataSource = self
        mainTableview.backgroundColor = UIColor.whiteColor()
        mainTableview.separatorStyle = .None
        self.mainTableview.registerNib(UINib(nibName: "FamilyKitTableViewCell",bundle: nil), forCellReuseIdentifier: "FamilyKitTableViewCell")
        self.view.addSubview(self.mainTableview)
        
        searchHistoryTableview.frame = CGRectMake(0, searchBar.height, WIDTH, HEIGHT-searchBar.height)
        searchHistoryTableview.delegate = self
        searchHistoryTableview.dataSource = self
        searchHistoryTableview.backgroundColor = UIColor.whiteColor()
        searchHistoryTableview.separatorStyle = .None
        searchHistoryTableview.registerClass(PublicTableViewCell.self, forCellReuseIdentifier: "PublicTableViewCell")
        
        mainTableview.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            NSLOG("MJ:(下拉刷新)")
            self.getData( "0")
            
        })
        mainTableview.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            NSLOG("MJ:(上拉加载)")
            self.getData( "1")
            
        })
        
        searchHistoryTableview.hidden = true
        let headerLabel = UILabel.init(frame: CGRectMake(0, 0, WIDTH, 35))
        headerLabel.text = "搜索历史"
        headerLabel.textAlignment = .Left
        headerLabel.font = MainFont
        self.searchHistoryTableview.tableHeaderView = headerLabel
        self.view.addSubview(searchHistoryTableview)
        
    }
    
    
    //搜索
    func setSearchBar()
    {
        
        
        searchBar.showsCancelButton = true
        searchBar.barStyle = .Default
        searchBar.delegate = self
        searchBar.barTintColor = LGBackColor
        searchBar.placeholder = "输入商家名、商品名       "
        for views in searchBar.subviews[0].subviews {
            if views.isKindOfClass(NSClassFromString("UINavigationButton")!) {
                (views as! UIButton).setTitle("取消", forState: .Normal)
                (views as! UIButton).titleLabel?.font = MainFont
                (views as! UIButton).setTitleColor(RGBACOLOR(98, g: 98, b: 98, a: 1), forState: .Normal)
            }
        }
        let searchBarSearchField = searchBar.valueForKey("_searchField") as! UITextField
        searchBarSearchField.font = MainFont
//        (searchBar.valueForKey("_searchField") as! UITextField).textAlignment = .Left
        searchBarSearchField.setValue(MainFont, forKeyPath: "_placeholderLabel.font")
        searchBarSearchField.returnKeyType = .Search
//        searchBarSearchField.delegate = self
//        (searchBar.valueForKey("_searchField") as! UITextField).layer.masksToBounds = true
//        (searchBar.valueForKey("_searchField") as! UITextField).layer.cornerRadius = (searchBar.valueForKey("_searchField") as! UITextField).frame.size.height
        self.view.addSubview(searchBar)
        
    }
    
    //MARK: -UISarchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if userLocationCenter.objectForKey("SearchFieldHistory") != nil{
            self.searchHistory = userLocationCenter.objectForKey("SearchFieldHistory") as! NSMutableArray
            
        }
        searchHistoryTableview.hidden = false
        searchHistoryTableview.reloadData()
        NSLOG("将要开始编辑")
        
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
    }
    //取消按钮点击事件
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchBar.text = ""
        self.keyWord = ""
        self.getData("0")
        searchHistoryTableview.hidden = true
        
        
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        if tableView == self.mainTableview{
            return 95*px
        }else{
            return 30
        }
        //        return self.textArray.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if tableView == self.mainTableview {
            let vc = FamilyKitchenDetailsViewController()
            vc.restaurantInfo = self.restaurantInfo[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.keyWord = (self.searchHistory[self.searchHistory.count-1-indexPath.row] as? String)!
            self.searchBar.text = self.keyWord
            self.getData("0")
            self.searchHistoryTableview.hidden = true
            searchBar.resignFirstResponder()
        }
    }
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tableView == self.mainTableview {
           
            return (self.restaurantInfo.count)
            
            
        }else{
            
            return self.searchHistory.count
        }

        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if tableView == self.mainTableview {
            let cell = tableView.dequeueReusableCellWithIdentifier("FamilyKitTableViewCell", forIndexPath: indexPath)as!FamilyKitTableViewCell
            cell.selectionStyle = .None
            cell.setUI()
            if self.restaurantInfo[indexPath.row]["address"].string != nil {
                cell.adress.text = self.restaurantInfo[indexPath.row]["address"].string
            }
            if self.restaurantInfo[indexPath.row]["name"].string != nil {
                cell.name.text = self.restaurantInfo[indexPath.row]["name"].string
            }
            if self.restaurantInfo[indexPath.row]["price"].string != nil {
                cell.money.text = "满¥"+(self.restaurantInfo[indexPath.row]["price"].string)!+"起送"
            }
            if self.restaurantInfo[indexPath.row]["phone"].string != nil {
                cell.phone.text = self.restaurantInfo[indexPath.row]["phone"].string
            }
            if self.restaurantInfo[indexPath.row]["image"].string != nil {
                cell.headerImage.sd_setImageWithURL(NSURL.init(string: Happy_ImageUrl+(self.restaurantInfo[indexPath.row]["image"].string)!), placeholderImage: UIImage(named: ""))
                
            }
            
            
            

            
            return cell
        }else{
            let cell = PublicTableViewCell.init(style: .Default)
            cell.textLabel?.font = UIFont.systemFontOfSize(12)
            cell.textLabel?.textColor = MainTextBackColor
            cell.textLabel?.text = self.searchHistory[self.searchHistory.count-1-indexPath.row] as? String
            return cell
        }
    }
    //MARK:uitextfiledDelegate搜索点击事件
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.searchBar.resignFirstResponder()
        searchHistoryTableview.hidden = true
        if (searchBar.valueForKey("_searchField") as! UITextField).text?.characters.count>0{
            NSLOG((searchBar.valueForKey("_searchField") as! UITextField).text)
            let str = (searchBar.valueForKey("_searchField") as! UITextField).text!
            self.keyWord = str
            let newArray = NSMutableArray.init(array: self.searchHistory)
            newArray.addObject(str)
            if self.searchHistory.count > 5{
                self.searchHistory.removeObjectAtIndex(0)
            }
            self.userLocationCenter.setObject(newArray, forKey: "SearchFieldHistory")
        }
        self.getData("0")
        NSLOG("0000000")
    }
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        
//        return true
//    }

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
