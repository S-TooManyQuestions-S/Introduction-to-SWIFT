//
//  ViewController.swift
//  FancyButton
//
//  Created by Андрей Самаренко on 06.02.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

@IBDesignable
extension FancyButton : UIButton{
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
    didSet {
    layer.cornerRadius = cornerRadius
    layer.masksToBounds = cornerRadius > 0
    }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0 {
    didSet {
    layer.borderWidth = borderWidth
    }
    }
    @IBInspectable var borderColor: UIColor = .black {
    didSet {
    layer.borderColor = borderColor.cgColor
    }
    }
}

