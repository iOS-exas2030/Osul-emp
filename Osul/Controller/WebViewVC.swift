//
//  WebViewVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/18/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import WebKit


class WebViewVC: UIViewController , WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    var urlRequest : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        print(urlRequest)
        let url = URL(string: urlRequest!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    

  

}
