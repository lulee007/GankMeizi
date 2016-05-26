//
//  ArticleModel.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/23.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import Foundation
import RxSwift
import CocoaLumberjack
import ObjectMapper

class ArticleModel: BaseModel {
    
    var articleEntities: [ArticleEntity]
    
    override init() {
        articleEntities = []
        super.init()
    }
    
    
    /* 刷新 */
    func refresh() -> Observable<[ArticleEntity]> {
        page = 1
        return getArticleInfoByPage(page)
    }
    
    /* 分页获取更多 */
    func loadMore() -> Observable<[ArticleEntity]> {
        page += 1
        return getArticleInfoByPage(page)
    }
    
    //MARK: private method
    
    
    private func getArticleInfoByPage(page:Int) -> Observable<[ArticleEntity]> {
        return Observable
            .zip(
                provider
                    .request(GankIOService.ByPageAndKind(kind: "福利", page: page, count: self.offset))
                    .observeOn(backgroundWorkScheduler)
                    .map({ (response) -> [ArticleEntity] in
                        let result = Mapper<BaseEntity<ArticleEntity>>().map(String(data: response.data,encoding:  NSUTF8StringEncoding))
                        return (result?.results)!
                    }),
                provider.request(GankIOService.ByPageAndKind(kind: "休息视频", page: page, count: self.offset))
                    .observeOn(backgroundWorkScheduler)
                    .map({ (response) -> [ArticleEntity] in
                        let result = Mapper<BaseEntity<ArticleEntity>>().map(String(data: response.data,encoding:  NSUTF8StringEncoding))
                        return (result?.results)!
                    }),
                resultSelector: { (girls, videos) -> [ArticleEntity] in
                    for item in girls{
                        item.desc = item.desc! + " " + self.getFirstVideoDescByPublishTime(videos,publishedAt: item.publishedAt!)
                    }
                    return girls
                }
            )
            .doOnNext({ (entities) in
                if entities.isEmpty{
                    self.page -= 1
                }else{
                    if self.page == 1{
                        // new or refresh data
                        self.articleEntities = entities
                    }else{
                        self.articleEntities += entities
                    }
                    self.page += 1
                }
            })
            .observeOn(MainScheduler.instance)
    }
    
    func getFirstVideoDescByPublishTime(videos: [ArticleEntity],publishedAt:NSDate) -> String {
        var videoDesc = ""
        for item in videos {
            if item.publishedAt == nil {
                item.publishedAt = item.createdAt
            }
            let videoPublishedAt = item.publishedAt
            if DateUtil.areDatesSameDay(videoPublishedAt!, dateTwo: publishedAt){
                videoDesc = item.desc!
                break
            }
        }
        return videoDesc
    }
    
}