//
//  MapDeliveryViewController.swift
//  Dikii Zapad
//
//  Created by mac on 27.01.2024.
//

import UIKit
import MapKit
import CoreLocation
import EasyPeasy

class MapDeliveryViewController: UIViewController {
    var geoCoder: CLGeocoder = CLGeocoder()
    var searchLocation: [CLPlacemark] = []
    
    //TO DO: Mock location shop
    let latitude: CLLocationDegrees = 47.752105
    let longitude: CLLocationDegrees = 39.935179
    lazy var locationShop = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    private lazy var shopAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.title = "DikiyZapad"
        annotation.subtitle = "addressTextField.text"
        annotation.coordinate = locationShop
        return annotation
    }()
    
    private lazy var annotationSearch: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.subtitle = "Доставка по адрессу"
        return annotation
    }()
    
    func showShopPosition() {
        let annotation = MKPointAnnotation()
        annotation.title = "DikiyZapad"
        annotation.subtitle = addressTextField.text ?? ""
        annotation.coordinate = locationShop
        
        mapView.showAnnotations([annotation], animated: true)
    }
    
    private lazy var addressTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Введите адресс"
        textField.delegate = self
        textField.backgroundColor = .black
        return textField
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.overrideUserInterfaceStyle = .dark
        view.delegate = self
        return view
    }()
    
    private lazy var containerForStack: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.maskCorners(radius: 24, [.bottomLeft, .bottomRight])
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var confirmButton: UIButton = {
        let button  = UIButton(type: .system)
        button.backgroundColor = UIColor.customOrange
        button.layer.cornerRadius = 15
        button.setTitle("ПОДТВЕРДИТЬ", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(confirmButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(mapView)
        view.addSubview(addressTextField)
        
        view.addSubview(containerForStack)
        containerForStack.addSubview(stackView)
        view.addSubview(confirmButton)
        
        
        view.addTapGesture { [weak self] _ in
            self?.view.endEditing(true)
        }
        
        addressTextField.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(16), Right(16)
        )
        
        mapView.easy.layout(
            Top().to(addressTextField, .bottom),
            Left(), Right(),
            Bottom()
        )
        
        containerForStack.easy.layout(
            Top().to(addressTextField, .bottom),
            Left(16),
            Right(16),
            Bottom(<=20)
        )
        
        stackView.easy.layout(
            Top(),
            Left(16), Right(16),
            Bottom()
        )
        
        confirmButton.easy.layout(
            Height(60),
            Left(16),
            Right(16),
            Bottom(20)
        )
        
        showShopPosition()
    }
    
    @objc func confirmButtonDidTap() {
        
    }
    
    func getLocation(from string: String, completion: @escaping ([CLPlacemark]?) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.geoCoder.geocodeAddressString(string) { placeMarks, error in
                if let _ = error {
                    completion(nil)
                    return
                }
                
                guard let placeMarks = placeMarks else {
                    completion(nil)
                    return
                }
                
                DispatchQueue.main.async {
                    completion(placeMarks)
                }
            }
        }
    }
    
    
    func addAndFilterLocations(placeMarks: [CLPlacemark], completion: @escaping ([CLPlacemark]) -> Void) {
        let countryFilter = "RU"
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            var oldPlaceMarks = self.searchLocation
            let newPlaceMarks = placeMarks.filter { $0.isoCountryCode == countryFilter }
            
            newPlaceMarks.forEach { placeMark in
                let isHadObject = oldPlaceMarks.contains { ($0.location?.coordinate.longitude == placeMark.location?.coordinate.longitude) && ($0.location?.coordinate.latitude == placeMark.location?.coordinate.latitude) }
                
                if !isHadObject {
                    oldPlaceMarks.insert(placeMark, at: 0)
                }
            }
            
            DispatchQueue.main.async {
                completion(Array(oldPlaceMarks.prefix(3)))
            }
        }
    }
    
    func setStackView() {
        stackView.removeAllArrangedSubviews()
        
        searchLocation.enumerated().forEach { (index, placeMark) in
            
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = .orange.withAlphaComponent(0.7)
            label.addTapGesture { [weak self, placeMark] _ in
                guard let self = self else { return }
                self.addressTextField.text = label.text
                self.stackView.removeAllArrangedSubviews()
                
                self.mapView.removeAnnotation(self.annotationSearch)
                self.annotationSearch.subtitle = label.text
                
                if let coordinate = placeMark.location?.coordinate {
                    self.annotationSearch.coordinate = coordinate
                    self.mapView.showAnnotations([self.annotationSearch], animated: true)
                    self.mapView.selectAnnotation(self.annotationSearch, animated: true)
                    
                    
                    
                }
            }
            
            label.easy.layout(
                Height(50)
            )
            
            let name = placeMark.name ?? "" //Улица, дом
            let locality = placeMark.locality ?? "" //Город
            let thoroughfare = placeMark.thoroughfare ?? "" // Улица
            let subThoroughfare = placeMark.subThoroughfare ?? "" //Дом
            let administrativeArea = placeMark.administrativeArea
            let region = placeMark.region

            
            if locality != name {
                label.text = name + ", " + locality
            } else {
                label.text = locality
            }
            
            stackView.addArrangedSubview(label)
        }
    }
    
    
    func updateLocations(newText: String) {
        getLocation(from: newText) { [weak self] newPlaceMarks in
            guard let newPlaceMarks = newPlaceMarks else { return }
            
            self?.addAndFilterLocations(placeMarks: newPlaceMarks) { [weak self] filteredPlaceMarks in
                guard !filteredPlaceMarks.isEmpty else {
                    self?.cleanLocations()
                    return
                }
                
                self?.searchLocation = filteredPlaceMarks
                self?.setStackView()
            }
            
        }
    }
    
    func cleanLocations() {
        searchLocation = []
        stackView.removeAllArrangedSubviews()
    }
}


extension MapDeliveryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
            return true
        }

        if newText.isEmpty || newText == "" {
            cleanLocations()
        } else {
            updateLocations(newText: newText)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}


extension MapDeliveryViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
    

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        
    }
    
   
}
