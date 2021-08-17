//
//  DetailViewController.swift
//  Fast Foodz
//
//  Created by Jeff on 2021/8/6.
//

import Foundation
import UIKit
import Kingfisher
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate{
    
    var place: Place!
    var source: CLLocationCoordinate2D!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: CustomLabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var callButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        drawDirectionLine()
    }
    
    func setup(){
        self.title = "Details"
        
        imageView.kf.setImage(with: URL(string: place.image_url))
        imageView.backgroundColor = .londonSky
        
        nameLabel.text = place.name
        
        callButton.backgroundColor = .competitionPurple
        callButton.setTitleColor(.white, for: .normal)
        callButton.layer.cornerRadius = 6
        
        mapView.delegate = self
        mapView.layer.cornerRadius = 12
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "share"), style: .done, target: self, action: #selector(self.share(sender:)))
    }
    
    @objc func share(sender: UIBarButtonItem) {
        let page_url : NSURL = NSURL(string: place.page_url)!
        let shareViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [page_url], applicationActivities: nil)
        shareViewController.isModalInPresentation = true
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    @IBAction func didTapCall(_ sender: Any) {
        if (place.phone == ""){
            let alert = UIAlertController(title: "Alert", message: "Phone number not found", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else{
            if let url = NSURL(string: "tel://\(place.phone)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
        }
    }
}


// ===========================
//
// Handle Direction Line
//
// ===========================
extension DetailViewController{
    func drawDirectionLine(){
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.place.latitude, longitude: self.place.longitude), addressDictionary: nil))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)

        directions.calculate{[unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .bluCepheus
        renderer.lineWidth = 4
        return renderer
    }
}
