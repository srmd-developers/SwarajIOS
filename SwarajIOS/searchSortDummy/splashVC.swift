//
//  splashVC.swift
//  searchSortDummy
//
//  Created by Prathamesh on 7/4/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging

class splashVC: UIViewController {
    
    //MARK: -
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Messaging.messaging().subscribe(toTopic: "swarajNoti")
        
        var isUserLoggedIn = ""
        let defaults = UserDefaults.standard
        if let loginStatus = defaults.object(forKey: cfg.is_user_logged) as? String {
            isUserLoggedIn = loginStatus
        }
        if isUserLoggedIn == "YES"{
            self.moveToDashboard()
        }else{
            self.performSegue(withIdentifier: "toLogin", sender: self)
            
        }
        
    }
    //MARK: -
    //MARK: - Navigate To View Controllers Methods
    func moveToDashboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "dashboard") as! dashboardVC
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
}
