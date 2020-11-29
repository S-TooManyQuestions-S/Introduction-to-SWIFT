//
//  ComposeViewController.swift
//  SocialApp
//
//  Created by Андрей Самаренко on 29.11.2020.
//

import UIKit

class ComposeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissView(_ sender: Any) {
    }
    @IBOutlet weak var tweetContent: UITextView!
    
    @IBOutlet weak var postButton: UIButton!
    
    @IBAction func postToTwitter(_ sender: Any) {
    }
    
    @IBOutlet weak var postActivity: UIActivityIndicatorView!
    
    
    
    
    
    
    
    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
