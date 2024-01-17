//
//  ManageOnBoardingViewController.swift
//  Compass
//
//  Created by Onur Emren on 17.01.2024.
//

import UIKit

class ManageOnBoardingViewController: UIPageViewController, Coordinating {
    var coordinator: Coordinator?
    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    let initialPage = 0
    let skipButton = UIButton()
    let nextButton = UIButton()
    
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    var pageControlBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.darkThemeColor
        setup()
        style()
        layout()
    }
}

extension ManageOnBoardingViewController {
    
    func setup() {
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
        
        let page1 = OnBoardingViewController1(imageName: "page",
                                              titleText: "Hoşgeldiniz!",
                                              subtitleText: "Finansal yolculuğunuz başlamak üzere. Compass, gelir ve giderlerinizi kolayca takip etmenizi, harcamalarınızı kontrol altında tutmanızı sağlar.")
        
        let page2 = OnBoardingViewController2(imageName: "page",
                                              titleText: "Gelirlerinizi Ekleyin",
                                              subtitleText: "Başlamak için gelirinizi ekleyin. Aylık maaş, yan gelirler ve diğer gelir kaynaklarınızı buraya ekleyerek finansal durumunuzu net bir şekilde görebilirsiniz.")
        
        let page3 = OnBoardingViewController3(imageName: "page",
                                              titleText: "Harcamalarınızı Kaydedin",
                                              subtitleText: "Harcamalarınızı sektörlere ayırarak kaydedin. Bu sayede nereye ne kadar harcadığınızı anlayabilir, bütçenizi daha iyi yönetebilirsiniz.")
        
        let page4 = OnBoardingViewController4(imageName: "page",
                                              titleText: "Harcamalarınızı Kaydedin",
                                              subtitleText: "Eğer yatırımlarınız varsa, bunları burada kaydedin. Yatırımlarınızın performansını takip ederek finansal hedeflerinize daha yakından ulaşın.")
        
        let page5 = OnBoardingViewController4(imageName: "page",
                                              titleText: "Harcamalarınızı Kaydedin",
                                              subtitleText: "Compass size finansal durumunuz hakkında detaylı raporlar sunar. Ayrıca, harika finansal alışkanlıklar edinmenize yardımcı olacak ipuçları da bulabilirsiniz.")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        pages.append(page5)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
    }
    
    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .white
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
        
        setupSkipButton()
        setupNextButton()
    }
    
    private func setupSkipButton() {
        let skipButton = UIButton()
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        skipButton.setTitle("Skip", for: .normal)
        view.addSubview(skipButton)
        
        skipButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).offset(-32)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        skipButton.layer.cornerRadius = 10
        skipButton.layer.masksToBounds = true
        skipButton.setTitleColor(Colors.lightThemeColor, for: .normal)
    }
    
    private func setupNextButton() {
        
        let nextButton = UIButton()
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.setTitle("Next", for: .normal)
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(32)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        nextButton.layer.cornerRadius = 10
        nextButton.layer.masksToBounds = true
        nextButton.setTitleColor(Colors.lightThemeColor, for: .normal)
    }
    
    @objc
    private func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
    
    @objc
    private func skipTapped(_ sender: UIButton) {
        let lastPageIndex = pages.count - 1
        pageControl.currentPage = lastPageIndex
        goToSpecificPage(index: lastPageIndex, ofViewControllers: pages)
    }
    
    @objc
    private func nextTapped(_ sender: UIButton) {
        pageControl.currentPage += 1
        goToNextPage()
    }
    
    private func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    private func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    private func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        coordinator?.eventOccured(with: .goToHomeVC)
    }
    
    private func layout() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        view.addSubview(skipButton)
        
        pageControl.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(20)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}

extension ManageOnBoardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else  {
            return nil
        }
        
        if currentIndex == 0 {
            return pages.last
        } else {
            return pages[currentIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else  {
            return nil
        }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }
    }
}

extension ManageOnBoardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewControllers = pageViewController.viewControllers else {
            return
        }
        
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else {
            return
        }
        
        pageControl.currentPage = currentIndex
        
    }
}

