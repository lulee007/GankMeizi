//
//  ControllerUtil.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/19.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import UIKit

class ControllerUtil {
    


static func loadViewControllerWithName(vcName:String,sbName:String) -> UIViewController {
    let sb = UIStoryboard.init(name: sbName, bundle: nil)
    let vc = sb.instantiateViewControllerWithIdentifier(vcName) as UIViewController
    return vc
}

}