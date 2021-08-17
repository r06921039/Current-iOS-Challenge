//
//  Place.swift
//  Fast Foodz
//
//  Created by Jeff on 2021/8/6.
//

import Foundation
import SwiftyJSON

class Place{
    var category: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var distance: Double = 0.0
    var image_url: String = ""
    var name: String = ""
    var phone: String = ""
    var price: String = ""
    var page_url: String = ""
    
    init(business: JSON, category: String?){
        if let category = category{
            self.category = category
        }
        if let latitude = business["coordinates"]["latitude"].double{
            self.latitude = latitude
        }
        if let longitude = business["coordinates"]["longitude"].double{
            self.longitude = longitude
        }
        if let distance = business["distance"].double{
            self.distance = (distance * 0.000621).ceiling(toDecimal: 2)
        }
        if let image_url = business["image_url"].string{
            self.image_url = image_url
        }
        if let name = business["name"].string{
            self.name = name
        }
        if let phone = business["phone"].string{
            self.phone = phone
        }
        if let price = business["price"].string{
            self.price = price
        }
        if let url = business["url"].string{
            self.page_url = url
        }

    }
}

//
// Handle round
//
extension Double {
    func ceiling(toDecimal decimal: Int) -> Double {
        let numberOfDigits = abs(pow(10.0, Double(decimal)))
        if self.sign == .minus {
            return Double(Int(self * numberOfDigits)) / numberOfDigits
        } else {
            return Double(ceil(self * numberOfDigits)) / numberOfDigits
        }
    }
}
