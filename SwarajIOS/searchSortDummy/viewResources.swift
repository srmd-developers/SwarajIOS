//
//  viewResources.swift
//  searchSortDummy
//
//  Created by Parth Thosani on 14/10/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit
import WebKit
class viewResources: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var viewNavBar: UIView!
    var webView = WKWebView(frame: .zero)
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.loadContentOnWKWebViewFromUrl()
    }
    
    
    //MARK: -
    //MARK: - Load Content On WKWebView
    
    func loadContentOnWKWebViewFromUrl() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        // You can set constant space for Left, Right, Top and Bottom Anchors
        NSLayoutConstraint.activate([
            self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.webView.topAnchor.constraint(equalTo: viewNavBar.bottomAnchor)])
        
        self.view.setNeedsLayout()
        let request = URLRequest(url: URL(string: "https://www.youtube.com/channel/UCRFZ-belq2nXuMHoWZGRu1Q")!)
        self.webView.load(request)
    }
    
    //MARK: -
    //MARK: - IBActions
      
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
