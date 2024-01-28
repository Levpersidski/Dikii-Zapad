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
    
    //    let locationManager = CLLocationManager()
    
    //TO DO: Mock location shop
    let latitude: CLLocationDegrees = 47.752105
    let longitude: CLLocationDegrees = 39.935179
    lazy var locationShop = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    
    
    private lazy var testPriceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .red
        return label
    }()
    
    private lazy var shopAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.title = "DikiyZapad"
        annotation.subtitle = "Советской конституции 21"
        annotation.coordinate = locationShop
        return annotation
    }()
    
    private lazy var annotationSearch: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.title = "Доставка по адресу"
        return annotation
    }()
    
    private lazy var addressTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Введите адресс"
        textField.delegate = self
        return textField
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.overrideUserInterfaceStyle = .dark
        view.addLongPressGesture { [weak self] recognizer in
            self?.actionLongPressMap(recognizer)
        }
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
    
    private lazy var gradientView: GradientView = {
        let view = GradientView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        setupConstrains()
        
        view.addTapGesture { [weak self] _ in
            self?.view.endEditing(true)
        }
        mapView.showAnnotations([shopAnnotation], animated: true)
        
        
        gradientView.applyGradient(fromColor: .black,
                                   toColor: .clear,
                                   fromPoint: CGPoint(x: 0.5, y: 0),
                                   toPoint: CGPoint(x: 0.5, y: 1))
    }
    
    private func setupView() {
        view.addSubViews(
            mapView,
            gradientView,
            addressTextField,
            testPriceLabel,
            containerForStack,
            confirmButton
        )
        containerForStack.addSubview(stackView)
    }
    
    private func setupConstrains() {
        addressTextField.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(16), Right(16)
        )
        
        testPriceLabel.easy.layout(
            Right(),
            Top(10).to(addressTextField, .bottom)
        )
        
        gradientView.easy.layout(
            Top().to(addressTextField, .top),
            Left(), Right(),
            Bottom(-20).to(addressTextField, .bottom)
        )
        
        mapView.easy.layout(
            Top().to(addressTextField, .top),
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
    }
    
    @objc private func actionLongPressMap(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let location2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            showSearchAnnotation(coordinate: location2D)
            geoCoder.reverseGeocodeLocation(location) { [weak self] placeMark, error in
                guard let self = self else { return }
                guard let placeMark = placeMark?.first else { return }
                
                self.addressTextField.text = self.createNameLocation(from: placeMark)
                self.annotationSearch.subtitle = self.createNameLocation(from: placeMark)
            }
        }
    }
    
    @objc private func confirmButtonDidTap() {
        mapView.removeOverlays(mapView.overlays)
        
        let startPoint = MKPlacemark(coordinate: shopAnnotation.coordinate)
        let endPoint = MKPlacemark(coordinate: annotationSearch.coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        direction.calculate { [weak self] response, error in
            guard let response = response else {
                self?.showAlert("Ошибка",
                                message: "Не удалось построить маршрут",
                                showCancel: true,
                                cancelTitle: "Закрыть",
                                okTitle: "Повторить",
                                present: true,
                                completion: { [weak self] in self?.confirmButtonDidTap() })
                return
            }
            
            if let rout = response.routes.first {
                let distance = rout.distance
                print("=-= distance \(distance)")
                
                guard let self else { return }
                
                let cordage = self.testCalculateSum(distance: distance)
                let value = cordage.0
                let hasSale = cordage.1
                
                self.testPriceLabel.text = "\(distance)м = \(value) \(hasSale ? "Скидка от 700" : "")"
                self.mapView.addOverlay(rout.polyline)
                
                let region = MKCoordinateRegion(center: rout.polyline.coordinate, latitudinalMeters: rout.distance + 50, longitudinalMeters: rout.distance + 50)
                
                
                self.mapView.setRegion(region, animated: true)
            }
        }
        
    }
    
    private func testCalculateSum(distance: CLLocationDistance) -> (Double, Bool) {
//        let value: Double = Double(distance)
        
        if distance < 1700 {
            return (50, true) //Центр
        } else if distance < 2500 {
            return (50, false) // Горловка-Горькая - 50р
        } else if distance < 9000 {
            return (100, false) //Кировка-Городская-Радио-Микрорайон-Западная-ЖБК - 100р
        } else if distance < 11000 {
            return (150, false) // Новая Соколовка-Алексеевка 150р
        } else if distance < 12000 {
            return (200, false) // Старая Соколовка-пос.Красный 200р
        } else if distance < 15000 {
            return (250, false) // Самбек 250р.
        } else if distance < 22000 {
            return (300, false) // Юбилейная-Нефтезавод 300р.
        }
        
        return (9999, false)
    }

    
    private func createNameLocation(from placeMark: CLPlacemark) -> String {
        let string: String
        
        let name = placeMark.name ?? "" //Улица, дом
        let locality = placeMark.locality ?? "" //Город
//        let thoroughfare = placeMark.thoroughfare ?? "" // Улица
//        let subThoroughfare = placeMark.subThoroughfare ?? "" //Дом
//        let administrativeArea = placeMark.administrativeArea
//        let region = placeMark.region
        
        if locality != name {
            string = name + ", " + locality
        } else {
            string = locality
        }
        return string
    }
    
    private func setStackView() {
        stackView.removeAllArrangedSubviews()
        
        searchLocation.enumerated().forEach { (index, placeMark) in
            let label = UILabel()
            label.font = .systemFont(ofSize: 14, weight: .bold)
            label.textColor = .orange.withAlphaComponent(0.7)
            label.addTapGesture { [weak self, placeMark] _ in
                guard let self = self else { return }
                self.addressTextField.text = label.text
                self.stackView.removeAllArrangedSubviews()
                self.view.endEditing(true)
                
                self.showSearchAnnotationWithName(placeMark: placeMark)
            }
            
            label.easy.layout(
                Height(50)
            )
            
            label.text = createNameLocation(from: placeMark)
            
            stackView.addArrangedSubview(label)
        }
    }
    
    private func cleanLocations() {
        searchLocation = []
        stackView.removeAllArrangedSubviews()
    }
}

//MARK: - display locations
private extension MapDeliveryViewController {
    func showSearchAnnotationWithName(placeMark: CLPlacemark) {
        mapView.removeAnnotation(annotationSearch)
        annotationSearch.subtitle = createNameLocation(from: placeMark)
        
        if let coordinate = placeMark.location?.coordinate {
            self.annotationSearch.coordinate = coordinate
            self.mapView.showAnnotations([self.annotationSearch], animated: true)
            self.mapView.selectAnnotation(self.annotationSearch, animated: true)
        }
    }
    
    func showSearchAnnotation(coordinate: CLLocationCoordinate2D) {
        mapView.removeAnnotation(annotationSearch)
        
        annotationSearch.subtitle = nil
        annotationSearch.coordinate = coordinate
        mapView.showAnnotations([annotationSearch], animated: true)
        mapView.selectAnnotation(annotationSearch, animated: true)
    }
}

//MARK: - Get data locations
private extension MapDeliveryViewController {
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
}

//MARK: - UITextFieldDelegate
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
}

//MARK: - MKMapViewDelegate
extension MapDeliveryViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer (overlay: overlay)
        render.strokeColor = .customOrange
        render.lineWidth = 6
        return render
    }
}
