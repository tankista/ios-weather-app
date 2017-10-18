//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapDetected(sender:)))
        recognizer.numberOfTapsRequired = 2
        recognizer.delegate = self
        return recognizer
    }()
    
    var mapView: MKMapView {
        return view as! MKMapView
    }
    
    override func loadView() {
        view = MKMapView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        mapView.addGestureRecognizer(tapGestureRecognizer)
        mapView.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: Private Methods
    
    @objc func doubleTapDetected(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let touchPoint = sender.location(in: mapView)
            let vc = PlaceViewController()
            vc.coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}

extension MapViewViewController : MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    
    public func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        let alert = UIAlertController.okAlert(title: nil, message: "There was an error when locating user")
        present(alert, animated: true, completion: nil)
    }
}

extension MapViewViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            break
        case .denied:
            let alert = UIAlertController.okAlert(title: "Location Services", message: "To show user's location please enable location services in Settings app.")
            present(alert, animated: true, completion: nil)
        default: break
        }
    }
}

extension MapViewViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension UIAlertController {
    
    static func okAlert(title: String?, message: String?, okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: okHandler))
        return alert
    }
    
}
