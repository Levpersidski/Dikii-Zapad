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

struct UserDeliveryLocationModel {
    var address: String = ""
    var hasSale: Bool = false
    var priceDelivery: Int = 0
}

class MapDeliveryViewController: UIViewController {
    var geoCoder: CLGeocoder = CLGeocoder()
    var searchLocation: [CLPlacemark] = []
    
    var usedModel: UserDeliveryLocationModel?
    
    private let generalSettings = DataStore.shared.generalSettings
    private lazy var locationShop = CLLocationCoordinate2D(
        latitude: generalSettings?.shopLocation.latitude ?? 0,
        longitude: generalSettings?.shopLocation.longitude ?? 0
    )
    
    private lazy var shopAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.title = generalSettings?.shopLocation.title
        annotation.subtitle = generalSettings?.shopLocation.subtitle
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
        let view = BottomSheetMapView()
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupView()
        setupConstrains()
        
        usedModel = DataStore.shared.userDeliveryLocation
        
        view.addTapGesture { [weak self] _ in
            self?.view.endEditing(true)
        }
        mapView.showAnnotations([shopAnnotation], animated: true)
    }
    
    private func setupView() {
        view.addSubviews(
            mapView,
            gradientView,
            bottomSheet
        )
    }
    
    private func setupConstrains() {
        gradientView.easy.layout(
            Top(),
            Left(), Right(),
            Bottom(-50).to(view.safeAreaLayoutGuide, .top)
        )

        mapView.easy.layout(
            Top(),
            Left(), Right(),
            Bottom()
        )
        
        bottomSheet.easy.layout(
            Left(), Right(),
            Bottom()
        )
    }
    
    @objc private func actionLongPressMap(_ gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            
            self.bottomSheet.addressTextField.text = ""
            self.bottomSheet.model = BottomSheetMapViewModel(distance: 0, price: "-", hasDiscount: false, state: .notValid)

            
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let location2D = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            showSearchAnnotation(coordinate: location2D)
            geoCoder.reverseGeocodeLocation(location) { [weak self] placeMark, error in
                guard let self = self else { return }
                guard let placeMark = placeMark?.first else { return }
                
                let isValidName = Double(placeMark.name ?? "") == nil
                self.searchLocation.insert(placeMark, at: 0)
                self.annotationSearch.subtitle = self.createNameLocation(from: placeMark)
                self.bottomSheet.addressTextField.text = self.createNameLocation(from: placeMark)
                self.buildingWay(isValidName: isValidName)
            }
        }
    }
    
    private func calculateSum(distance: CLLocationDistance) -> (Double, Bool) {
        let pointDistance = generalSettings?.deliveryInfo.distances ?? []
        for point in pointDistance {
            if distance < Double(point.maxDistance) {
                ///Если входим в диапазон возвращаем значение
                return (Double(point.price), point.hasSale)
            }
        }
        ///Если не входим в диапазон возвращаем ошибку значение 9999
        return (9999, false)
    }
    
    private func createNameLocation(from placeMark: CLPlacemark) -> String {        
        let name = placeMark.name ?? ""
        return name
    }
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
    
    func buildingWay(isValidName: Bool = true) {
        let saleInfo = generalSettings?.deliveryInfo.saleInfo

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
                let distance = rout.distance
                let cordage = self.calculateSum(distance: distance)
                let value = isValidName ? cordage.0 : 9999
                let hasSale = cordage.1
                
                let price: String
                if value == 9999 {
                    price = "НЕ ВЕЗЕМ!"
                } else {
                    price = "\(value) ₽ \(hasSale ? (saleInfo?.textSale ?? "") : "")"
                }
                
                self.usedModel = UserDeliveryLocationModel(
                    address: self.annotationSearch.subtitle ?? "",
                    hasSale: hasSale,
                    priceDelivery: Int(value)
                )
                
                let modelBottomSheet = BottomSheetMapViewModel(
                    distance: distance,
                    price: price,
                    hasDiscount: hasSale,
                    state: value != 9999 ? .valid : .notValid
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
    
    func buttonDidTouch() {
        DataStore.shared.userDeliveryLocation = usedModel
        navigationController?.popViewController(animated: true)
    }
    
    func updateLocations(newText: String) {
        let searchCity = DataStore.shared.searchCity ?? ""
        let updatedText = searchCity + newText
        getLocation(from: updatedText) { [weak self] newPlaceMarks in
            guard let newPlaceMarks = newPlaceMarks else { return }
            
            self?.addAndFilterLocations(placeMarks: newPlaceMarks) { [weak self] filteredPlaceMarks in
                guard let self else { return }
                guard !filteredPlaceMarks.isEmpty else {
                    self.cleanLocations()
                    return
                }
                
                self.searchLocation = filteredPlaceMarks
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
    
    func buildingWayFromBottomSheet() {
        buildingWay()
    }
}
