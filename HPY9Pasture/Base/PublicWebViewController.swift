//
//  PublicWebViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 17/2/15.
//  Copyright © 2017年 xiaocool. All rights reserved.
//

import UIKit

class PublicWebViewController: UIViewController,UIWebViewDelegate {

    let webView = UIWebView()
    var url = NSURL()
    let processView = UIProgressView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        processView.frame = CGRectMake(0, HEIGHT-64-34, WIDTH, 4)
        processView.backgroundColor = UIColor.whiteColor()
        processView.progressTintColor = NavColor
        processView.progress = 0
        
//        UIView.animateWithDuration(0.8) { 
//            self.processView.progress = 0.8
//        }
        webView.frame = CGRectMake(0, 0, WIDTH,HEIGHT-64-34)
        webView.loadRequest(NSURLRequest(URL: url))
        webView.delegate = self
        self.view.addSubview(webView)
        
        let attentionLabel = UILabel()
        attentionLabel.frame = CGRectMake(0,HEIGHT-64-34, WIDTH, 30)
        attentionLabel.font = UIFont.systemFontOfSize(12)
        attentionLabel.backgroundColor = UIColor.redColor()
        attentionLabel.textColor = UIColor.whiteColor()
        attentionLabel.text = "⚠️注意：本平台对第三方平台进行的购买和登录注册行为所产生的损失概不负责"
        attentionLabel.numberOfLines = 0
        attentionLabel.lineBreakMode = .ByWordWrapping
        self.view.addSubview(attentionLabel)
        
        // Do any additional setup after loading the view.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIView.animateWithDuration(0.2) {
            self.processView.progress = 1.0
        }
        self.processView.progress = 0
    }
    func webViewDidStartLoad(webView: UIWebView) {
        UIView.animateWithDuration(0.8) {
            self.processView.progress = 0.8
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
