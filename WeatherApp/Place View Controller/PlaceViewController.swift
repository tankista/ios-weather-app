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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.green
        
        if let coordinate = coordinate {
            let url = URL(string: "http://api.openweathermap.org")!
            let api = API(baseURL: url, APIPrefix: "data", version: "2.5", APIKey: "5020fc146ad33359b3bcf17b0bf007c2")
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

