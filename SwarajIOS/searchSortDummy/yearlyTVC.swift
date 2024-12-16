//
//  yearlyTVC.swift
//  searchSortDummy
//
//  Created by Deepak Anil Shakyavanshi on 04/07/17.
//  Copyright © 2017 niket. All rights reserved.
//

import UIKit

class yearlyTVC: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblSwaraj: UILabel!
    @IBOutlet weak var lblSwaraj2: UILabel!
    @IBOutlet weak var lblEnergization: UILabel!
    @IBOutlet weak var lblInterruptions: UILabel!
    
    @IBOutlet weak var vewContainer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: -
    //MARK: - Load Data on Table Cell

    func populate(data: String)
    {
        vewContainer.layer.cornerRadius = 2
        vewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        vewContainer.layer.shadowOffset = CGSize(width: 0.0,height: 2.0)
        vewContainer.layer.shadowOpacity = 0.7
        vewContainer.layer.shadowRadius = 1.7
        vewContainer.layer.masksToBounds = false
        
        let data2 = data.components(separatedBy: ":")
        print(data2)
        if data2.count>0{
            lblMonth.text = data2[0].uppercaseFirst
            
            let level = data2[1].components(separatedBy: "_")
            if level.count > 0 {
                lblSwaraj.text = ("\(level[0]) times")
                lblSwaraj2.text = ("\(level[1]) times")
                lblEnergization.text = ("\(level[2]) times")
                lblInterruptions.text = ("\(level[3]) times")
            }
           
        }
       
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
//MARK: -
//MARK: - String Related Methods

extension String {
    var first: String {
        return String(prefix(1))
    }
    var last: String {
        return String(suffix(1))
    }
    var uppercaseFirst: String {
        return first.uppercased() + String(dropFirst())
    }
}
