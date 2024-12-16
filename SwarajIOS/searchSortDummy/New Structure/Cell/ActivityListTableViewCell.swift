//
//  ActivityListTableViewCell.swift
//  searchSortDummy
//
//  Created by Ajay Katara on 21/12/23.
//  Copyright © 2023 niket. All rights reserved.
//

import UIKit

class ActivityListTableViewCell: UITableViewCell {

    @IBOutlet weak var weekTitleLabl: UILabel!
    @IBOutlet weak var durationLabl: UILabel!
    @IBOutlet weak var numberOfTimesLabl: UILabel!
    
    static let identifier = "ActivityListTableViewCell"
    var setMMonthWiseActivity: MonthWiseData? {
        didSet {
            weekTitleLabl.text = setMMonthWiseActivity?.weekTitle ?? ""
            durationLabl.text = "(\(setMMonthWiseActivity?.duration ?? ""))"
            numberOfTimesLabl.text = "\(setMMonthWiseActivity?.time ?? "") Times"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
