//
//  TrackFriendViewController.swift
//  TracMe
//
//  Created by Andrei Gurau on 4/5/16.
//  Copyright © 2016 Archit Rathi. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class TrackFriendViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var copsButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    var e: String!;
    var myEmail: String!
    var trackingEmail: String!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var myLocations: [CLLocation] = []
    
    @IBAction func callFriend(sender: AnyObject) {
        var url:NSURL = NSURL(string: "tel://123456789")!
        UIApplication.sharedApplication().openURL(url)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        friendButton.layer.cornerRadius = 5;
        copsButton.layer.cornerRadius = 5;
        
        var carlos = Firebase(url: "https://vivid-torch-4452.firebaseio.com/"+myEmail+"/tracker/email");
        
        carlos.observeEventType(.Value, withBlock: { snapshot in
            self.e = snapshot.value as! String;
            self.locs()
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
        
        
        //Setup our Map View
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        //locs()
        //destination.coordinate =
        //destination.title = item.name!;
        //print(anotation.coordinate);
        //self.mapView.addAnnotation(destination!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
    
    func locs(){
        //print(locations[0])
    
        e = e!.stringByReplacingOccurrencesOfString(".", withString: "t", options: NSStringCompareOptions.LiteralSearch, range: nil);
        var ref = Firebase(url: "https://vivid-torch-4452.firebaseio.com/"+e+"/coordinate")
        
        var long: Double = 0.0;
        var lat: Double = 0.0;
        
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            var d = snapshot.value as! NSDictionary
            lat = d["latitude"] as! Double
            long = d["longitude"] as! Double
            self.goToLocation(CLLocation(latitude: lat, longitude: long))
            var x = CLLocationCoordinate2D(latitude: lat, longitude: long)
            self.removeAnnotations()
            var newAnotation = MKPointAnnotation()
            newAnotation.coordinate = x
            newAnotation.title = ""
            
            self.mapView.addAnnotation(newAnotation)
            }, withCancelBlock: { error in
                print(error.description)
            })
        //print(lat)
        //var x = CLLocationCoordinate2D(latitude: lat, longitude: long)
        //myLocations.append(x)
        
        let spanX = 0.007
        let spanY = 0.007
        var newRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
        
        
        /*var newAnotation = MKPointAnnotation()
        newAnotation.coordinate = x
        print(newAnotation.coordinate)
        newAnotation.title = ""
        
        mapView.addAnnotation(newAnotation)*/
        
        
        if (myLocations.count > 1){
            var sourceIndex = myLocations.count - 1
            var destinationIndex = myLocations.count - 2
            
            
            
            
            /*let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            var geodesic = MKGeodesicPolyline(coordinates: &a[0], count: 2)
            self.mapView.addOverlay(geodesic);
            
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region1 = MKCoordinateRegion(center: c1, span: span)
                self.mapView.setRegion(region1, animated: true);
            })*/
        }
    }
    
    
    func removeAnnotations(){
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
    }
    
}