//
//  ErrorTipsHelper.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/28.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import Toast_Swift

//enum GankIOError {
//    
//    case ParseJSONError
//    case NetworkError
//}

class ErrorTipsHelper {
    
    static let  RequestNetworkErrorTip = "网络错误，请稍后重试"
    
    static  let sharedInstance = ErrorTipsHelper()
    
    func requestError(view: UIView, error: String = RequestNetworkErrorTip)  {
        
        view.makeToast(error, duration: 2, position: .Center)
        
    }
    
}
