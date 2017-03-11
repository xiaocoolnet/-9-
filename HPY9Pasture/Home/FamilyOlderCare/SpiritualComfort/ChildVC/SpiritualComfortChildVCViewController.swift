//
//  SpiritualComfortChildVCViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/3/1.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class SpiritualComfortChildVCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var states = String()
    let mytableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mytableView.frame = CGRectMake(0, 10*px, WIDTH, HEIGHT-64-43*px)
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.backgroundColor = LGBackColor
        self.mytableView.separatorStyle = .None
        self.mytableView.registerNib(UINib(nibName: "SpiritualComfortChildVCTableViewCell",bundle: nil), forCellReuseIdentifier: "SpiritualComfortChildVCTableViewCell")
        self.view.addSubview(self.mytableView)
        // Do any additional setup after loading the view.
    }
    
    //MARK: ------UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 85*px
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let vc = AppointmentInfoForSpiritViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: ------TableViewDatasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("SpiritualComfortChildVCTableViewCell", forIndexPath: indexPath)as!SpiritualComfortChildVCTableViewCell
        cell.selectionStyle = .None
        cell.HeaderImageView.backgroundColor = UIColor.redColor()
        cell.name.text = "张宇"
        cell.CreatUI(5)
        cell.money.text = "350"+"元/小时"
        cell.desLabel.text = "婚恋情感、亲子教育、心理障碍"
        cell.goButton.addTarget(self, action: #selector(self.goButtonAction), forControlEvents: .TouchUpInside)
        return cell
    }
    
    func goButtonAction(){
        let vc = AppointmentInfoForSpiritViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
