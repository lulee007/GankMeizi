//
//  SearchResultsTableViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/26.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import Toast_Swift

class SearchGanksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // search history
    @IBOutlet weak var resultsTableView: UITableView!
    
    @IBOutlet weak var searchBarContainer: UIView!
    
    var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    
    var results: [(title: String, date: NSDate)]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "干货搜索"
        
        configTableDataSource()
        
        configKeyboardDismissOnScroll()
        
    }
    
    func configTableDataSource()  {
        
        
        let nib = UINib(nibName: "SearchResultTableViewCell", bundle: nil)
        resultsTableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        resultsTableView.delegate = self
        resultsTableView.dataSource = self
        
        
        self.searchBar = UISearchBar()
        self.searchBarContainer.addSubview(self.searchBar)
        self.searchBar.frame = self.searchBarContainer.bounds
        self.searchBar.autoresizingMask = .FlexibleWidth
        
        searchBar.rx_text
            .asDriver()
            .throttle(0.3)
            .filter({ $0 != "" })
            .distinctUntilChanged()
            .flatMapLatest{
                SearchModel.sharedInstance.search($0)
                    .asDriver(onErrorJustReturn: [])
            }
            .driveNext  { (results) in
                self.results = results
                if self.results?.count == 0{
                    self.view.makeToast("没有找到，换个关键词试试吧！", duration: 2, position: .Center)
                }
                self.resultsTableView.reloadData()
                
            }
            .addDisposableTo(disposeBag)
    }
    
    func configKeyboardDismissOnScroll()  {
        self.resultsTableView.rx_contentOffset
            .asDriver()
            .driveNext({_ in
                if self.searchBar.isFirstResponder() && self.results?.count > 0{
                    _ = self.searchBar.resignFirstResponder()
                }
            })
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //自动显示搜索
        Observable.just("")
            .delaySubscription(0.1, scheduler: MainScheduler.instance)
            .subscribeNext({ _ in
                let result = self.searchBar.becomeFirstResponder()
                print(result)
            })
            .addDisposableTo(disposeBag)
    }
    
    // MARK: - Table view data source and deltegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.results != nil) ? self.results!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! SearchResultTableViewCell
        let entity = self.results![indexPath.item]
        cell.title.text = entity.title
        cell.date.text = DateUtil.nsDateToString(entity.date, formatter: "yyyy-MM-dd")
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let entity = self.results![indexPath.item]
        let controller = DailyArticleViewController.buildController(entity.date)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
