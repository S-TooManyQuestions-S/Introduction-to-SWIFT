//
//  MyTableViewCell.swift
//  TableViewExample
//
//  Created by Андрей Самаренко on 16.10.2020.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var mySwitcher: UISwitch!
    
    @IBAction func mySwitcherPressed(_ sender: Any) {
        print("Switcher pressed")
        
    }
    
    @IBOutlet weak var myLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
