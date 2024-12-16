//
//  YearWiseTrackingVC.swift
//  searchSortDummy
//
//  Created by Ajay Katara on 21/12/23.
//  Copyright © 2023 niket. All rights reserved.
//

import UIKit
struct MonthsAttributes {
    let monthTitle: String
    var isSelected: Bool
}
class YearWiseTrackingVC: UIViewController {
    
    @IBOutlet weak var yearItmCollectionVw: UICollectionView!
    @IBOutlet weak var monthItmTablVw: UITableView!
    @IBOutlet weak var monthTitleLabl: UILabel!
    
    var webReq : webServices!
    var monthsAttrbArr = [MonthsAttributes]()
    var monthWiseObjArr = [MonthWiseData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapOnBackBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

//MARK: - Functions
extension YearWiseTrackingVC {
    func initialSetup(){
        webReq = webServices()
        webReq.delegate = self
        
        monthItmTablVw.register(UINib(nibName: ActivityListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ActivityListTableViewCell.identifier)
        let margin: CGFloat = 5
        guard let collectionView = yearItmCollectionVw, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

            flowLayout.minimumInteritemSpacing = margin
            flowLayout.minimumLineSpacing = margin
            flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        getYearWiseData()
    }
    //MARK: GET YEAR WISE DATA
    func getYearWiseData() {
        let req = "\(cfg.url)yearly.php"
        let postparam = "uniqueId=\(cfg.uid)"
        
        webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "getdata")
    }
    //MARK: GET MONTH WISE DATA
    func getMonthWiseDataApi(monthName: String) {
        monthTitleLabl.text = monthName.capitalized
        let date = Date()
        let yearString = date.yearNum()
        
        let req = "\(cfg.url)fixed_final_monthly.php"
        let postparam = "uniqueId=\(cfg.uid)&month=\(monthName)&year=\(yearString)"
        
        webReq.postRequest(reqStr: req, postParams: postparam.data(using: String.Encoding.utf8)! as AnyObject, reqId: "getMonthWise")
    }
}

//MARK: -WebService delegate
extension YearWiseTrackingVC: webServicesDelegate {
    func responseData(data: NSData, reqId: String) {
        let responseData = String(data: data as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
        if responseData != "" {
            if reqId != "getMonthWise" {
                let commaSplitStrArr = responseData.components(separatedBy: ",")
                for (index, itm) in commaSplitStrArr.enumerated() {
                    let colonSplitStrArr = itm.components(separatedBy: ":")
                    if colonSplitStrArr.count > 0 {
                        if colonSplitStrArr[0] != "" {
                            monthsAttrbArr.append(MonthsAttributes(monthTitle: colonSplitStrArr[0], isSelected: index == 0 ? true : false))
                        }
                    }
                }
                yearItmCollectionVw.reloadData()
                if monthsAttrbArr.count > 0 {
                    getMonthWiseDataApi(monthName: monthsAttrbArr[0].monthTitle)
                }
            } else {
                let colonSplitStrArr = responseData.components(separatedBy: ":")
                if colonSplitStrArr.count > 1 {
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
                        if week_Title != "" {
                            monthWiseObjArr.append(MonthWiseData(weekTitle: week_Title, duration: duration, time: time))
                            monthItmTablVw.reloadData()
                        }
                    }
                }
            }
        }
        print(responseData)
    }
    
    func errorResponse(err: String, reqId: String) {
        print("Response yearly err===\(err)")
    }
    
}

//MARK: - UICollectionView Datasource and Delegate
extension YearWiseTrackingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthsAttrbArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let monthAttrbVw = yearItmCollectionVw.dequeueReusableCell(withReuseIdentifier: MonthAttributeCollectionViewCell.identifier, for: indexPath) as! MonthAttributeCollectionViewCell
        monthAttrbVw.setAtrributs = monthsAttrbArr[indexPath.item]
        return monthAttrbVw
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 4   //number of column you want
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
                + flowLayout.sectionInset.right
                + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

            let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
            return CGSize(width: size, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMonth = monthsAttrbArr[indexPath.item].monthTitle
        for (index, _) in monthsAttrbArr.enumerated() {
            if indexPath.item == index {
                monthsAttrbArr[indexPath.item].isSelected = true
            } else {
                monthsAttrbArr[index].isSelected = false
            }
        }
        yearItmCollectionVw.reloadData()
        monthWiseObjArr = []
        getMonthWiseDataApi(monthName: selectedMonth)
    }
}

//MARK: - UITableView Delegate and Datasource
extension YearWiseTrackingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monthWiseObjArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let monthTrackingVw = monthItmTablVw.dequeueReusableCell(withIdentifier: ActivityListTableViewCell.identifier, for: indexPath) as! ActivityListTableViewCell
        monthTrackingVw.setMMonthWiseActivity = monthWiseObjArr[indexPath.row]
        return monthTrackingVw
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
