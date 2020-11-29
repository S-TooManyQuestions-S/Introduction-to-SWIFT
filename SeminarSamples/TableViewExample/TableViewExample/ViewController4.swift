//
//  ViewController4.swift
//  TableViewExample
//
//  Created by Андрей Самаренко on 16.10.2020.
//

import UIKit

class ViewController4: UIViewController {

    var delegate : ObserverProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.react(var1: "second")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
