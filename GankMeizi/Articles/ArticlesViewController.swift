//
//  ArticlesViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/27.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MJRefresh

class ArticlesViewController: UITableViewController {

    var articleType: String?
    var model: ArticlesModel?
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = ArticlesModel(type: articleType!)
        setupTableView()
        self.tableView.mj_header.executeRefreshingCallback()

    }
    
    func setupTableView()  {
        
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: articleType!)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            if self.tableView.mj_footer.isRefreshing(){
                self.tableView.mj_header.endRefreshing()
                return
            }
            self.model?.refresh()
            .doOnCompleted({ 
                self.tableView.mj_header.endRefreshing()
            })
            .subscribeNext({ (results) in
                if results.count > 0 {
                    self.tableView.mj_footer.hidden = false
                    self.tableView.mj_footer.resetNoMoreData()
                }
                self.tableView.reloadData()
            })
            .addDisposableTo(self.disposeBag)
        })
        
        tableView.mj_footer = MJRefreshAutoStateFooter(refreshingBlock: { 
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_footer.endRefreshing()
                return
            }
            self.model?.loadMore()
                .doOnCompleted({
                    self.tableView.mj_footer.endRefreshing()
                })
            .subscribeNext({ (results) in
                if results.count == 0{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }else{
                    self.tableView.reloadData()
                    self.tableView.mj_footer.endRefreshing()
                }
            })
            .addDisposableTo(self.disposeBag)
        })
        tableView.mj_footer.hidden = true
    }
    
    //MARK: tableview datasource and delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.items?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.articleType!, forIndexPath: indexPath) as! SearchResultTableViewCell
        let item = model?.items![indexPath.item]
        
        cell.title.text = item?.desc!
        cell.date.text = DateUtil.nsDateToString((item?.publishedAt!)!, formatter: "yyyy-MM-dd")
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = model?.items![indexPath.item]
        let controller = WebViewController.buildControllerForArticle(item!)
        AppDelegate.getNavigationController().pushViewController(controller, animated: true)
    }
    
    // MARK: - public API
    static func buildController(type: String) -> ArticlesViewController{
        let controller = ControllerUtil.loadViewControllerWithName("Articles", sbName: "Main") as! ArticlesViewController
        controller.title = type
        controller.articleType = type
        return controller
    }
}
