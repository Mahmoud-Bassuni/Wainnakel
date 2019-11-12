//
//  ds.swift
//  Wainnakel
//
//  Created by Bassuni on 11/11/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//
import Foundation
struct RestaurantCodableModel: Codable {
    let error, name, id ,link: String!
    let cat, catID, rating, lat , lon: String!
    let ulat, ulon, resturanrtCodableModelOpen: String!
    let image: [String]!
    enum CodingKeys: String, CodingKey {
        case error, name, id, link, cat
        case catID = "catId"
        case rating, lat, lon
        case ulat = "Ulat"
        case ulon = "Ulon"
        case resturanrtCodableModelOpen = "open"
        case image
    }
}
