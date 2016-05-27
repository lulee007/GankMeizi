//
//  SearchModel.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/26.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import RxSwift
import CocoaLumberjack
import Kanna
import ObjectMapper

class SearchModel: BaseModel {
    
    static let sharedInstance = SearchModel()
    
    override init() {
        super.init()
    }
    
    func search(text: String) -> Observable<[(title:String,date: NSDate)]> {
        return provider.request(GankIOService.Search(text: text))
            .observeOn(backgroundWorkScheduler)
            .map { (response) -> [(title:String,date: NSDate)] in
            if let doc = Kanna.HTML(html: response.data, encoding: NSUTF8StringEncoding) {
                // Search for nodes by XPath
                var results: [(title:String,date: NSDate)] = []
                for link in doc.xpath("/html/body/div[1]/div[1]/ul/li[*]/div/a") {
                    print(link.text)
                    print(link["href"])
                    let dateComponents = link["href"]!.componentsSeparatedByString("/").filter{$0 != ""}
                    let date = DateUtil.stringToNSDate(dateComponents.joinWithSeparator("-") + "Z", formatter: "yyyy-MM-ddZ")
                    results.append((link.text!,date))
                }
                return results
            }
            return []
        }
    }
    
}
