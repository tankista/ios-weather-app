//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import UIKit
import MapKit

class MapViewViewController: UIViewController {
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hello(sender:)))
        recognizer.numberOfTapsRequired = 2
        return recognizer
    }()
    
    var mapView: MKMapView {
        return view as! MKMapView
    }
    
    override func loadView() {
        view = MKMapView()
        mapView.showsCompass = true
        mapView.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Private Methods
    
    @objc func hello(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let vc = PlaceViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
}
