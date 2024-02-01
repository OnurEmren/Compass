//
//  NeonView.swift
//  Compass
//
//  Created by Onur Emren on 1.02.2024.
//

import Foundation
import UIKit

class NeonView: UIView {
    var baseColor: UIColor = .purple {
        didSet {
            neonLayer.backgroundColor = baseColor.cgColor
        }
    }

    private let neonLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear
        addNeonLayer()
    }

    private func addNeonLayer() {
        neonLayer.bounds = bounds
        neonLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        neonLayer.backgroundColor = baseColor.cgColor
        neonLayer.cornerRadius = bounds.width / 2

        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = baseColor.cgColor
        animation.toValue = UIColor.white.cgColor
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        neonLayer.add(animation, forKey: "neonAnimation")

        layer.addSublayer(neonLayer)
    }
}
