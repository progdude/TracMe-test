//
//  MyAnnotation.swift
//  MapViewTest
//
//  Created by Andrei Gurau on 3/15/16.
//  Copyright © 2016 Andrei Gurau. All rights reserved.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String!
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}