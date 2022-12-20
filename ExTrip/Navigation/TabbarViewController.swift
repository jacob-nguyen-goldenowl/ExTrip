//
//  TabbarViewController.swift
//  ExTrip
//
//  Created by Nguyễn Hữu Toàn on 14/12/2022.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    // MARK: - Setup tabbar
    func setupTabbar() {
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = UIColor.theme.tertiarySystemFill
        tabBar.tintColor = UIColor.theme.lightBlue
        changeRadiusOfTabbar()
        changeUnSelectedColor()
        
        let home = HomeViewController()
        let favorite = FavoriteViewController()
        let booking = BookingViewController()
        let profile = ProfileViewController()
        
        let vc1 = createTabbarController(home, image: UIImage(named: "home"))
        let vc2 = createTabbarController(favorite, image: UIImage(named: "favorite"))
        let vc3 = createTabbarController(booking, image: UIImage(named: "booking"))
        let vc4 = createTabbarController(profile, image: UIImage(named: "user"))
        
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
    
    // MARK: - Change radius
    func changeRadiusOfTabbar() {
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    // MARK: - Change color selected
    func changeUnSelectedColor() {
        tabBar.unselectedItemTintColor = .black
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        changeHeightOfTabbar()
    }
    // MARK: - Change height
    func changeHeightOfTabbar() {
        if UIDevice().userInterfaceIdiom == .phone {
            var tabFrame = tabBar.frame
            tabFrame.size.height = 100
            tabFrame.origin.y = view.frame.size.height - 90
            tabBar.frame = tabFrame
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        createAnimationWhenSelectItem(item)
    }
    
    // MARK: - Create animation
    func createAnimationWhenSelectItem(_ item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        let timeInterval: TimeInterval = 0.6
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.6) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }
        propertyAnimator.addAnimations({barItemView.transform = CGAffineTransform.identity }, delayFactor: timeInterval)
        propertyAnimator.startAnimation()
    }
    
    // MARK: - Create tabbar
    private func createTabbarController(_ view: UIViewController,
                                        title: String? = nil, 
                                        image: UIImage?,
                                        selectedImage: UIImage? = nil) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: view)
        navigation.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        return navigation
    }

}
