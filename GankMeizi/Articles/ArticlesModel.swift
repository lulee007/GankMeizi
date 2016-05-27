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
    }
    
    func loadMore() -> Observable<[ArticleEntity]> {
        return getArticles(page + 1)
        .doOnNext({ (results) in
            self.page += 1
            self.items! += results
        })
    }
    
    func getArticles(page: Int = 1) -> Observable<[ArticleEntity]> {
        return   self.provider.request(GankIOService.ByPageAndKind(kind: self.articleType!, page: page, count: self.offset))
            .map { (response) -> [ArticleEntity] in
                let result = Mapper<BaseEntity<ArticleEntity>>().map(String(data: response.data,encoding: NSUTF8StringEncoding))
                return (result?.results)!
        }
    }
    
}