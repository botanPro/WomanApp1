//
//  WebView.swift
//  WomanApp
//
//  Created by botan pro on 12/14/21.
//

import UIKit
import WebKit
class WebView: UIViewController {

    @IBOutlet weak var WebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Your webView code goes here
       let url = URL(string: "https://ecolifeiq.com")
       let requestObj = URLRequest(url: url! as URL)
        WebView.load(requestObj)
    }

    
}
