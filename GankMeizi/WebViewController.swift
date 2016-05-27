//
//  WebViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/24.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit
import NJKWebViewProgress
import RxSwift
class WebViewController: UIViewController ,NJKWebViewProgressDelegate,UIWebViewDelegate{
    
    @IBOutlet weak var webView: UIWebView!
    
    var webViewProgressView: NJKWebViewProgressView!
    var webViewProgress: NJKWebViewProgress!
    
    
    var article: ArticleEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = article?.desc
        
        self.webView.scalesPageToFit = true

        
        webViewProgress = NJKWebViewProgress()
        
        let navBounds = self.navigationController?.navigationBar.bounds
        let progressViewFrame = CGRectMake(0, (navBounds?.size.height)!-2, (navBounds?.size.width)!, 2)
        webViewProgressView = NJKWebViewProgressView(frame: progressViewFrame)
        webViewProgressView.progressBarView.backgroundColor = UIColor.blackColor()
        webViewProgress.progressDelegate = self
        webViewProgress.webViewProxyDelegate = self
        self.webView.delegate = webViewProgress
        
        self.webView.loadRequest(NSURLRequest(URL: NSURL(string: (article?.url)!)!))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.addSubview(webViewProgressView)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webViewProgressView.removeFromSuperview()
    }
    
    
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        print(progress)
        webViewProgressView.setProgress(progress, animated: true)
    }
    
    //MARK: - Public API
    
    static func buildControllerForArticle(article: ArticleEntity) -> WebViewController{
        let controller = ControllerUtil.loadViewControllerWithName("WebView", sbName: "Main") as! WebViewController
        controller.article = article
        return controller
    }
    
}
