//
//  ViewController.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import UIKit
import MapKit

class PlaceViewController: UIViewController {

    let api = API(baseURL: AppInfo.baseURLForAPI, APIPrefix: AppInfo.prefixForAPI, version: AppInfo.versionForAPI, APIKey: AppInfo.appIdForAPI)
    var coordinate: CLLocationCoordinate2D?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        
        if let coordinate = coordinate {
            let task = api.getCurrentWeather(by: coordinate, completion: { (data, error) in
                if let data = data  {
                    print("success \(data)")
                }
                else if let error = error {
                    print("error \(error)")
                }
            })
            task.resume()
        }
    }
}

