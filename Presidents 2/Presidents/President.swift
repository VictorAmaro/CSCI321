//
//  President.swift
//  Presidents
//
//  Created by Victor on 11/6/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import Foundation

class President {
    
    //Properties
    var name = ""
    var number = 0
    var startDate = ""
    var endDate = ""
    var nickName = ""
    var politicalParty = ""
    var url = ""
    
    //Initializers
    init(name: String, number: Int, startDate: String, endDate: String, nickName: String, politicalParty: String, url: String) {
        self.name = name
        self.number = number
        self.startDate = startDate
        self.endDate = endDate
        self.nickName = nickName
        self.politicalParty = politicalParty
        self.url = url
    }
    
}
