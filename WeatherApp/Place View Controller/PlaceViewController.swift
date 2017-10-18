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

    var coordinate: CLLocationCoordinate2D?

    private let api = API(baseURL: AppInfo.baseURLForAPI, APIPrefix: AppInfo.prefixForAPI, version: AppInfo.versionForAPI, APIKey: AppInfo.appIdForAPI)
    private var runningTask: URLSessionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        
        if let coordinate = coordinate {
            runningTask = api.getCurrentWeather(by: coordinate, completion: { (data, error) in
                if let data = data  {
                    print("success \(data)")
                }
                else if let error = error {
                    print("error \(error)")
                }
            })
            runningTask?.resume()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParentViewController || isBeingDismissed {
            runningTask?.cancel()
        }
    }
}

