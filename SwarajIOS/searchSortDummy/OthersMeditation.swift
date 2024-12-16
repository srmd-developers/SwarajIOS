//
//  OthersMeditation.swift
//  searchSortDummy
//
//  Created by monika on 21/11/18.
//  Copyright © 2018 niket. All rights reserved.
//

import UIKit
private let sharedinstance = OthersMeditation()

class OthersMeditation: NSObject {
    /*
     "large" : "special\/Mangal-Maitri-Track-Artwork-192.png",
     "Name" : "Mangal Maitri",
     "length" : "15",
     "Path" : "special\/MangalMaitri.mp3",
     "desc" : "Derived from the prayers of revered Master Shri S. N. Goenka Ji (Vippassana), these verses invoke the strongest of feelings of Maitri (Inclusiveness or friendship) towards the entire existence.  Often, these verses are recited by SRI BEN PRABHU after every major Meditation session at SRM. Here, this audio track is prepared for every seeker to benefit from and enhance their inner feeling of Maitri."
     
     */
    var large:String?
    var Name:String?
    var length:String?
    var Path:String?
    var desc:String?
    var isAudioPlay:Bool?//1=>play,0=>pause
    var isDowloaded:Bool?//1=>downloaded,0=>not
    var isDowloading:Bool?
    
    
    
    class var sharedInstance: OthersMeditation {
        return sharedinstance
    }
    
}
