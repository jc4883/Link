//
//  Link.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 8/2/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import GoogleMaps

struct Link {
    
    let activity : String
    let linkCreator : String
    let time : String
    let invitees : String
    var latitude : CLLocationDegrees
    var longitude : CLLocationDegrees
    
    init(dictionary : [String : Any]){
        self.activity = dictionary["activity"] as? String ?? ""
        self.linkCreator = dictionary["linkCreator"] as? String ?? ""
        self.time = dictionary["time"] as? String ?? ""
        self.invitees = dictionary["invitees"] as? String ?? ""
        guard let latitude = dictionary["latitude"] as? CLLocationDegrees else {
            self.latitude = 0.0
            self.longitude = 0.0
            return
        }
        self.latitude = latitude
        guard let longitude = dictionary["longitude"] as? CLLocationDegrees else {
            self.latitude = 0.0
            self.longitude = 0.0
            return
        }
        self.longitude = longitude
    }
}
