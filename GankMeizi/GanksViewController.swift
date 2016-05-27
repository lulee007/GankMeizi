//
//  GanksViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/27.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import RxSwift
import PageMenu

class GanksViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?
    
    // just wanna to prectice string map and filter
    let articleTypes = "福利 | Android | iOS | 休息视频 | 拓展资源 | 前端".componentsSeparatedByString("|")
        .map { (text: String) -> String in
            return text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
        }
        .filter({!$0.isEmpty})
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupControllers()
    }
    
    func setupControllers()  {
        var controllers: [UIViewController] = []
        for type in articleTypes{
            controllers.append(ArticlesViewController.buildController(type))
        }
        
        let y = UIApplication.sharedApplication().statusBarFrame.height + (self.navigationController?.navigationBar.frame.height)!
        
        let parent = self.parentViewController as! UITabBarController
        
        let parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .ViewBackgroundColor(UIColor.whiteColor()),
            .SelectedMenuItemLabelColor(ThemeUtil.colorWithHexString(ThemeUtil.ACCENT_COLOR)),
                .UnselectedMenuItemLabelColor(ThemeUtil.colorWithHexString(ThemeUtil.LIGHT_PRIMARY_COLOR)),
            .SelectionIndicatorColor(ThemeUtil.colorWithHexString(ThemeUtil.ACCENT_COLOR)),
            .BottomMenuHairlineColor(ThemeUtil.colorWithHexString(ThemeUtil.DIVIDER_COLOR)),
            .MenuItemFont(UIFont(name: "HelveticaNeue", size: 14.0)!),
            .MenuHeight(40.0),
            .MenuItemWidth(90.0),
            .CenterMenuItems(true)
        ]

        
        pageMenu = CAPSPageMenu(viewControllers: controllers, frame: CGRectMake(0, y, self.view.frame.width, self.view.frame.height - y - parent.tabBar.frame.size.height), pageMenuOptions: parameters)
        
        pageMenu?.scrollMenuBackgroundColor = UIColor.whiteColor()
        pageMenu?.bottomMenuHairlineColor = UIColor.blueColor()
        pageMenu?.selectedMenuItemLabelColor = ThemeUtil.colorWithHexString(ThemeUtil.ACCENT_COLOR)
        pageMenu?.selectionIndicatorColor = ThemeUtil.colorWithHexString("#0000aa")
        pageMenu?.bottomMenuHairlineColor = UIColor.brownColor()
        pageMenu?.viewBackgroundColor = UIColor.greenColor()
        self.view.addSubview((pageMenu?.view)!)
    }
    
}
