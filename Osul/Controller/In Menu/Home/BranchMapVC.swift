//
//  BranchMapVC.swift
//  Kyan
//
//  Created by Sayed Abdo on 1/17/21.
//  Copyright © 2021 Sayed Abdo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BranchMapVC: UIViewController , MKMapViewDelegate ,CLLocationManagerDelegate{
    
    
    
    var locationManager: CLLocationManager!
    @IBOutlet weak var LocationView: MKMapView!
     let annotation = MKPointAnnotation()
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "kyan logo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
   var levelData : ProjectLevelsModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(Double(levelData?.lat ?? "0.0") ?? 0, Double(levelData?.lng ?? "0.0") ?? 0)
       // annotation.title = levelData?.data.name ?? ""
       // let subAdderss = levelData?.getbranchOwner?.name
       // annotation.subtitle = subAdderss!
        self.LocationView.addAnnotation(annotation)

        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(levelData?.lat ?? "0.0") ?? 0, Double(levelData?.lng ?? "0.0") ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.LocationView.setRegion(region, animated: true)
           
        
        configureLocationManager()
        configureMapView()
        centerMapOnUserLocation()
    }
    @objc func handleCenterLocation() {
        centerMapOnUserLocation()
        enableLocationServices()
        //centerMapButton.alpha = 1
    }
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    func configureMapView() {
        LocationView.showsUserLocation = true
        LocationView.delegate = self
        LocationView.userTrackingMode = .follow
        
        LocationView.isZoomEnabled = false
        LocationView.isScrollEnabled = false
        LocationView.isUserInteractionEnabled = false
        
        view.addSubview(centerMapButton)
        centerMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -44).isActive = true
        centerMapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        centerMapButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        centerMapButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        centerMapButton.layer.cornerRadius = 50 / 2
        centerMapButton.alpha = 1
    }
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        LocationView.setRegion(region, animated: true)
    }
    func enableLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Location auth status is NOT DETERMINED")
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Location auth status is RESTRICTED")
        case .denied:
            print("Location auth status is DENIED")
        case .authorizedAlways:
            print("Location auth status is AUTHORIZED ALWAYS")
        case .authorizedWhenInUse:
            print("Location auth status is AUTHORIZED WHEN IN USE")
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard locationManager.location != nil else { return }
        centerMapOnUserLocation()
    }
    

}
