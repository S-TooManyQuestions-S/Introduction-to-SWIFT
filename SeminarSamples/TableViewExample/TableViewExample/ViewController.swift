//
//  ViewController.swift
//  TableViewExample
//
//  Created by Андрей Самаренко on 16.10.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ObserverProtocol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData.count
    }
    func react(var1: String) -> String{
        print("reacted")
        return "done"
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vs = segue.destination as! ViewController4
        if(segue.identifier == "edit"){
            vs.delegate = self
            print("edit segue")}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
//        cell.textLabel?.text = myData[indexPath.row]
        
//        ctrl+i
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! MyTableViewCell
        
        cell.textLabel?.text = myData[indexPath.row]
        cell.mySwitcher.setOn(false, animated: true)
        
    
        
        return cell
    }
    
    
    var myData = [String]()
    var myIndex: Int?  = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        myTable.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIndentifier: "id")
        myTable.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: "id")
        self.myTable.delegate = self
        self.myTable.dataSource = self
        
        initData()
    
    }
    @IBOutlet weak var myTable: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        myIndex = indexPath.row
        return indexPath
    }
    func initData()
    {
        for i in 0...9{
            myData.append("Item N \(i)")}
    }
    
}

