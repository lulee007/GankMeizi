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
    
    var searchText: String
    var items: [ArticleEntity]
    
    
    override init() {
        self.searchText = ""
        items = []
        super.init()
    }
    
    func search(text: String?,category: String = "all",count: Int = 20,page: Int = 1) -> Observable<[ArticleEntity]> {
        self.offset = count
        if page != 1{
            self.page = page
        }
        if text != nil {
            self.searchText = text!
            items.removeAll()
            self.page = 1
        }
        
        return provider.request(GankIOService.Search(text: self.searchText,category: category,count: self.offset,page: self.page))
            .observeOn(backgroundWorkScheduler)
            .filterStatusCodes(200...201)
            .observeOn(backgroundWorkScheduler)
            .map { (response) -> [ArticleEntity] in
                let jsonStr = String(data: response.data,encoding: NSUTF8StringEncoding)
                let result = Mapper<BaseEntity<ArticleEntity>>().map(jsonStr!)
                if ((result?.results) != nil){
                    self.page = self.page + 1
                    self.items += (result?.results!)!
                }
                return self.items
                
        }
        
    }
    
    
    func reset()  {
        self.page = 1
        self.items.removeAll()
    }
}
