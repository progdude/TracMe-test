//
//  TrackerViewController.swift
//  TracMe
//
//  Created by Andrei Gurau on 3/19/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class TrackerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var destination: MKPointAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var myLocations: [CLLocation] = []
    var myEmail: String!
    
    @IBOutlet weak var copsButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    
    @IBOutlet weak var arrivedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrivedButton.layer.cornerRadius=5;
        friendButton.layer.cornerRadius=5;
        copsButton.layer.cornerRadius=5;
        // Do any additional setup after loading the view, typically from a nib.
        
        //let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        //goToLocation(centerLocation)
        print(destination)
        
       
        
        
        //Setup our Map View
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        //destination.coordinate =
        //destination.title = item.name!;
        //print(anotation.coordinate);
        self.mapView.addAnnotation(destination!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        //print(locations[0])
        print(locations[0].coordinate.latitude)
        print(locations[0].coordinate.longitude)
        
        myEmail = myEmail!.stringByReplacingOccurrencesOfString(".", withString: "t", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var refrence = Firebase(url: "https://vivid-torch-4452.firebaseio.com/"+myEmail);
        
        var coord = ["latitude": locations[0].coordinate.latitude, "longitude": locations[0].coordinate.longitude];
        var tracker = ["coordinate": coord]
        
        refrence.updateChildValues(tracker)
        
        
        myLocations.append(locations[0] as CLLocation)
        
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        
        if (myLocations.count > 1){
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.addOverlay(polyline)
        }
    }

}