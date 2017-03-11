//
//  LawHelpViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/6.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class LawHelpViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    

    var type = String()
    let mytableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mytableView.frame = CGRectMake(0, 10*px, WIDTH, HEIGHT-64-43*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.registerNib(UINib(nibName: "LawHelpTableViewCell",bundle: nil), forCellReuseIdentifier: "LawHelpTableViewCell")
        self.view.addSubview(self.mytableView)

        // Do any additional setup after loading the view.
    }
    
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 80
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let vc = EquityProtectServerDetailedViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("LawHelpTableViewCell", forIndexPath: indexPath)as!LawHelpTableViewCell
        cell.headerImage.backgroundColor = UIColor.redColor()
        cell.name.text = "纯纯"
        cell.adress.text = "青岛市市北区"
        cell.disLabel.text = "已帮助3524545人解决问题"
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
