//
//  RestaurantDetailsVM.swift
//  Wainnakel
//
//  Created by Bassuni on 11/11/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import Foundation
class RestaurantDetailsVM
{
    var restaurantData : RestaurantCodableModel!
    public var delegate : RestaurantDelegate!
    private var serviceAdapter : NetworkAdapter<RestaurantEnum>!
    init(_serviceAdapter : NetworkAdapter<RestaurantEnum>) {
        serviceAdapter = _serviceAdapter
    }
    func fetchRestaurantDetails()
    {
        let currentLocation = getCurrentLocation()
        guard currentLocation != nil else {
            self.delegate?.showAlert(message: "GPS not avalible")
            return
        }
        delegate?.showLoading()
        serviceAdapter.request(target: .getRestaurantDetails(lat: currentLocation!.latitude, lon: currentLocation!.longitude), success: { [unowned self] response in
            do{
                let decoder = JSONDecoder()
                // decode the json object
                let getData = try decoder.decode(RestaurantCodableModel.self,from: response.data)
                DispatchQueueHelper.delay(bySeconds: 0) {
                    self.restaurantData = getData
                    DispatchQueueHelper.delay(bySeconds: 0, dispatchLevel: .main) {
                        self.delegate?.callBack()
                    }
                }
            }
            catch let err { print("Err", err)}
            }, error: {error  in self.delegate?.showAlert(message: error.localizedDescription)}
            , failure: {moyaError in self.delegate?.showAlert(message: moyaError.localizedDescription)})
    }
    // when vm was dispose it must be to clear all dependency
    deinit {
        delegate = nil
    }
}
extension RestaurantDetailsVM {
    var restaurantName: String {
        return restaurantData.name
    }
    var restaurantLat: Double {
        return Double(restaurantData.lat)!
    }
    var restaurantLon: Double {
        return Double(restaurantData.lon)!
    }
    var restaurantCategoryAndRank: String {
        return "\(restaurantData.rating!) / 10 - \(restaurantData.cat!)"
    }
}

