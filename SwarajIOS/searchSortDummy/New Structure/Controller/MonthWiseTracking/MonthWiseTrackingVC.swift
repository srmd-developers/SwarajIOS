//
//  MonthWiseTrackingVC.swift
//  searchSortDummy
//
//  Created by Ajay Katara on 21/12/23.
//  Copyright © 2023 niket. All rights reserved.
//

import UIKit

struct MonthWiseData {
    let weekTitle: String
    let duration: String
    let time: String
}
class MonthWiseTrackingVC: UIViewController {

    @IBOutlet weak var monthTitleLabl: UILabel!
    @IBOutlet weak var tablVw: UITableView!
    
    var webReq : webServices!
    var monthWiseObjArr = [MonthWiseData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapOnBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Functions
extension MonthWiseTrackingVC {
    func initialSetup(){
        tablVw.register(UINib(nibName: ActivityListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ActivityListTableViewCell.identifier)
        webReq = webServices()
        webReq.delegate = self
        getMonthWiseDataApi()
    }
    func getMonthWiseDataApi() {
        let date = Date()
        let monthString = date.monthName()
        let yearString = date.yearNum()
        
        let req = "\(cfg.url)fixed_final_monthly.php"
        let postparam = "uniqueId=\(cfg.uid)&month=\(monthString)&year=\(yearString)"
        
        webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "getMonthWise")
    }
}

//MARK: - WebService Delegate
extension MonthWiseTrackingVC: webServicesDelegate {
    func responseData(data: NSData, reqId: String) {
        let responseData = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
        if responseData != "" {
            let colonSplitStrArr = responseData.components(separatedBy: ":")
            if colonSplitStrArr.count > 1 {
                monthTitleLabl.text = Date().monthName()
                let dataStr = colonSplitStrArr[1]
                let underScoreSplitArr = dataStr.components(separatedBy: "_")
                for itm in underScoreSplitArr {
                    let atSymbolSplitArr = itm.components(separatedBy: "@")
                    var week_Title = ""
                    var duration = ""
                    var time = ""
                    if atSymbolSplitArr.count > 0 {
                        week_Title = atSymbolSplitArr[0]
                    }
                    if atSymbolSplitArr.count > 1 {
                        duration = atSymbolSplitArr[1]
                    }
                    if atSymbolSplitArr.count > 2 {
                        time = atSymbolSplitArr[2]
                    }
                    monthWiseObjArr.append(MonthWiseData(weekTitle: week_Title, duration: duration, time: time))
                    tablVw.reloadData()
                }
            }
        }

        print(responseData)
//        let dataModl = try JSONDecoder().decode(structMDL.self, from: data as Data)
    }
    func errorResponse(err: String, reqId: String) {
        print("Response \(reqId) err===\(err)")
    }
}

//MARK: - UITableView Delegate and Datasource
extension MonthWiseTrackingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthWiseObjArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let monthTrackingVw = self.tablVw.dequeueReusableCell(withIdentifier: ActivityListTableViewCell.identifier, for: indexPath) as! ActivityListTableViewCell
        monthTrackingVw.setMMonthWiseActivity = monthWiseObjArr[indexPath.row]
        return monthTrackingVw
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

