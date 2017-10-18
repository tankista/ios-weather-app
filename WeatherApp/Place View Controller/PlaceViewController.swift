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
    
    var placeView: PlaceView {
        return view as! PlaceView
    }
    
    override func loadView() {
        view = UINib(nibName: "PlaceView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let coordinate = coordinate {
            runningTask = api.getCurrentWeather(by: coordinate, completion: { [weak self] (data, error) in
                if let data = data  {
                    self?.placeView.reload(with: data)
                }
                else if let error = error?.api {
                    let alert = UIAlertController.okAlert(title: "Loading Failed", message: error.message)
                    self?.present(alert, animated: true, completion: nil)
                }
                else if let error = error?.http {
                    let alert = UIAlertController.okAlert(title: "Loading Failed", message: error.localizedDescription)
                    self?.present(alert, animated: true, completion: nil)
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

