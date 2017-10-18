//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import UIKit

class MapViewViewController: UIViewController {
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(hello(sender:)))
        recognizer.numberOfTapsRequired = 2
        return recognizer
    }()
    
    @objc func hello(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            let vc = PlaceViewController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
