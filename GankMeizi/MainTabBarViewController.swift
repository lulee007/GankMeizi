//
//  MainTabBarViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/26.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        Defaults[.launchCount] += 1
        
        self.tabBar.tintColor = ThemeUtil.colorWithHexString(ThemeUtil.ACCENT_COLOR)
        
        // 1、设置导航栏标题属性：设置标题颜色
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        // 2、设置导航栏前景色：设置item指示色
        self.navigationController?.navigationBar.barTintColor = ThemeUtil.colorWithHexString(ThemeUtil.DARK_PRIMARY_COLOR)
        
        // 3、设置导航栏前景色：设置item指示色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let caption = UILabel()
        let frame = self.navigationController?.navigationBar.bounds
        caption.frame = CGRectMake((frame?.origin.x)!, (frame?.origin.y)!, 20, (frame?.size.height)!)
        caption.text = "GANK.IO"
        caption.textColor = UIColor.whiteColor()
        caption.font = UIFont(name: "GillSans-Bold", size: 18)
        caption.sizeToFit()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: caption)
        super.viewDidLoad()
        launchAnimation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: 启动画面过渡效果
    
    func launchAnimation()  {
        if !Defaults[.splashAnimated] {
            Defaults[.splashAnimated] = true
            let toAnimVC = ControllerUtil.loadViewControllerWithName("LaunchScreen", sbName: "LaunchScreen")
            
            let launchView = toAnimVC.view
            let mainWindow = UIApplication .sharedApplication().keyWindow
            launchView.frame = (mainWindow?.frame)!
            mainWindow?.addSubview(launchView)
            
            UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                launchView.alpha = 0.0
                launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 1.0)
            }) { (finished) in
                launchView.removeFromSuperview()
            }
        }
    }
    
    //MARK: 对外接口
    
    static func buildController() -> MainTabBarViewController{
        let controller = ControllerUtil.loadViewControllerWithName("MainTabBar", sbName: "Main") as! MainTabBarViewController
        // does not need anim
        Defaults[.splashAnimated] = true
        return controller
    }

}
