//
//  ViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/16.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CHTCollectionViewWaterfallLayout
import MJRefresh
import CocoaLumberjack
import Kingfisher

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
class MainViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {
    
    let whiteSpace: CGFloat = 10.0
    var needAnim: Bool = true
    let articleModel = ArticleModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        self.title = "干货集中营"
        // 1、设置导航栏标题属性：设置标题颜色
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        // 2、设置导航栏前景色：设置item指示色
        self.navigationController?.navigationBar.barTintColor = ThemeUtil.colorWithHexString(ThemeUtil.DARK_PRIMARY_COLOR)
        
        self.articleCollectionView.dataSource = self
        self.articleCollectionView.delegate = self
        registerNibs()
        setupCollectionView()
        
    }
    
    override  func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        launchAnimation()
        
        //refresh
        self.articleCollectionView.mj_header.executeRefreshingCallback()
    }
    
    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    //MARK： setup uiview
    
    func setupCollectionView()  {
        let layout = CHTCollectionViewWaterfallLayout()
        
        layout.minimumColumnSpacing = whiteSpace
        layout.minimumInteritemSpacing = whiteSpace
        // 设置外边距
        layout.sectionInset = UIEdgeInsetsMake(whiteSpace, whiteSpace, whiteSpace, whiteSpace)
        
        self.articleCollectionView.alwaysBounceVertical = true
        self.articleCollectionView.collectionViewLayout = layout
        
        //刷新头部
        self.articleCollectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.articleModel.refresh()
                .observeOn(MainScheduler.instance)
                .doOnCompleted({
                    self.articleCollectionView.mj_header.endRefreshing()
                })
                .subscribe(onNext: { (entities) in
                    self.articleCollectionView.mj_footer.resetNoMoreData()
                    self.articleCollectionView.reloadData()
                    
                    }, onError: { (error) in
                        print(error)
                    }, onCompleted: {
                        DDLogDebug("on complated")
                    }, onDisposed: {
                        
                })
                .addDisposableTo(self.disposeBag)
            
        })
        
        //加载更多底部
        let mjFooter = MJRefreshAutoStateFooter.init(refreshingBlock: {
            self.articleModel.loadMore()
                .observeOn(MainScheduler.instance)
                .doOnCompleted({
                    self.articleCollectionView.mj_footer.endRefreshing()
                })
                .subscribe(onNext: { (entities) in
                    self.articleCollectionView.mj_footer.endRefreshingWithNoMoreData()
                    self.articleCollectionView.reloadData()
                    
                    }, onError: { (error) in
                        print(error)
                    }, onCompleted: {
                        DDLogDebug("on complated")
                    }, onDisposed: {
                        
                })
                .addDisposableTo(self.disposeBag)
        })
        
        self.articleCollectionView.mj_footer = mjFooter
        self.articleCollectionView.mj_footer.hidden = true
        
    }
    
    func registerNibs() {
        let viewNib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        self.articleCollectionView.registerNib(viewNib, forCellWithReuseIdentifier: "cell")
    }
    
    //MARK: delegate
    /*   */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.articleCollectionView.mj_footer.hidden = self.articleModel.articleEntities.count == 0
        return self.articleModel.articleEntities.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ArticleCollectionViewCell
        
        cell.title.text = self.articleModel.articleEntities[indexPath.item].desc!
        
        cell.image.kf_setImageWithURL(NSURL(string: self.articleModel.articleEntities[indexPath.item].url!)!,optionsInfo:[.Transition(ImageTransition.Fade(0.5))])
        
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let desc = self.articleModel.articleEntities[indexPath.item].desc!
        
        let width = (articleCollectionView.bounds.width - whiteSpace * 3) / 2
        let height = desc.heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(15))
        
        // height = img.height+ text.height + text.paddingTop
        return CGSize.init(width: width, height: width + height + 10.0)
    }
    
    // MARK: 启动过渡效果
    
    func launchAnimation()  {
        if needAnim {
            let toAnimVC = ControllerUtil.loadViewControllerWithName("LaunchScreen", sbName: "LaunchScreen")
            
            let launchView = toAnimVC.view
            let mainWindow = UIApplication .sharedApplication().keyWindow
            launchView.frame = (mainWindow?.frame)!
            mainWindow?.addSubview(launchView)
            
            UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                launchView.alpha = 0.0
                launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0, 2.0, 1.0)
            }) { (finished) in
                launchView.removeFromSuperview()
            }
        }
    }
    
    
    
    static func buildController() -> MainViewController{
        let controller = ControllerUtil.loadViewControllerWithName("MainView", sbName: "Main") as! MainViewController
        controller.needAnim = false
        return controller
    }
    
    
    
}

