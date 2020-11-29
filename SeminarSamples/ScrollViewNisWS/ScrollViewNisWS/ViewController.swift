//
//  ViewController.swift
//  ScrollViewNisWS
//
//  Created by Андрей Самаренко on 30.10.2020.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var sv: UIScrollView! = UIScrollView(frame: UIScreen.main.bounds)
    
    @IBAction func buttonAction(sender: UIButton!){
        print(sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = self.sv
        
        sv.delegate = self
        //нужно ли скролить?
        sv.isScrollEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let borderH: CGFloat = 20.0
        var sumH: CGFloat = 0.0
        
        var cnt = 30
        for i in 0..<cnt{
            let h:CGFloat = 50.0
            let size = CGSize(width: UIScreen.main.bounds.width, height: h)
            let page = createLabelPage(size: size, text: "Friday, Oktober, 30th", tag: i)
            //динамически заполняем scrollview и изменяем размер
            page.frame.origin.y = sumH
            sv.addSubview(page)
            sumH += h + borderH
        }
        
    }
    
    func createLabelPage(size: CGSize, text: String, radius:CGFloat = 20, tag: Int = -1) -> UIView{
        let aFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let aLabel = UILabel(frame: aFrame)
        //перенос слов елси есть необходимость
        aLabel.lineBreakMode = .byWordWrapping
        //сделает столько строк, сколько нужно
        aLabel.numberOfLines = 0
        aLabel.translatesAutoresizingMaskIntoConstraints
        = false
        aLabel.layer.cornerRadius = radius
        aLabel.layer.masksToBounds = true
        aLabel.backgroundColor = .darkGray
        aLabel.font = aLabel.font.withSize(24)
        aLabel.textAlignment = .center
        aLabel.textColor = .white
        aLabel.text = text
        
        aLabel.tag = (tag >= 0) ? tag : aLabel.tag
        return aLabel
    }

}

