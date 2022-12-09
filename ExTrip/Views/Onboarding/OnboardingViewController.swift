//
//  OnboardingViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 08/12/2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Data of onboarding
    private let dataOnboarding = [
        OnboardingModel(title: "Discorver New Destination",
                        subtitle: "Where to go in 2022? Discover new destination around you! Top travel destination with Ex.Trip 2022.", 
                        backgroundImage: "onboarding1"),
        OnboardingModel(title: "Best Flight Booking Service",
                        subtitle: "Where to go in 2022? Discover best flight deal around you! Top airlines airbus is ready for you.",
                        backgroundImage: "onboarding2"),
        OnboardingModel(title: "Explore Best Restaurants",
                        subtitle: "Where to go in 2022? Discover Restaurants around you! Top restaurants is waiting for you.",
                        backgroundImage: "onboarding3"), 
        OnboardingModel(title: "Discover World Best Events",
                        subtitle: "Where to go in 2022? Discover World Best Events around you! Let book your seat.",
                        backgroundImage: "onboarding4")
    ]
    
    // MARK: - Properties
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = UIColor.theme.serenade
        collection.bounces = false
        collection.bouncesZoom = false
        return collection
    }()
    
    private let pageControll: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.page = 0
        pageControl.pageIndicatorTintColor = UIColor.theme.gray
        return pageControl
    }()
    
    private lazy var startButton = ETGradientButton(title: .start, style: .mysticBlue)
    private lazy var nextButton = ETGradientButton(title: .next, style: .mysticBlue)
    private lazy var skipButton = ETGradientButton(title: .skip, style: .small)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        updateActionButton(true)
        setupActionButton()
    }
    
    private func setupViews() {
        view.insertSubview(collectionView, at: 0)
        view.addSubviews(nextButton,
                         startButton, 
                         skipButton, 
                         pageControll)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCollectionViewCell.self, 
                                forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        
        setupConstraintViews()
    }
    
    private func setupConstraintViews() {
        collectionView.fillAnchor(view)
                
        skipButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingBottom: 50,
                          paddingLeading: 38,
                          paddingTrailing: 38)
        
        nextButton.anchor(bottom: skipButton.topAnchor, 
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           paddingBottom: 10,
                           paddingLeading: 38,
                           paddingTrailing: 38)
        nextButton.setHeight(height: 60)

        startButton.anchor(bottom: skipButton.topAnchor, 
                           leading: view.leadingAnchor,
                           trailing: view.trailingAnchor,
                           paddingBottom: 10,
                           paddingLeading: 38,
                           paddingTrailing: 38)
        startButton.setHeight(height: 60)
        
        pageControll.anchor(bottom: startButton.topAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            paddingBottom: 20)
    }
    
    private func updateActionButton(_ bool: Bool) {
        skipButton.isHidden = !bool
        nextButton.isHidden = !bool
        startButton.isHidden = bool
    } 
    
    private func showItem(in index: Int) {
        pageControll.page = index
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath,
                                    at: .centeredHorizontally,
                                    animated: true)
        updateActionButton(index != dataOnboarding.count - 1)
    }
    
    private func setupActionButton() {
        skipButton.addTarget(self, action: #selector(handleSkipButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(handleNextButton), for: .touchUpInside)
        pageControll.addTarget(self, action: #selector(handleChangeValuePageControl), for: .valueChanged)
        startButton.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataOnboarding.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
        let data = dataOnboarding[indexPath.row]
        cell.configOnboarding(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        pageControll.page = page
        updateActionButton(page != dataOnboarding.count - 1)
    }
}

// MARK: - Handle action of button
extension OnboardingViewController {
    
    @objc func handleSkipButton() {
        navigationToMainScreen()
    }
    
    @objc func handleChangeValuePageControl() {
        showItem(in: pageControll.currentPage)
    }
    
    @objc func handleNextButton() {
        pageControll.page += 1
        showItem(in: pageControll.currentPage)
    }
    
    @objc func handleStartButton() {
        navigationToMainScreen()
    }
    
    private func navigationToMainScreen() {
        let vc = MainViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }

}

// MARK: - Extension page control
fileprivate extension UIPageControl {
    var page: Int { 
        get {
            return currentPage
        }
        set {
            currentPage = newValue
        }
    }
}
