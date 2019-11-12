//
//  ss.swift
//  Wainnakel
//
//  Created by Bassuni on 11/11/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import Foundation
import CoreLocation
func getCurrentLocation() -> CLLocationCoordinate2D?
{
    let locationManger = CLLocationManager()
    guard locationManger.location != nil && locationManger.location?.coordinate != nil else { return nil }
    return CLLocationManager().location?.coordinate
}

