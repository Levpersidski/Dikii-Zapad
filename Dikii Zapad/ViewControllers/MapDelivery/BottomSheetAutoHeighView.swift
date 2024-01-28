//
//  BottomSheetAutoHeighView.swift
//  Dikii Zapad
//
//  Created by mac on 28.01.2024.
//

import UIKit
import EasyPeasy

class BottomSheetAutoHeighView: UIView {
    
    typealias BottomSheetAutoHeighViewCloseHandler = (() -> ())?
    
    var contentInsets: UIEdgeInsets {
        return .zero
    }
    
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    private var bottomContainerConstraint: NSLayoutConstraint!
    private var offset: CGFloat = 0
    private var isClosing: Bool = false
    private var panOrigin: CGPoint = .zero
    
    private var onCloseHandlers: [BottomSheetAutoHeighViewCloseHandler] = []
    
    var onClose: (() -> ())? = nil
    
    var onManuallyClose: (() -> ())? = nil
    var canCloseFull: Bool = true
    
    var secondOffset: CGFloat = 80
    
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.addTapGesture { [weak self] _ in
            self?.onManuallyClose?()
            self?.close()
        }
        view.addPanGesture { [weak self] rec in
            self?.panDetected(rec)
        }
        view.isHidden = true
        return view
    }()
    
    private(set) lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.maskCorners(radius: 24, [.topLeft, .topRight])
        view.addPanGesture { [weak self] rec in
            self?.panDetected(rec)
        }
        return view
    }()
    
    private(set) lazy var dragView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2.5
        view.isHidden = true
        return view
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func appendOnCloseHandler(_ handler: BottomSheetAutoHeighViewCloseHandler) {
        self.onCloseHandlers.append(handler)
    }
    
    func open(offset: CGFloat = 0, inView: UIView) {
        self.offset = offset
        
        open(in: inView)
    }
    
    func close() {
        guard !isClosing else {
            return
        }
        
        isClosing = true
        
        layoutIfNeeded()
        self.bottomContainerConstraint.constant = screenHeight
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
            self.alpha = 0
        }) { _ in
            self.isClosing = false
            self.removeFromSuperview()
            self.onClose?()
            
            self.onCloseHandlers.forEach({ $0?() })
            self.onCloseHandlers.removeAll()
        }
    }
    
    private func open(in view: UIView) {
        if self.superview == nil {
            view.addSubview(self)
            self.easy.layout(Bottom(), Left(), Right())
        }
        
        layoutIfNeeded()
        self.bottomContainerConstraint.constant = -self.offset
        UIView.animate(withDuration: 0.27) {
            self.layoutSubviews()
            self.overlayView.alpha = 1
        }
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(dragView)
    }
    
    private func setupConstraints() {
        containerView.easy.layout(
            Top(),
            Left(),
            Right(),
            Bottom()
        )
        dragView.easy.layout(
            Top(11),
            CenterX(),
            Height(6),
            Width(42)
        )
        
        bottomContainerConstraint = containerView.easy.layout(Bottom(-screenHeight)).first
    }
    
    private func returnToPlace() {
        bottomContainerConstraint.constant = -offset
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        })
    }
    
    private func returnToSecondPlace() {
        bottomContainerConstraint.constant = -offset + secondOffset
        UIView.animate(withDuration: 0.27, animations: {
            self.layoutSubviews()
        })
    }

    @objc
    private func panDetected(_ recognizer: UIPanGestureRecognizer) {
        let state = recognizer.state
        switch state {
        case .possible:
            break
        case .began:
            self.panOrigin = recognizer.translation(in: containerView)
        case .changed:
            let point = recognizer.translation(in: containerView)
            let panProgress = point.y - self.panOrigin.y
            let constant = max(-offset, bottomContainerConstraint.constant + panProgress)
            
            bottomContainerConstraint.constant = constant
            
            self.panOrigin = point
        case .ended, .cancelled:
            self.panOrigin = .zero
            
            let point = recognizer.translation(in: containerView)
            let panProgress = point.y - self.panOrigin.y
            if panProgress > 50 {
                onManuallyClose?()
                
                if canCloseFull {
                    close()
                } else {
                    returnToSecondPlace()
                }
            } else {
                returnToPlace()
            }
        default:
            self.panOrigin = .zero
        }
    }
}

//MARK: - Add elements
extension BottomSheetAutoHeighView {
    @discardableResult
    func addOverlayView(color: UIColor = UIColor(red: 28, green: 29, blue: 30, alpha: 1).withAlphaComponent(0.7), interactionEnabled: Bool = true) -> Self {
        overlayView.isUserInteractionEnabled = interactionEnabled
        overlayView.backgroundColor = color
        overlayView.isHidden = false
        return self
    }
    
    @discardableResult
    func addDragView(_ color: UIColor = UIColor(hex: "#E2E6EE")) -> Self {
        dragView.backgroundColor = color
        dragView.isHidden = false
        return self
    }
    
    @discardableResult
    func addViewInStack(_ view: View)-> Self {
        stackView.addArrangedSubview(view)
        return self
    }
    
    @discardableResult
    func addViewInStack(_ view: View, withSpacing customSpacingAfterLastView: CGFloat)-> Self {
        stackView.addArrangedSubview(view)
        stackView.setCustomSpacingAfterLastView(customSpacingAfterLastView)
        return self
    }
    
    @discardableResult
    func setCustomSpacingAfterLastView(_ spacing: CGFloat) -> Self {
        stackView.setCustomSpacingAfterLastView(spacing)
        return self
    }
}
