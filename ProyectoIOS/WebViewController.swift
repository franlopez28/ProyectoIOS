//
//  WebViewController.swift
//  ProyectoIOS
//
//  Created by Francisco López Gómez on 30/5/18.
//  Copyright © 2018 Francisco López Gómez. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController ,WKUIDelegate,    WKNavigationDelegate {
    
    @IBOutlet var webview: WKWebView!
    @IBOutlet weak var volver: UIButton!
    var action = ""
    let config = Config()
    var pk = ""
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webview = WKWebView(frame: .zero, configuration: webConfiguration)
        webview.uiDelegate = self
        view = webview
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parametros = "action=\(action)&pk=\(pk)"
        print(parametros)
        let url = URL(string: "http://\(config.ip)/proyecto/assets/apis/fmapi/Services/pdf1.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = parametros.data(using: .utf8)
        
        //webview.load(request)
        UIApplication.shared.open(URL(string : "http://\(config.ip)/proyecto/assets/apis/fmapi/Services/pdf1.php?\(parametros)")!, options: [:], completionHandler: { (status) in
        })
       
       
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

