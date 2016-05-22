//
//  ViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/16.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import RxSwift
//import CHTCollectionViewWaterfallLayout.Swift

public class MainViewController: UIViewController {
    
    var needAnim: Bool = true
    let gankioApi = GankIOAPI()
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "干货集中营"
        // 1、设置导航栏标题属性：设置标题颜色
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        // 2、设置导航栏前景色：设置item指示色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // 3、设置导航栏半透明
        self.navigationController?.navigationBar.translucent = true
        
        // 4、设置导航栏背景图片
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        // 5、设置导航栏阴影图片
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.articleCollectionView.dataSource = self
//        self.articleCollectionView.delegate = self
        setupCollectionView()
    }
    
    override public func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        launchAnimation()
//        gankioApi.getByDay(2016, month: 2, day: 15)
        gankioApi.getArticleInfoByPage(1, count: 10)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupCollectionView()  {
//        let layout = CHTCollectionViewWaterfallLayout()
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

