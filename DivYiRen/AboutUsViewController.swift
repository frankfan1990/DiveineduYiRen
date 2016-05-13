//
//  AboutUsViewController.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/27.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    private let webViwe = UIWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        webViwe.delegate = self
        view.addSubview(webViwe)
        
        webViwe.snp_makeConstraints { (make) in
            
            make.edges.equalTo(self.view)
        }
        
        let url = NSURL(string: "http://www.diveinedu.com")!
        webViwe.loadRequest(NSURLRequest(URL: url))
    }
}

extension AboutUsViewController:UIWebViewDelegate{
    
    
}

