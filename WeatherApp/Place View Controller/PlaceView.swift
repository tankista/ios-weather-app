//
//  PlaceView.swift
//  WeatherApp
//
//  Created by Peter Stajger on 18/10/2017.
//  Copyright © 2017 Peter Stajger. All rights reserved.
//

import UIKit

final class PlaceView : UIView {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var himidityLabel: UILabel!
    @IBOutlet weak var visiblityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
}

extension PlaceView {
    func reload(with data: WeatherData) {
        
        cityLabel.text = data.name
        
        let formatter = MeasurementFormatter()
        let measurement = Measurement(value: data.main.temp, unit: UnitTemperature.kelvin)
    
        temperatureLabel.text = formatter.string(from: measurement)
        
        //did not have time to user proper formatters here
        descriptionLabel.text = data.weather.first?.desc
        pressureLabel.text = String(describing: data.main.pressure)
        himidityLabel.text = String(describing: data.main.humidity)
        visiblityLabel.text = String(describing: data.visibility)
        windLabel.text = "\(data.wind.speed)/\(data.wind.deg)°"
    }
}
