//
//  Country.swift
//  CountryCustom
//
//  Created by user on 06/02/2022.
//

import Foundation

class Country {
    var flag : String?
    var alphacode : String?
    var name : String?
    var nativeName: String?
    var capital:String?
    var area:Double?
    var population:Int?
    var currencies:String?
    var region:String?
    var timezones:[String]?
    var languages:[String]?
    var latlng:[Double]?
    
    init() {
    }
}

class Currency {
    var code:String?
    var name:String?
    var symbol:String?
    init () {
        
    }
}

class Language {
    
    var iso639_1:String?
    var iso639_2:String?
    var name:String?
    var nativeName:String?
    init () {
        
    }
}



