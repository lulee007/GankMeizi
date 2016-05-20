//
//  ViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/16.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import RxSwift

public class MainViewController: UIViewController {
    
    var needAnim: Bool = true
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        launchAnimation()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func launchAnimation()  {
        if needAnim {
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
    
    public static func buildController() -> MainViewController{
        let controller = ControllerUtil.loadViewControllerWithName("MainView", sbName: "Main") as! MainViewController
        controller.needAnim = false
        return controller
    }
    
    
    
}

