//
//  LocationDataManager.swift
//  Dikii Zapad
//
//  Created by mac on 19.03.2024.
//

import Foundation
import MapKit
import CoreLocation

class LocationDataManager {
    private let generalSettings = DataStore.shared.generalSettings
    static let shared = LocationDataManager()
    private init() {}
    
    var geoCoder: CLGeocoder = CLGeocoder()
    var searchLocation: [CLPlacemark] = []
    
    func cleanLocations() {
        searchLocation = []
    }
    
    func getSumDelyvery(_ distance: CLLocationDistance) -> (Double, Bool) {
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
    
    func getLocations(prefixSearch: String = "", name: String, completion: @escaping ([CLPlacemark]) -> Void) {
        let prefix = prefixSearch.isEmpty ? "" : "\(prefixSearch) "
        let updatedText = prefix + name
        getLocation(from: updatedText) { [weak self] newPlaceMarks in
            guard let newPlaceMarks = newPlaceMarks else {
                completion([])
                return
            }
            
            self?.addAndFilterLocations(placeMarks: newPlaceMarks) { [weak self] filteredPlaceMarks in
                guard let self, !filteredPlaceMarks.isEmpty else {
                    self?.cleanLocations()
                    return completion([])
                }
                
                if !prefixSearch.isEmpty {
                    let valid = filteredPlaceMarks.first?.name != prefixSearch
                    self.searchLocation = valid ? filteredPlaceMarks : []
                    completion(self.searchLocation)
                } else {
                    self.searchLocation = filteredPlaceMarks
                    completion(self.searchLocation)
                }
            }
        }
    }
    
    func buildingWay(
        startLocation: CLLocationCoordinate2D,
        endLocation: CLLocationCoordinate2D,
        transportType: MKDirectionsTransportType = .automobile,
        completion: @escaping (Error?, MKRoute?) -> Void
    ) {

        let startPoint = MKPlacemark(coordinate: startLocation)
        let endPoint = MKPlacemark(coordinate: endLocation)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startPoint)
        request.destination = MKMapItem(placemark: endPoint)
        request.transportType = transportType
        
        let direction = MKDirections(request: request)
        direction.calculate { response, error in

            guard let response = response else {
                completion(error, nil)
                return
            }
            
            if let rout = response.routes.first {
                completion(nil, rout)
            }
        }
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
    
    private func addAndFilterLocations(placeMarks: [CLPlacemark], completion: @escaping ([CLPlacemark]) -> Void) {
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
}
