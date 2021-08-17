//
//  MapViewController.swift
//  Fast Foodz
//
//  Created by Jeff on 2021/8/4.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: YelpDataViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    var pointAnnotation:CustomAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// ========================
//
// Handle Pins
//
// ========================
extension MapViewController: MKMapViewDelegate, MapViewProtocol{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseIdentifier = "pins"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }

        if let customPointAnnotation = annotation as? CustomAnnotation{
            annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        }

        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? CustomAnnotation{
            self.delegate.performSegue(withIdentifier: "showDetail", sender: annotation.place)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
            
    }
    
    func setupPins(){
        for place in self.places{
            let location = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            pointAnnotation = CustomAnnotation()
            pointAnnotation.pinCustomImageName = "pin"
            pointAnnotation.place = place
            pointAnnotation.coordinate = location
            
            let pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pins")
            self.mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
}


