//
//  ImageVC.swift
//  searchSortDummy
//
//  Created by Infonium on 04/05/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var webImg : AnyObject!
    var webRes = [AnyObject]()
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dataWebImg = webImg["result"] as? [AnyObject] else {
            return
        }
        webRes = dataWebImg
        for item in webRes {
            if let path = item["Path"] as? String{
                print("\(cfg.baseUrl)\(path)")
                scrollView.auk.show(url: "\(cfg.baseUrl)\(path)")
            }
        }
        scrollView.auk.startAutoScroll(delaySeconds: 4, forward: true, cycle: true, animated: true)
        scrollView.auk.createPageIndicator()
        
    }

    //MARK: -
    //MARK: - IBActions
    @IBAction func btnMedidateAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
