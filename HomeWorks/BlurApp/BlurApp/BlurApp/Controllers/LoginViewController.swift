//
//  ViewController.swift
//  BlurApp
//
//  Created by Андрей Самаренко on 05.02.2021.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet var backgroundImageView:UIImageView!
    
    let imageSet = ["battlefield", "avatar","stop"]
    var blurEffectView: UIVisualEffectView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let selectedImageIndex = Int(arc4random_uniform(3))
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        blurEffectView?.frame = view.bounds
    }


}

