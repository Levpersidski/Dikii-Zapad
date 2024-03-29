//
//  ContactsViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit
import EasyPeasy
import MapKit

class ContactsViewController: UIViewController {
    private let generalSettings = DataStore.shared.generalSettings
    private lazy var locationShop = CLLocationCoordinate2D(
        latitude: generalSettings?.shopLocation.latitude ?? 0,
        longitude: generalSettings?.shopLocation.longitude ?? 0
    )
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "mainImage")
        image.clipsToBounds = true
        image.alpha = 0.3
        return image
    }()
    
    private lazy var shopAnnotation: MKPointAnnotation = {
        let annotation = MKPointAnnotation()
        annotation.title = generalSettings?.shopLocation.title
        annotation.subtitle = generalSettings?.shopLocation.subtitle
        annotation.coordinate = locationShop
        return annotation
    }()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.overrideUserInterfaceStyle = .dark
        return view
    }()
    
    private lazy var titleAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Адрес"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var textAddressLabel: UILabel = {
        let label = UILabel()
        label.text = generalSettings?.contacts.address
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titlePhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "Телефон"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var numberPhoneLabel: UILabel = {
        let label = UILabel()
        let atrText = NSMutableAttributedString(
            string: generalSettings?.contacts.numberPhone.maskAsPhone() ?? "",
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue,
                         .font: UIFont.systemFont(ofSize: 18, weight: .regular),
                         .foregroundColor: UIColor(hex: "#FE6F1F")]
        )

        label.addTapGesture { [weak self] _ in
            self?.openPhoneDialer(with: self?.generalSettings?.contacts.numberPhone ?? "")
        }

        label.attributedText = atrText
        return label
    }()
    
    func openPhoneDialer(with phoneNumber: String) {
        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                       UIApplication.shared.open(phoneURL)
                   } else {
                       print("Can't open url on this device")
                   }
        }
    }

    
    private lazy var titleScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "График работы"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    private lazy var textScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = generalSettings?.contacts.textSchedule
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
        setupConstraints()
        
        mapView.showAnnotations([shopAnnotation], animated: true)
    }
}

private extension ContactsViewController {
    func setupViews() {
        view.addSubviews(
            backgroundImage,
            mapView,
            titleAddressLabel,
            textAddressLabel,
            titlePhoneLabel,
            numberPhoneLabel,
            titleScheduleLabel,
            textScheduleLabel
        )
    }
    
    func setupConstraints() {
        backgroundImage.easy.layout(
            Edges()
        )
        mapView.easy.layout(
            Top().to(view.safeAreaLayoutGuide, .top),
            Left(), Right(),
            Height(250)
        )
        titleAddressLabel.easy.layout(
            Top(40).to(mapView, .bottom),
            Left(16), Right(16)
        )
        textAddressLabel.easy.layout(
            Top(16).to(titleAddressLabel, .bottom),
            Left(16), Right(16)
        )
        titlePhoneLabel.easy.layout(
            Top(30).to(textAddressLabel, .bottom),
            Left(16), Right(16)
        )
        numberPhoneLabel.easy.layout(
            Top(30).to(titlePhoneLabel, .bottom),
            Left(16), Right(16)
        )
        titleScheduleLabel.easy.layout(
            Top(30).to(numberPhoneLabel, .bottom),
            Left(16), Right(16)
        )
        textScheduleLabel.easy.layout(
            Top(16).to(titleScheduleLabel, .bottom),
            Left(16), Right(16)
        )
    }
}
