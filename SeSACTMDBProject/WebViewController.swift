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
        print("===web", destinationURL)
        openWebPage(url: destinationURL)
        
    }
    
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
