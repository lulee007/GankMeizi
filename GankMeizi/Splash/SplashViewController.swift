//
//  WelcomeViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/19.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import EAIntroView
import CocoaLumberjack

class SplashViewController: UIViewController,EAIntroDelegate {
    
    let pageTitles = [
        "技术干货",
        "精选妹纸美图",
        "午间放松视频"
        
    ]
    let pageDescriptions = [
        "为大家精选的技术干货，充电充电充电",
        "每天一张精选的美丽妹纸图，放空你的思绪",
        "中午小憩一会儿，戴上耳机以免可能影响他人"
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildAndShowIntroView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func introDidFinish(introView: EAIntroView!) {
        DDLogDebug("欢迎页结束，进入主页")
        self.presentViewController(MainViewController.buildController(), animated: true, completion: nil)
        
    }
    
    func buildAndShowIntroView()  {
        self.view.backgroundColor = UIColor.init(red: 0, green: 0.49, blue: 0.96, alpha: 1.0)
        var pages = [EAIntroPage]()
        for pageIndex in 0..<3{
            let page = EAIntroPage.init()
            page.title = pageTitles[pageIndex]
            page.desc = pageDescriptions[pageIndex]
            pages.append(page)
        }
        let eaIntroView = EAIntroView.init(frame: (self.view.bounds), andPages: pages)
        eaIntroView.titleView = UIImageView.init(image: scaleImage(UIImage(named: "SplashTitle")!, toSize: CGSize.init(width: 135, height: 135)))
        eaIntroView.titleViewY = 90
        eaIntroView.backgroundColor = UIColor.init(red: 0, green: 0.49, blue: 0.96, alpha: 1.0)
        eaIntroView.skipButton.setTitle("跳过", forState: UIControlState.Normal)
        eaIntroView.delegate = self
        eaIntroView.showInView(self.view, animateDuration: 0.3)
        DDLogDebug("初始化完成并显示欢迎页")
        
    }
    func scaleImage(image: UIImage, toSize newSize: CGSize) -> (UIImage) {
        let newRect = CGRectIntegral(CGRectMake(0,0, newSize.width, newSize.height))
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetInterpolationQuality(context, .High)
        let flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height)
        CGContextConcatCTM(context, flipVertical)
        CGContextDrawImage(context, newRect, image.CGImage)
        let newImage = UIImage(CGImage: CGBitmapContextCreateImage(context)!)
        UIGraphicsEndImageContext()
        return newImage
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }
    
    
}
