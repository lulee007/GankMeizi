//
//  ArticlesModel.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/27.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper
class ArticlesModel: BaseModel {
    
    enum GankError: ErrorType{
        case ParseObjError
    }
    
    var items: [ArticleEntity]?
    var articleType: String?
    
    init(type: String){
        super.init()
        self.articleType = type
        items = []
        page = 30
    }
    
    
    func refresh() -> Observable<[ArticleEntity]> {
        return getArticles()
            .doOnNext { (results) in
                self.page = 1
                self.items = results
            }
            .observeOn(MainScheduler.instance)
    }
    
    func loadMore() -> Observable<[ArticleEntity]> {
        return getArticles(page + 1)
            .doOnNext({ (results) in
                if !results.isEmpty{
                    self.page += 1
                    self.items! += results
                }
            })
            .observeOn(MainScheduler.instance)
    }
    
    func getArticles(page: Int = 1) -> Observable<[ArticleEntity]> {
        return   self.provider
            .request(GankIOService.ByPageAndKind(kind: self.articleType!, page: page, count: self.offset))
            .filterStatusCodes(200...209)
            .mapString()
            
            .map { (response) -> [ArticleEntity] in
                
                if let result = Mapper<BaseEntity<ArticleEntity>>().map(response){
                    return result.results!
                }else{
                    throw NSError(domain: "parse json error", code: -1, userInfo: ["json":response])
                }
        }
        
    }
    
}