//
//  MapViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 10/01/2023.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private var location: Location
    
    init(locationHotel: Location) {
        self.location = locationHotel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .light
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        renderLocation(location)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.fillAnchor(view)
    }
    
    private func renderLocation(_ location: Location?) {
        if let lat = Double(location?.latitude ?? ""), 
            let lon = Double(location?.longitude ?? "") {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            mapView.setCenter(coordinate, animated: true)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customPin")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customPin")
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "pin")
        annotationView?.tintColor = UIColor.green
        return annotationView
    }
}


