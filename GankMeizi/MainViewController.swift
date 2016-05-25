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
import SDWebImage
import IDMPhotoBrowser
import SwiftyUserDefaults

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
class MainViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout {
    
    let whiteSpace: CGFloat = 8.0
    let articleModel = ArticleModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    override  func viewDidLoad() {
        Defaults[.launchCount] += 1
        super.viewDidLoad()
        self.title = "干货集中营"
        // 1、设置导航栏标题属性：设置标题颜色
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        // 2、设置导航栏前景色：设置item指示色
        self.navigationController?.navigationBar.barTintColor = ThemeUtil.colorWithHexString(ThemeUtil.DARK_PRIMARY_COLOR)

        // 3、设置导航栏前景色：设置item指示色
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        self.articleCollectionView.dataSource = self
        self.articleCollectionView.delegate = self
        
        registerNibs()
        
        setupCollectionView()
        
        //refresh
        self.articleCollectionView.mj_header.executeRefreshingCallback()
        
        launchAnimation()

    }
    
    override  func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
            if self.articleCollectionView.mj_footer.isRefreshing() {
                DDLogDebug("mj_footer isRefreshing")
                self.articleCollectionView.mj_header.endRefreshing()
                return
            }
            self.articleModel.refresh()
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
            if self.articleCollectionView.mj_header.isRefreshing() {
                DDLogDebug("mj_footer isRefreshing")
                self.articleCollectionView.mj_footer.endRefreshing()
                return
            }
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
    
    // 注册 collection view cell
    func registerNibs() {
        let viewNib = UINib(nibName: "ArticleCollectionViewCell", bundle: nil)
        self.articleCollectionView.registerNib(viewNib, forCellWithReuseIdentifier: "cell")
    }
    
    //MARK: delegate
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 数据为空 隐藏 footer
        self.articleCollectionView.mj_footer.hidden = self.articleModel.articleEntities.count == 0
        return self.articleModel.articleEntities.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ArticleCollectionViewCell
        
        cell.backgroundColor = UIColor.whiteColor()
        
        cell.title.text = self.articleModel.articleEntities[indexPath.item].desc!
        
        cell.image.clipsToBounds = true
        cell.image.sd_setImageWithURL(NSURL(string: self.articleModel.articleEntities[indexPath.item].url!)!, placeholderImage: nil, options: SDWebImageOptions.AvoidAutoSetImage, completed: { (image, error, cacheType, url) in
            if error == nil {
                cell.image.image = image
                if cacheType == SDImageCacheType.None {
                    cell.image.alpha = 0
                    UIView.animateWithDuration(0.5, animations: {
                        cell.image.alpha = 1
                    })
                }else{
                    cell.image.alpha = 1
                }
            }
        })
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(MainViewController.imageTapped(_:)))
        cell.image.tag = indexPath.item
        cell.image.userInteractionEnabled = true
        cell.image.addGestureRecognizer(tapGestureRecognizer)
        // 设置圆角
        cell.anchorView.layer.cornerRadius = 3;
        cell.anchorView.layer.masksToBounds = true
        
        //在self.layer上设置阴影
        cell.layer.cornerRadius = 3;
        cell.layer.shadowColor = UIColor.darkGrayColor().CGColor;
        cell.layer.masksToBounds = false;
        cell.layer.shadowOffset = CGSizeMake(1, 1.5);
        cell.layer.shadowRadius = 2;
        cell.layer.shadowOpacity = 0.75;
        cell.layer.shadowPath = UIBezierPath.init(roundedRect: cell.layer.bounds, cornerRadius: 3).CGPath
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let entity = self.articleModel.articleEntities[indexPath.item]
        
        let controller = DailyArticleViewController.buildController(entity.publishedAt!)
        self.navigationController?.pushViewController(controller, animated: true)
        DDLogDebug("\(indexPath.item)")
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let desc = self.articleModel.articleEntities[indexPath.item].desc!
        
        let width = (articleCollectionView.bounds.width - whiteSpace * 3) / 2
        let height = desc.heightWithConstrainedWidth(width, font: UIFont.systemFontOfSize(15))
        
        // height = img.height+ text.height + text.paddingTop
        return CGSize.init(width: width, height: width + height + 10.0)
    }
    
    // MARK: 启动画面过渡效果
    
    func launchAnimation()  {
        if !Defaults[.splashAnimated] {
            Defaults[.splashAnimated] = true
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
    
    //MARK: 对外接口
    
    static func buildController() -> MainViewController{
        let controller = ControllerUtil.loadViewControllerWithName("MainView", sbName: "Main") as! MainViewController
        // does not need anim
        Defaults[.splashAnimated] = true
        return controller
    }
    
    //MARK: 私有方法
    
    func imageTapped(sender:UITapGestureRecognizer)  {
        if ((sender.view?.isKindOfClass(UIImageView)) == true){
            let entity = articleModel.articleEntities[(sender.view?.tag)!]
            let photoBrowser = IDMPhotoBrowser.init(photoURLs: [NSURL(string: entity.url!)!], animatedFromView: sender.view)
            photoBrowser.usePopAnimation = true
            self.presentViewController(photoBrowser, animated: true, completion: nil)
            
        }
    }
    
    
    
}

