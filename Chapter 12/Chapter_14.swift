/*
 Chapter - 14
 Core Location with Mapkit
 */

import UIKit
import CoreLocation

class WSLocationManager: UIViewController
{
    var locationManager : CLLocationManager!
    var kMinUpdateDistance = 5.0
    var updateTimer: Timer!
    var userLocation: CLLocation!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CLLocationManager.locationServicesEnabled()
        {
            requestLocationAuthorization()
        }
    }
    /*
     Setting up Location Manager Properties
     - type, filter, accuracy, enabled check
     */
    func setupLocationManager()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.distanceFilter = kMinUpdateDistance
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = false
    }
    
    
    
    /*
     Check GPS Setting Status
     - Always, WhenIn Use , Not Determined etc
     
     */
    func requestLocationAuthorization()
    {
        let status = CLLocationManager.authorizationStatus()
        if status == CLAuthorizationStatus.notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        else if status == CLAuthorizationStatus.authorizedWhenInUse
        {
            // perform any operation if required
        }
    }
    
    /*
     Check for location is enabled or not and return red / green image
     */
    func checklocationEnabled() -> UIImage
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
            case .notDetermined, .restricted, .denied:
                print("No access")
                return UIImage(named: "RedGPS")!
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                return UIImage(named: "GreenGPS")!
            default:
                print("Access")
                return UIImage(named: "GreenGPS")!
            }
        } else {
            print("Location services are not enabled")
            return UIImage(named: "RedGPS")!
        }
    }
    
    // Request Location Update
    @objc func forceUpdateLocation()
    {
        locationManager.requestLocation()
    }
    
    
    /*
     Trigger to start GPS Location Tracking
     */
    func startTracking()
    {
        locationManager.startUpdatingLocation()
        updateTimer = Timer.scheduledTimer(timeInterval: 16.0, target: self, selector: #selector(WSLocationManager.forceUpdateLocation), userInfo: nil, repeats: true)
    }
    
    
    /*
     Trigger to stop GPS Location Tracking
     */
    
    func stopTracking()
    {
        locationManager.stopUpdatingLocation()
        if (updateTimer != nil) {
            updateTimer!.invalidate()
            updateTimer = nil
        }
    }
    
    /*
     Get current location latitude and longitude from Location Manager
     */
    func currentUserLocation() -> (Float, Float)?
    {
        var lat: Float
        var long: Float
        if let location = locationManager.location {
            lat = Float(location.coordinate.latitude)
            long = Float(location.coordinate.longitude)
            return (lat, long)
        }
        return nil
    }
    
    
    
}

extension WSLocationManager: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.authorizedWhenInUse
        {
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locationManager.location
        NSLog("userLocation \(String(describing: userLocation))")
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        NSLog("LocationTracker: didFailWithError \(error)")
        if locationManager.location?.coordinate == nil
        {
            userLocation = CLLocation.init(latitude: CLLocationDegrees(0.0), longitude: CLLocationDegrees(0.0))
        }
    }
}

// Google Maps
import GooglePlaces // If gives error follow instrcutions from book
import GoogleMaps

class MyViewController: UIViewController
{
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else
        {
            mapView.animate(to: camera)
        }
    }
}


class MyAppleViewController: UIViewController
{
    @IBOutlet var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                            locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "You are Here"
        mapView.addAnnotation(annotation)
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
                                -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
                                            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    func getCoordinate( addressString : String,
                        completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    func monitorRegionAtLocation(center: CLLocationCoordinate2D, identifier: String ) {
        // Make sure the device supports region monitoring.
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            // Register the region.
            let maxDistance = locationManager.maximumRegionMonitoringDistance
            let region = CLCircularRegion(center: center,
                                          radius: maxDistance, identifier: identifier)
            region.notifyOnEntry = true
            region.notifyOnExit = false
            
            locationManager.startMonitoring(for: region)
            
        }
    }
}
