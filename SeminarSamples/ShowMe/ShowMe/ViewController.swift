//
//  ViewController.swift
//  ShowMe
//
//  Created by Андрей Самаренко on 14.10.2020.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var textToSendField: UITextField!
    
    @IBAction func showMe(_ sender: Any) {
        NSLog("User Wrote: %@", textToSendField.text!)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let messageController = segue.destination as! MessageViewController; messageController.messageData = textToSendField.text
    }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller. }
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
}

