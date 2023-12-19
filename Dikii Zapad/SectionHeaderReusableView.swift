//
//  SectionHeaderReusableView.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 10.10.2023.
//

import UIKit
import EasyPeasy
class SectionHeaderReusableView: UICollectionReusableView {
    var titleLabel: UILabel = {
          let label: UILabel = UILabel()
          label.textColor = .white
        label.font = UIFont(name: "Capture it", size: 34)
          label.sizeToFit()
          return label
      }()

      override init(frame: CGRect) {
          super.init(frame: frame)

          addSubview(titleLabel)

          titleLabel.easy.layout(
          CenterX(),
          Top(40),
          Bottom(25)
            
          )
     }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
}

