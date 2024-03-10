//
//  OnBoardingVC.swift
//  Compass
//
//  Created by Onur Emren on 5.02.2024.
//

import UIKit

class OnBoardingVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, Coordinating {
    var coordinator: Coordinator?
    var pageViewController: UIPageViewController!
    var onboardingPages: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPages()

        // Create Skip Button
        let skipButton = UIBarButtonItem(
            title: "Skip",
            style: .done,
            target: self,
            action: #selector(goToHomeVC)
        )

        skipButton.tintColor = .white
        navigationItem.rightBarButtonItem = skipButton
    }

    private func setupPages() {
        // Create OnBoardingScreens
        onboardingPages = [
            createOnboardingPage(
                title: "Hoş Geldiniz",
                with: "Finansal yolculuğunuz başlamak üzere. Compass; gelir ve giderlerinizi kolayca takip etmenizi, harcamalarınızı kontrol altında tutmanızı sağlar.",
                imageName: "spiral"),

            createOnboardingPage(
                title: "Gelirlerinizi Ekleyin",
                with: "Başlamak için gelirinizi ekleyin. Aylık maaş, yan gelirler ve diğer gelir kaynaklarınızı buraya ekleyerek finansal durumunuzu net bir şekilde görebilirsiniz.",
                imageName: "spiral"),

            createOnboardingPage(
                title: "Harcamalarınızı Kaydedin",
                with: "Harcamalarınızı sektörlere ayırarak kaydedin. Bu sayede nereye ne kadar harcadığınızı anlayabilir, bütçenizi daha iyi yönetebilirsiniz.",
                imageName: "spiral"),

            createOnboardingPage(
                title: "Yatırımlarınızı Takip Edin",
                with: "Eğer yatırımlarınız varsa, bunları burada kaydedin. Yatırımlarınızın performansını takip ederek finansal hedeflerinize daha yakından ulaşın.",
                imageName: "spiral"),

            createOnboardingPage(
                title: "Raporlar ve İpuçları",
                with: "Compass size finansal durumunuz hakkında detaylı raporlar sunar. Ayrıca, harika finansal alışkanlıklar edinmenize yardımcı olacak ipuçları da bulabilirsiniz.",
                imageName: "spiral")
        ]

        // Create UIPageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        // Show the first page
        if let firstPage = onboardingPages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }

        // Add the UIPageViewController to view
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }

    // Setup the onBoarding View
    func createOnboardingPage(title: String, with content: String, imageName: String) -> UIViewController {
        let onboardingPage = UIViewController()

        // Background Image
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        imageView.translatesAutoresizingMaskIntoConstraints = false
        onboardingPage.view.addSubview(imageView)

        // Title
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = title
        onboardingPage.view.addSubview(titleLabel)

        // Text
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = content
        onboardingPage.view.addSubview(label)

        // Constraints
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        return onboardingPage
    }

    @objc private func goToHomeVC() {
        coordinator?.eventOccured(with: .goToHomeVC)
    }

    // MARK: - PageViewController Delegate and Datasource

    // UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = onboardingPages.firstIndex(of: viewController), currentIndex > 0 else {
            return nil
        }

        return onboardingPages[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = onboardingPages.firstIndex(of: viewController), currentIndex < onboardingPages.count - 1 else {
            return nil
        }

        return onboardingPages[currentIndex + 1]
    }

    // UIPageViewControllerDelegate - Optional
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardingPages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentViewController = pageViewController.viewControllers?.first else {
            return 0
        }

        return onboardingPages.firstIndex(of: currentViewController) ?? 0
    }
}
