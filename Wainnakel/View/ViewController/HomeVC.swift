//
//  ViewController.swift
//  Wainnakel
//
//  Created by Bassuni on 11/6/19.
//  Copyright © 2019 Bassuni. All rights reserved.
//

import UIKit
class HomeVC: UIViewController {
    // **************Outlet and objects****************
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var homePicProp: UIImageView!
    @IBOutlet weak var homeBtnProp: TransitionButton!
    var vm : RestaurantDetailsVM!
    //********************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        vm = RestaurantDetailsVM(_serviceAdapter: NetworkAdapter<RestaurantEnum>())
        vm.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        homeView.setGradientBackground(colorOne: UIColor(named: "ViewGradientPart1")!, colorTwo: UIColor(named: "ViewGradientPart2")!)
        // Home animation ********************
        UIView.animate(withDuration: 0.75) {
            UIView.animate(withDuration: 0.5, animations: {
                self.homeBtnProp.center.x = self.view.frame.width/2
                self.homeBtnProp.frame.origin.y -= 230
            })
            self.homePicProp.frame.origin.y -= 150
        }
    }
    @IBAction func getRestaurantDetailsDetails(_ sender: Any) {
        
        vm.fetchRestaurantDetails()
    }
    
}

extension HomeVC : RestaurantDelegate
{
    func showLoading() {
        homeBtnProp.startAnimation() //start the animation when the user tap the button
    }
    func showAlert(message: String) {
        alert(title: "validation",message: message)
    }
    func callBack()
    {
        
        homeBtnProp.stopAnimation(animationStyle: .normal, completion: {
            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "restaurantDetailsScreen") as? RestaurantDetailsVC {
                viewController.vm = self.vm
                if let navigator = self.navigationController {
                    navigator.pushViewController(viewController, animated: true)
                }
            }
        })
        
        
    }
    
    
}
