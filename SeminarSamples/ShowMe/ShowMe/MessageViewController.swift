//
//  MessageViewController.swift
//  ShowMe
//
//  Created by Андрей Самаренко on 14.10.2020.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = messageData
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var messageData: String?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
