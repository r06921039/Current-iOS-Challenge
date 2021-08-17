//
//  HomeViewController.swift
//  Fast Foodz
//
//  Created by Jeff on 2021/8/4.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var listView: UIView!
    
    private var mapViewController: MapViewController!
    private var listViewController: ListViewController!
    private var fetchOnce: Bool = false
    private var places: [Place] = []
    private var userLocation: CLLocationCoordinate2D!
    
    let locationManager = CLLocationManager()
    
    let defaults = UserDefaults.standard
    let indicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10.0
        checkLocationServices()
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func didTapSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            UIView.animate(withDuration: 0.5, animations:{
                self.mapView.alpha = 1
                self.listView.alpha = 0
                self.defaults.removeObject(forKey: "Segment")
                self.defaults.synchronize()
            })
            break
        case 1:
            UIView.animate(withDuration: 0.5, animations:{
                self.mapView.alpha = 0
                self.listView.alpha = 1
                self.defaults.set("List", forKey: "Segment")
                self.defaults.synchronize()
            })
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController, segue.identifier == "showMapView" {
            self.mapViewController = vc
            self.mapViewController.delegate = self
        }
        if let vc = segue.destination as? ListViewController, segue.identifier == "showListView" {
            self.listViewController = vc
            self.listViewController.delegate = self
        }
        if let vc = segue.destination as? DetailViewController, segue.identifier == "showDetail", let place = sender as? Place{
            vc.place = place
            vc.source = self.userLocation
        }
    }
    
    private func setup(){
        self.title = "Fast Food Places"
        segmentedController.backgroundColor = .londonSky
        segmentedController.selectedSegmentTintColor = .competitionPurple
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.deepIndigo], for: .normal)
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        self.listView.alpha = 0
        self.mapView.alpha = 0
        self.segmentedController.isHidden = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.indicator.center = self.view.center
        self.indicator.startAnimating()
        self.view.addSubview(self.indicator)
    }
    
    private func showHomeView(){
        if let lastSelected = self.defaults.object(forKey: "Segment"){
            self.mapView.alpha = 0
            self.listView.alpha = 1
            self.segmentedController.selectedSegmentIndex = 1
        }
        else{
            self.mapView.alpha = 1
            self.listView.alpha = 0
            self.segmentedController.selectedSegmentIndex = 0
        }
        self.indicator.stopAnimating()
        self.indicator.isHidden = true
        self.segmentedController.isHidden = false
    }
}

//===========================
//
// Handle Location
//
//===========================
extension HomeViewController{
    private func checkLocationServices() {
      if CLLocationManager.locationServicesEnabled() {
        checkLocationAuthorization()
      } else {
        // Show alert letting the user know they have to turn this on.
      }
    }
    
    private func locationAuthorizationStatus() -> CLAuthorizationStatus {
        var locationAuthorizationStatus : CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            // Fallback on earlier versions
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.checkLocationAuthorization()
    }
    
    private func checkLocationAuthorization() {
        switch locationAuthorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            let defaultLocation = CLLocationCoordinate2D(latitude: 40.758896, longitude: -73.985130)
            self.userLocation = defaultLocation
            let viewRegion = MKCoordinateRegion(center: defaultLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapViewController.mapView.setRegion(viewRegion, animated: true)
            self.fetchDataFromYelp(withLocation: defaultLocation)
            print("here")
            break
        default:
            break
      }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 40.758896, longitude: -73.985130)
        self.userLocation = userLocation
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapViewController.mapView.setRegion(viewRegion, animated: true)
        self.fetchDataFromYelp(withLocation: userLocation)
    }
}

// ==========================
//
// Handle Data
//
// ==========================
extension HomeViewController{
    private func fetchDataFromYelp(withLocation location: CLLocationCoordinate2D){
        if fetchOnce{
            return
        }
        fetchOnce = true
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.yelpAPIKey)"
            ]
        let parameters: Parameters = ["latitude": location.latitude,
                                      "longitude": location.longitude,
                                      "radius": 1000,
                                      "sort_by": "distance",
                                      "categories": "pizza,mexican,chinese,burgers"
                                        ]
        AF.request(Constants.API_URL, parameters: parameters, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success( _):
                    if let data = response.data {
                        let json = try?JSON(data: data)
                        for (_, business): (String, JSON) in json!["businesses"] {
                            if let category = business["categories"].arrayValue.first(where: {$0["alias"] == "pizza" || $0["alias"] == "mexican" || $0["alias"] == "chinese" || $0["alias"] == "burgers"}) {
                                let newPlace = Place(business: business, category: category["alias"].string)
                                self.places.append(newPlace)
                            }
                        }
                        self.mapViewController.places = self.places
                        self.listViewController.places = self.places
                        self.listViewController.tableView.reloadData()
                        self.mapViewController.setupPins()
                        self.showHomeView()
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
    }
}
