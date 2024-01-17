//
//  OnBoardingViewController4.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit

class OnBoardingViewController4: UIViewController {
    
    let stackView = UIStackView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    init(imageName: String, titleText: String, subtitleText: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = UIImage(named: imageName)
        titleLabel.text = titleText
        subtitleLabel.text = subtitleText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Colors.darkThemeColor
        style()
        layout()
    }

    private func style() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = Colors.lightThemeColor
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .body)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = Colors.lightThemeColor
        
        subtitleLabel.numberOfLines = 0
    }
    
    func layout() {
        let views = OnBoardingElements()
        views.addImageView(imageView, withTitle: titleLabel, andSubtitle: subtitleLabel, to: view)
    }
}
