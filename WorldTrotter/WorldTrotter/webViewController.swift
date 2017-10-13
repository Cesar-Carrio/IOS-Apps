//
//  webViewController.swift
//  WorldTrotter
//
//  Created by Cesar Carrillo on 9/2/17.
//  Copyright © 2017 Cesar Carrillo. All rights reserved.
//

import UIKit
import WebKit


// 6 bronze: Another Tab (open site)
class webViewController: UIViewController, WKUIDelegate{
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        //webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: "https://google.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}
