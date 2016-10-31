//
//  CommunityIntroductionViewController.swift
//  HPY9Pasture
//
//  Created by purepure on 16/10/31.
//  Copyright © 2016年 xiaocool. All rights reserved.
//

import UIKit

class CommunityIntroductionViewController: UIViewController,SDCycleScrollViewDelegate,UIWebViewDelegate {
    
    let myScrollView = UIScrollView()//底部滑动view
//    let introductionTextView = UITextView()//简介
    let introductionTextView = UIWebView()//简介
    let stretchButton = UIButton()//伸展按钮
    let busTableView = UITableView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LGBackColor
        self.title = "社区简介"
        myScrollView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)
        self.view.addSubview(myScrollView)
        self.createView()
        
        // Do any additional setup after loading the view.
    }
    
    func createView(){
        let myImageScroolView = SDCycleScrollView.init(frame: CGRectMake(0, 0, Screen_W, 160*px), delegate: self, placeholderImage: UIImage(named: "zhihui_tupainzanshiwufaxinashi"))
        
        myImageScroolView.imageURLStringsGroup = ["http://www.lagou.com/upload/webproduct/bd00394b005842dfa13364678d2ff6cd.jpg","http://imgsrc.baidu.com/forum/w%3D580/sign=35f5eb13f703738dde4a0c2a831ab073/80b0bd6eddc451da0d3f9858b7fd5266d1163219.jpg","http://s7.sinaimg.cn/mw690/005Xo3wSgy6WfLXd2n4c6&690","http://img5.duitang.com/uploads/item/201408/01/20140801115317_YSzEn.thumb.700_0.jpeg"]
        
        self.myScrollView.addSubview(myImageScroolView)
        
        self.introductionTextView.frame = CGRectMake(0, 160*px+10*px, WIDTH, 0)
        self.introductionTextView.userInteractionEnabled = false
        self.introductionTextView.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.my51bang.com/index.php?g=portal&m=article&a=index&id=4")!))
        self.introductionTextView.delegate = self
        
//        self.introductionTextView.text = "  小区采用多层、小高层、高层结合的布局高低错落有秩，所有栋号楼房均为南北朝向，楼间距适度，通风采光良好，为景观、绿化预留了足够的空间。小区南面、西面、北面的沿街面一、二层进行商业开发，方便了小区业主的生活。小区内的公共设施位置设置在对业主影响最小处，使小区内居民有一个宁静的生活环境。公司争取规划部门的同意，在不影响容积率的情况下，多数建筑物做架空层，使一楼业主避免了本地6月份梅雨季节的困扰。考虑到社会的发展，小区内另规划了三个地下车库，使平均每户的停车位超过了其他楼盘和规划主管部门的要求，为今后小区管理、建立和谐社区留下了空间。所有建筑物采用坡屋面，上盖青灰色机瓦，减少了屋面漏水的可能，延长了屋面维修的时间，外立面采用面砖和优质石材饰面，辅以外墙涂料喷涂线条，几项材料、颜色地合理搭配，彰显了小区高贵的品质，凸显了小区与众不同的风格，保证了建筑物不会随着岁月的流逝而破败，而更能显现出其优雅的风韵。"
//        self.introductionTextView.font = MainFont
//        self.introductionTextView.sizeToFit()
//        self.introductionTextView.frame = CGRectMake(10, 160*px+10*px, WIDTH, self.introductionTextView.bounds.size.height)
        self.myScrollView.addSubview(introductionTextView)
        
        
    }
    
    //MARK-----webViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let heights = webView.stringByEvaluatingJavaScriptFromString("document.body.offsetHeight")
        let a = Int(heights!)
        self.introductionTextView.frame = CGRectMake(0, 160*px+10*px, WIDTH, CGFloat(a!))
        self.myScrollView.contentSize = CGSizeMake(WIDTH, CGFloat(a!)+150)
        
        print(webView.frame)
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
