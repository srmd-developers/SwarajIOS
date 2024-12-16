//
//  MonthAttributeCollectionViewCell.swift
//  searchSortDummy
//
//  Created by Ajay Katara on 21/12/23.
//  Copyright © 2023 niket. All rights reserved.
//

import UIKit

class MonthAttributeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var monthAttrbBtn: UIButton!
    
    static let identifier = "MonthAttributeCollectionViewCell"
    var setAtrributs: MonthsAttributes? {
        didSet {
            let finalTitle = String((setAtrributs?.monthTitle ?? "").prefix(3)).capitalized
            monthAttrbBtn.setTitle(finalTitle, for: .normal)
            monthAttrbBtn.backgroundColor = setAtrributs?.isSelected ?? false ? #colorLiteral(red: 0.4509803922, green: 0.06666666667, blue: 0.0431372549, alpha: 1) : #colorLiteral(red: 0.9607843137, green: 0.9490196078, blue: 0.9058823529, alpha: 1)
            monthAttrbBtn.setTitleColor(setAtrributs?.isSelected ?? false ? UIColor.white : UIColor.darkGray, for: .normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
