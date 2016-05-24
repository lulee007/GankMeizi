//
//  DailyArticleViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/24.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DailyArticleViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: -Date Model
    var dailyArticleModel = DailyArticleModel()
    var date: NSDate?
    var dataSource = DailyArticleDataSource()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = DateUtil.nsDateToString(date!,formatter: "yyyy/MM/dd")
        
        let nib = UINib(nibName: "DailyArticleTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = nil
        dailyArticleModel
            .getArticleByDate(date!)
            .map({ (entity) -> [DailyArticleEntity] in
                return [entity]
            })
            .bindTo(tableView.rx_itemsWithDataSource(dataSource))
            .addDisposableTo(disposeBag)
        
        
    }
    
    //MARK: - UITableView DataSource
    
    
    
    //MARK: public API
    /*
     * 传入指定日期
     */
    static func buildController(date: NSDate) -> DailyArticleViewController{
        let controller = ControllerUtil.loadViewControllerWithName("DailyArticle", sbName: "Main") as! DailyArticleViewController
        controller.date = date
        return controller
        
    }
    
    
}
class DailyArticleDataSource: NSObject, RxTableViewDataSourceType, UITableViewDataSource {
    
    typealias Element = [DailyArticleEntity]
    var items: DailyArticleEntity?
    
    func tableView(tableView: UITableView, observedEvent: Event<Element>) {
        switch observedEvent {
        case .Next(let value):
            self.items = value.first
            tableView.reloadData()
        case .Error(let error):
            print(error)
        case .Completed:
            print("complete")
            
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items?.category?.count ?? 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionIndex = items?.category![section]
        return items?.results![sectionIndex!]!.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sectionIndex = items?.category![indexPath.section]
        let entity = items?.results![sectionIndex!]![indexPath.item]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DailyArticleTableViewCell
        cell.title.text = entity?.desc
        return cell
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionIndex = items?.category![section]
        return sectionIndex
    }
    
}
