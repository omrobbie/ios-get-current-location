//
//  ViewController.swift
//  Current Location
//
//  Created by omrobbie on 01/05/20.
//  Copyright © 2020 omrobbie. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    fileprivate let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        activityIndicator.startAnimating()
    }

    fileprivate func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization() // You need to add NSLocationWhenInUseUsageDescription to Info.plist
        locationManager.startUpdatingLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else {return}
        manager.stopUpdatingLocation()
        activityIndicator.stopAnimating()

        CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
            if let error = error {
                debugPrint("Error: \(error.localizedDescription)")
                return
            }

            guard let placemark = placemark?.first else {return}
            self.lblResult.text = "You are in \(placemark.administrativeArea ?? "somewhere"), \(placemark.country ?? "somewhere")"
        }
    }
}
