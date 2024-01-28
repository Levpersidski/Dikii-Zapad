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
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.overrideUserInterfaceStyle = .dark
        view.addLongPressGesture { [weak self] recognizer in
            self?.actionLongPressMap(recognizer)
        }
        view.delegate = self
        return view
    }()

    private lazy var gradientView: GradientView = {
        let view = GradientView()
        view.applyGradient(fromColor: .black,
                           toColor: .clear,
                           fromPoint: CGPoint(x: 0.5, y: 0),
                           toPoint: CGPoint(x: 0.5, y: 1))
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var containerForBottomSheet: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var bottomSheet: BottomSheetMapView = {
        let view = BottomSheetMapView(frame: .zero)
        view.delegate = self
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomSheet.open(inView: view)
    }
    
    private func setupView() {
        view.addSubViews(
            mapView,
            gradientView,
            testPriceLabel
        )
    }
    
    private func setupConstrains() {
        gradientView.easy.layout(
            Top(),
            Left(), Right(),
            Bottom(-50).to(view.safeAreaLayoutGuide, .top)
        )
        testPriceLabel.easy.layout(
            Top(10).to(view.safeAreaLayoutGuide, .top),
            Right()
        )
        mapView.easy.layout(
            Top(),
            Left(), Right(),
            Bottom()
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
                
                self.annotationSearch.subtitle = self.createNameLocation(from: placeMark)
                self.bottomSheet.addressTextField.text = self.createNameLocation(from: placeMark)
                
                self.bottomSheet.model = BottomSheetMapViewModel(distance: 0, price: "-", hasDiscount: false, state: .notCalculated)
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
    
   
    
//    private func cleanLocations() {
//        searchLocation = []
////        stackView.removeAllArrangedSubviews()
//    }
}

//MARK: - display locations
private extension MapDeliveryViewController {

    
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
                completion(Array(oldPlaceMarks.prefix(1)))
            }
        }
    }
    
    func buildingWay() {
        mapView.removeOverlays(mapView.overlays)
        
        let startPoint = MKPlacemark(coordinate: shopAnnotation.coordinate)
        let endPoint = MKPlacemark(coordinate: annotationSearch.coordinate)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        direction.calculate { [weak self] response, error in
            guard let self else { return }

            guard let response = response else {
                self.showAlert("Ошибка",
                                message: "Не удалось построить маршрут",
                                showCancel: true,
                                cancelTitle: "Закрыть",
                                okTitle: "Повторить",
                                present: true,
                                completion: { [weak self] in self?.buildingWay() })
                return
            }
            
            if let rout = response.routes.first {
                self.mapView.addOverlay(rout.polyline)
                
                let region = MKCoordinateRegion(center: rout.polyline.coordinate, latitudinalMeters: rout.distance + 50, longitudinalMeters: rout.distance + 50)
                
                self.mapView.setRegion(region, animated: true)
                
//                self.bottomSheet.addressTextField.text = createNameLocation(from: )
                let distance = rout.distance
                let cordage = self.testCalculateSum(distance: distance)
                let value = cordage.0
                let hasSale = cordage.1
                
                let price: String
                if value == 9999 {
                    price = "НЕ ВЕЗЕМ!"
                } else {
                    price = "\(value) ₽ \(hasSale ? "Скидка от 700 ₽" : "")"
                }
                
                let modelBottomSheet = BottomSheetMapViewModel(
                    distance: distance,
                    price: price,
                    hasDiscount: cordage.1,
                    state: .notCalculated
                )
                
                self.bottomSheet.model = modelBottomSheet
            }
        }
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

//MARK: - BottomSheetMapViewDelegate
extension MapDeliveryViewController: BottomSheetMapViewDelegate {
 
    func cleanLocations() {
        searchLocation = []
    }
    
    func buttonDidTouch(state: BottomSheetMapState) {
        switch state {
        case .notCalculated:
            buildingWay()
        case .calculated:
            print("=-= ЧТо-то")
        }
    }
    
    func updateLocations(newText: String) {
        getLocation(from: newText) { [weak self] newPlaceMarks in
            guard let newPlaceMarks = newPlaceMarks else { return }
            
            self?.addAndFilterLocations(placeMarks: newPlaceMarks) { [weak self] filteredPlaceMarks in
                guard let self else { return }
                guard !filteredPlaceMarks.isEmpty else {
                    self.cleanLocations()
                    return
                }
                
                self.searchLocation = filteredPlaceMarks
//                self?.setStackView()
                self.bottomSheet.setStackView(locations: self.searchLocation)
            }
            
        }
    }
    
    func showSearchAnnotationWithName(placeMark: CLPlacemark) {
        mapView.removeAnnotation(annotationSearch)
        annotationSearch.subtitle = createNameLocation(from: placeMark)
        
        if let coordinate = placeMark.location?.coordinate {
            self.annotationSearch.coordinate = coordinate
            self.mapView.showAnnotations([self.annotationSearch], animated: true)
            self.mapView.selectAnnotation(self.annotationSearch, animated: true)
        }
    }
}
