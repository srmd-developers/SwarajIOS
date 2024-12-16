//
//  yearlyReviewVC.swift
//  searchSortDummy
//
//  Created by Deepak Anil Shakyavanshi on 04/07/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit

class yearlyReviewVC: UIViewController, webServicesDelegate, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var yearTable: UITableView!

    var webReq : webServices!
    var arrYearlyData = [String]()
    var lblErrorMsg = UILabel()
    
    //MARK: -
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.doInitialSetUp()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    //MARK: -
    //MARK: - General Methods
    func doInitialSetUp() {
        //Initialize webservice
        webReq = webServices()
        webReq.delegate = self
        
        //Initialize TableView Delegate and DataSource
        yearTable.dataSource = self
        yearTable.delegate = self
        
        //Initialize no data error message
        lblErrorMsg.numberOfLines = 2
        lblErrorMsg.frame = yearTable.frame
        lblErrorMsg.text = "Loading..."
        lblErrorMsg.textAlignment = .center
        yearTable.backgroundView = lblErrorMsg
        
        //Call get yearly data API
        let req = "\(cfg.url)yearly.php"
        let postparam = "uniqueId=\(cfg.uid)"
        
        webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "getdata")
        
    }
    
    
    //MARK: -
    //MARK: - IBActions
    @IBAction func btnDismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: -
    //MARK: - TableView Delegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrYearlyData.count - 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "yearCell"
        let cell : yearlyTVC = yearTable.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! yearlyTVC
        
        cell.populate(data: arrYearlyData[indexPath.row])
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        return cell
    }
    
    //MARK: -
    //MARK: - API Calls
    //MARK: - Webservice Delegate Methods
    func responseData(data: NSData, reqId: String) {
        let responseData = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        print("Response yearly data===\(responseData ?? "")")
        if reqId == "getdata"
        {
            lblErrorMsg.text = ""
            arrYearlyData = (responseData?.components(separatedBy: "," ))!
            debugPrint(arrYearlyData)
            
            yearTable.reloadData()
        }
    }
    
    func errorResponse(err: String, reqId: String) {
        print("Response yearly err===\(err)")
        lblErrorMsg.text = err
    }
    
    
}
