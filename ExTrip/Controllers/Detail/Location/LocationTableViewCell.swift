//
//  LocationTableViewCell.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 10/01/2023.
//

import UIKit
import MapKit

protocol LocationTableViewCellDelegate: AnyObject {
    func locationTableViewCellHandleSeeMap()
}

class LocationTableViewCell: DetailTableViewCell {
    
    static let identifier = "LocationTableViewCell"
    
    weak var delegate: LocationTableViewCellDelegate?
    
    var descriptionLocation: String? {
        didSet {
            if let description = descriptionLocation {
                if description.isEmpty {
                    noReceiveData()
                } else {
                    descriptionLabel.text = description
                }
            } else {
                noReceiveData()
            }
        }
    }
            
    var location: Location? {
        didSet {
            renderLocation(location)
        }
    }
        
    public lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .light
        return map
    }()
    
    private lazy var descriptionLabel: UITextView = {
        let text = UITextView()
        text.font = .poppins(style: .light, size: 12)
        text.sizeToFit()
        text.isEditable = false
        text.isSelectable = false
        text.isScrollEnabled = false
        return text
    }()
    
    private lazy var seeMapButton: UIButton = {
        let button = UIButton()
        button.setTitle("See map", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor.theme.black ?? .black, for: .normal)
        button.titleLabel?.font = .poppins(style: .light, size: 12)
        button.backgroundColor = UIColor.theme.white ?? .white
        return button
    }()
    
    private lazy var locationView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = .poppins(style: .light, size: 13)
        label.textColor = UIColor.theme.lightGray
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    private lazy var iconLocationImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "pin")
        image.clipsToBounds = true
        return image
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        textLabel?.font = .poppins(style: .medium, size: 15)
        setupSubView()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubView() {
        backgroundColor = .clear
        addSubviews(descriptionLabel,
                    iconLocationImageView,
                    locationView,
                    addressLabel)
        mapView.delegate = self
        locationView.addSubviews(mapView, 
                                 seeMapButton)
        setupConstraintSubView()
    }

    private func setupConstraintSubView() {
        let iconSize: CGFloat = 40
        
        descriptionLabel.anchor(top: headerTitle.bottomAnchor,
                                leading: leadingAnchor,
                                trailing: trailingAnchor,
                                paddingLeading: padding, 
                                paddingTrailing: padding)
        descriptionLabel.setHeight(height: 70)
        
        iconLocationImageView.anchor(bottom: bottomAnchor,
                                     leading: leadingAnchor,
                                     paddingBottom: padding,
                                     paddingLeading: padding)
        iconLocationImageView.setHeight(height: iconSize)
        iconLocationImageView.setWidth(width: iconSize)
        
        addressLabel.anchor(bottom: bottomAnchor,
                            leading: iconLocationImageView.trailingAnchor,
                            trailing: trailingAnchor,
                            paddingBottom: padding,
                            paddingLeading: padding,
                            paddingTrailing: padding)
        addressLabel.setHeight(height: iconSize)
        
        locationView.anchor(top: descriptionLabel.bottomAnchor, 
                            bottom: iconLocationImageView.topAnchor, 
                            leading: leadingAnchor,
                            trailing: trailingAnchor,
                            paddingTop: padding,
                            paddingBottom: padding*2,
                            paddingLeading: padding*2,
                            paddingTrailing: padding*2)
        
        locationView.layer.masksToBounds = true
        mapView.fillAnchor(locationView)
        
        seeMapButton.anchor(bottom: locationView.bottomAnchor,
                            trailing: locationView.trailingAnchor,
                            paddingBottom: padding,
                            paddingTrailing: padding)
        seeMapButton.setHeight(height: 28)
        seeMapButton.setWidth(width: 70)
    }
    
    private func noReceiveData() {
        descriptionLabel.text = "No result"
        descriptionLabel.textAlignment = .center
    }
    
    private func setupAction() {
        seeMapButton.addTarget(self, action: #selector(handleSeeMapAction), for: .touchUpInside)
    }
    
    @objc func handleSeeMapAction() {
        delegate?.locationTableViewCellHandleSeeMap()
    }
    
    private func renderLocation(_ location: Location?) {
        if let lat = Double(location?.latitude ?? ""), 
            let lon = Double(location?.longitude ?? "") {
            getAddressFromLocation(latitude: lat, longitude: lon) { (address, error) in
                guard let address = address, error == nil else { return }
                self.addressLabel.text = address
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            mapView.setCenter(coordinate, animated: true)
            
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            let pin = MKPointAnnotation()
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
        }
    }
    
    private func getAddressFromLocation(latitude: Double, longitude: Double, completion: @escaping((String?, Error?) -> Void)) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard error == nil, let pm = placemarks, !pm.isEmpty else {
                completion(nil, error)
                return
            }
            var address: String = ""

            if let pm = placemarks, !pm.isEmpty {
                let place = placemarks![0] 
                
                if place.subThoroughfare != nil {
                    address = address + place.subThoroughfare! + " "
                }
                
                if place.thoroughfare != nil {
                    address = address + place.thoroughfare! + ", "
                }
                
                if place.subLocality != nil {
                    address = address + place.subLocality! + ", "
                }
                
                if place.subAdministrativeArea != nil {
                    address = address + place.subAdministrativeArea! + ", "
                }
                
                if place.locality != nil {
                    address = address + place.locality! + ", "
                }
                
                if place.country != nil {
                    address = address + place.country! + " "
                }
                if place.postalCode != nil {
                    address = address + place.postalCode! + " "
                }
                completion(address, nil)
            }
        }
    }
    
}

extension LocationTableViewCell: MKMapViewDelegate {
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
