//
//  RestaurantEnum.swift
//  Wainnakel
//
//  Created by Bassuni on 11/11/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import Foundation
import Moya
enum RestaurantEnum{
    case getRestaurantDetails(lat : Double , lon : Double)
}
extension RestaurantEnum: TargetType{
    var baseURL: URL {
        switch self{
        case .getRestaurantDetails:
            return URL(string: EndPoint.baseUrl.rawValue)!
        }
    }
    var path: String {
        switch self{
        case .getRestaurantDetails: return EndPoint.getRestaurantDetailsURL.rawValue
        }
    }
    var method: Moya.Method {
        switch self {
        case .getRestaurantDetails:  return .get
        }
    }
    var sampleData: Data {
        return Data()
    }
    var task: Task {
        switch self {
        case let .getRestaurantDetails(lat , lon):
           return .requestParameters(parameters: ["uid": "\(lat),\(lon)"], encoding: URLEncoding.queryString)
        }
    }
    var headers: [String : String]?{
        switch self {
        case .getRestaurantDetails:
            return ["Content-Type" : "application/json"]
        }
    }
}

