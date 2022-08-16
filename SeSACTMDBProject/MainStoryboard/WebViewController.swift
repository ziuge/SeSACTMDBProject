//
//  WebViewController.swift
//  SeSACTMDBProject
//
//  Created by CHOI on 2022/08/08.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var destinationURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("===web", destinationURL)
        openWebPage(url: destinationURL)
        
    }
    
    public func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

}
