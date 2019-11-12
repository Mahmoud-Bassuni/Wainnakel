//
//  NetworkAdapter.swift
//  Wainnakel
//
//  Created by Bassuni on 11/11/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import Foundation
import Moya
struct NetworkAdapter<T> where T: TargetType {
    private  let provider = MoyaProvider<T>()
    func request(target: T, success successCallback: @escaping (Response) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    successCallback(response)
                } else {
                    let error = NSError(domain:"http://wainnakel.com", code:0, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"])
                    errorCallback(error)
                }
            case .failure(let error):
                failureCallback(error)
            }
        }
    }
}
