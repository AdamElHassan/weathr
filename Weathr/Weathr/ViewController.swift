//
//  ViewController.swift
//  Weathr
//
//  Created by Adam El Hassan on 21/02/2019.
//  Copyright © 2019 Adam El Hassan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var degree: UILabel!
    @IBOutlet weak var cityName: UITextField!
    var cityString = "s-Hertogenbosch";
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getKelvinInCity()
    }
    func getKelvinInCity(){
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityString)&appid=3b7c0bb2df5778f696d6dfc53b6189c9"){
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let receivedData = data {
                    Swift.print("\(receivedData)")
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: receivedData) as? [String:Any]{
                            var temperatureInKelvin : NSMeasurement?
                            if let main = json["main"] as? [String:Any],
                                let temperature = main["temp"] as? Double{
                                temperatureInKelvin = NSMeasurement(doubleValue:  temperature, unit: UnitTemperature.kelvin)
                                if let temperatureInCelsius =  temperatureInKelvin?.converting(to: UnitTemperature.celsius).value {
                                        DispatchQueue.main.async {
                                            
                                            self.degree.text = "\(temperatureInCelsius)"
                                        }
                                }
                            }
                        }
                        
                    } catch  { }
                }
            }
            task.resume()
        }
    }
    @IBAction func submitCity(_ sender: Any) {
        cityString = cityName.text!;
        getKelvinInCity()
    }
    
}

