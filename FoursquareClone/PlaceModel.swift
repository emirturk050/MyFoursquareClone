//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Emir Türk on 17.03.2023.
//

import Foundation
import UIKit
class PlaceModel {
    
    static let sharedInstance = PlaceModel()
    var placeName = ""
    var placeType = ""
    var placeComment = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init(){}
     
}
