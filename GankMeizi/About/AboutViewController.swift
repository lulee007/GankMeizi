//
//  AboutViewController.swift
//  GankMeizi
//
//  Created by 卢小辉 on 16/5/25.
//  Copyright © 2016年 lulee007. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var introduce: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataPath = NSBundle.mainBundle().pathForResource("AboutData", ofType: "txt")
        
        do{
            let aboutData = try String.init(contentsOfFile: dataPath!, encoding: NSUTF8StringEncoding)
            let attrStr = try NSAttributedString.init(data: aboutData.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
            
//            let aboutHtml = NSAttributedString.init(string: aboutData, attributes: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType])
            introduce.attributedText = attrStr
        }catch {
            print(error)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.parentViewController?.title = "关于"
    }
    
}
