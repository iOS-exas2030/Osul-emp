//
//  mapVC.swift
//  AL-HHALIL
//
//  Created by apple on 8/25/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import JSSAlertView
import Toast_Swift

protocol ReturnLocationDelegate {
    func locationBack(lat :Double , long : Double)
}

class mapVC: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var searchicon: UIBarButtonItem!
    @IBOutlet weak var myMapView: MKMapView!
    var locationManager: CLLocationManager!
    var myNewView = UIView()
    var selectedPin:MKPlacemark? = nil
    var resultSearchController: UISearchController? = nil
    var delegete :ReturnLocationDelegate?
    var latitude = ""
    var longitude = ""
    var chossenLong :Double = 0
    var chossenLat :Double = 0
    var check = true
    
    //
    var projectName = ""
    var projectPhone = ""
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "centerMapBtn").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("latitude = \(latitude)")
        print("longitude = \(longitude)")
        let annotation = MKPointAnnotation()
        annotation.title = projectName
        annotation.subtitle = projectName
        if check == false {
            self.navigationItem.setRightBarButton(nil, animated: true)
            centerMapButton.isHidden = true
        }else{
            navigationController?.setNavigationBarHidden(false, animated: true)
            centerMapButton.isHidden = false
            if latitude == "" || longitude == "" || latitude == "0.0" || longitude == "0.0"{
                JSSAlertView().warning(self,title: "تنبيه !",text: "يجب تحديد موقعك بالضغط ضغطه مطولة",buttonText: "موافق")
                configureMapView()
            }else{
                configureMapView()
            }
        }
        annotation.coordinate = CLLocationCoordinate2DMake(Double(self.latitude) ?? 0, Double(self.longitude) ?? 0)
        self.myMapView.addAnnotation(annotation)
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double(self.latitude) ?? 0, Double(self.longitude) ?? 0)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.myMapView.setRegion(region, animated: true)
        configureLocationManager()
        
        setMapview()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        //  hideLoaderWithTimer(mainView: &myNewView)
    }
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        delegete?.locationBack(lat: chossenLat, long: chossenLong)
        // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //     //   if (navigationController?.viewControllers.firstIndex(of: self) ?? NSNotFound) == NSNotFound {
    //            // Navigation button was pressed. Do some stuff
    //            navigationController?.popViewController(animated: false)
    //            delegete?.locationBack(lat: chossenLat, long: chossenLong)
    //            print("yeeeeess")
    //
    //      //  }
    //        super.viewWillDisappear(animated)
    //    }
    func setMapview(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.myMapView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureReconizer.location(in: myMapView)
            let locationCoordinate = myMapView.convert(touchLocation,toCoordinateFrom: myMapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            addAnnotation(location: locationCoordinate)
            return
        }
        if gestureReconizer.state != UIGestureRecognizer.State.began {
            return
        }
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.chossenLat = location.latitude
        self.chossenLong = location.longitude
        annotation.title = projectName
        annotation.subtitle = projectName
        self.myMapView.addAnnotation(annotation)
        self.view.makeToast("تم حفظ الموقع", duration: 5.0, position: .bottom)
    }
    
    // MARK: - Selectors
    @objc func handleCenterLocation() {
        centerMapOnUserLocation()
        enableLocationServices()
        //centerMapButton.alpha = 1
    }
    // MARK: - Helper Functions
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func configureMapView() {
        myMapView.showsUserLocation = true
        myMapView.delegate = self
        myMapView.userTrackingMode = .follow
        view.addSubview(centerMapButton)
        centerMapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40
        ).isActive = true
        centerMapButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        centerMapButton.cornerRadius = 30
        centerMapButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        centerMapButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        // centerMapButton.layer.cornerRadius = 50 / 2
        centerMapButton.alpha = 1
    }
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.chossenLat = coordinate.latitude
        self.chossenLong = coordinate.longitude
        myMapView.setRegion(region, animated: true)
        // self.view.makeToast("تم حفظ الموقع", duration: 5.0, position: .bottom)
    }
    
    @IBAction func searchButton(_ sender: Any)
    {
        let locationSearchTable = self.storyboard?.instantiateViewController(withIdentifier: "locationSearchTable") as! locationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        definesPresentationContext = true
        locationSearchTable.mapView = myMapView
        locationSearchTable.handleMapSearchDelegate = self
        //   let searchController = UISearchController(searchResultsController: nil)
        self.navigationController?.navigationBar.isTranslucent = true
        resultSearchController?.searchBar.delegate = self
        present(resultSearchController!, animated: true, completion: nil)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
                let annotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(annotations)
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                self.myMapView.addAnnotation(annotation)
                self.chossenLat = latitude!
                self.chossenLong = longitude!
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.myMapView.setRegion(region, animated: true)
                
                
            }
            
        }
        
    }
}
// MARK: - MKMapViewDelegate
extension mapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.centerMapButton.alpha = 1
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension mapVC: CLLocationManagerDelegate {
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
        if latitude == "" || longitude == ""{
            centerMapOnUserLocation()
        }
        
    }
}
extension mapVC: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        myMapView.removeAnnotations(myMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        self.chossenLat = placemark.coordinate.latitude
        self.chossenLong = placemark.coordinate.longitude
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        myMapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        myMapView.setRegion(region, animated: true)
        self.view.makeToast("تم حفظ الموقع", duration: 5.0, position: .bottom)
    }
}

