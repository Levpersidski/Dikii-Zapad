//
//  MapDeliveryViewController.swift
//  Dikii Zapad
//
//  Created by mac on 27.01.2024.
//

import UIKit
import MapKit
//import CoreLocation
import EasyPeasy

struct UserDeliveryLocationModel {
    var address: String = ""
    var hasSale: Bool = false
    var priceDelivery: Int = 0
}

class MapDeliveryViewController: UIViewController {
    var geoCoder: CLGeocoder = CLGeocoder()
    
    private var locationManager = LocationDataManager.shared
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
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
                LocationDataManager.shared.searchLocation.insert(placeMark, at: 0)
                self.annotationSearch.subtitle = placeMark.name ?? ""
                self.bottomSheet.addressTextField.text = placeMark.name ?? ""
                self.buildingWay(isValidName: isValidName)
            }
        }
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

    func buildingWay(isValidName: Bool = true) {
        mapView.removeOverlays(mapView.overlays)
        
        locationManager.buildingWay(
            startLocation: shopAnnotation.coordinate,
            endLocation: annotationSearch.coordinate
        ) { [weak self] error, rout in
            guard let self = self, error == nil, let rout = rout else {
                self?.showAlert("Ошибка",
                                message: "Не удалось построить маршрут",
                                showCancel: true,
                                cancelTitle: "Закрыть",
                                okTitle: "Повторить",
                                present: true,
                                completion: { [weak self] in self?.buildingWay() })
                return
            }
            
            let saleInfo = self.generalSettings?.deliveryInfo.saleInfo
            self.mapView.addOverlay(rout.polyline)
            
            let cortage = self.locationManager.getSumDelyvery(rout.distance)
            let value = isValidName ? cortage.0 : 9999
            let hasSale = cortage.1
            
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
                distance: rout.distance,
                price: price,
                hasDiscount: hasSale,
                state: value != 9999 ? .valid : .notValid
            )
            
            self.bottomSheet.model = modelBottomSheet
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
        locationManager.cleanLocations()
    }
    
    func buttonDidTouch() {
        DataStore.shared.userDeliveryLocation = usedModel
        navigationController?.popViewController(animated: true)
    }
    
    func updateLocations(newText: String) {
        locationManager.getLocations(
            prefixSearch: DataStore.shared.searchCity ?? "",
            name: newText
        ) { [weak self] placeMarks in
            self?.bottomSheet.setStackView(locations: placeMarks)
        }
    }
    
    func showSearchAnnotationWithName(placeMark: CLPlacemark) {
        mapView.removeAnnotation(annotationSearch)
        annotationSearch.subtitle = placeMark.name ?? ""
        
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
