//
//  ViewController.swift
//  Stocks
//
//  Created by Андрей Самаренко on 13.12.2020.
//

import UIKit
import Foundation



class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.companies.keys.count
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        requestList()
        // Do any additional setup after loading the view.
        
        self.companyPickerView.dataSource = self
        self.companyPickerView.delegate = self
        
        self.activityIndicator.hidesWhenStopped = true
        
        self.requestQuoteUpdate()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(self.companies.keys)[row]
    }

    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyPickerView: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var companySymbolLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    
    
    private var companies: [String:String] = ["Apple":"AAPL",
    "Microsoft":"MSFT",
    "Google":"GOOG",
    "Amazon":"Amazon",
    "Facebook":"FB"]
    
    private func requestQuote(for symbol: String){
        let url = URL(string: "https://cloud.iexapis.com/v1/stock/\(symbol)/quote?token=pk_d5beea434b71472687e9ca7f3df563e0")!
        let dataTask = URLSession.shared.dataTask(with: url){data, response, error in
           guard
            error == nil,
            (response as? HTTPURLResponse)?.statusCode == 200,
            let data = data
           else{
            print("!Network error")
            return
           }
            self.parseQuote(data: data)
        }
        dataTask.resume()
    }
    private func requestImage(for symbol: String){
        let url = URL(string: "https://cloud.iexapis.com/v1/stock/\(symbol)/logo?token=pk_d5beea434b71472687e9ca7f3df563e0")!
        let secondTask = URLSession.shared.dataTask(with: url){data, response, error in guard
            error == nil,
            (response as? HTTPURLResponse)?.statusCode == 200,
            let data = data
        else{
            print("ImageError!")
            return
        }
        self.parseImage(data: data)
        }
        secondTask.resume()
    }
    
    private func parseImage(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String:Any],
                let urlToImage = json["url"] as? String
                else{
                    print("Invalid JSON format!")
                    return
                }
                DispatchQueue.main.async {
                    self.displayImage(url: urlToImage)
                }
            }catch{
                print("JSON parsing error: " + error.localizedDescription)
            }
                
    }
    
    private func parseQuote(data: Data){
        do{
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let json = jsonObject as? [String:Any],
                let companyName = json["companyName"] as? String,
                let companySymbol = json["symbol"] as? String,
                let price = json["latestPrice"] as? Double,
                let priceChange = json["change"] as? Double
            else{
                print("Invalid JSON format!")
                return
            }
            DispatchQueue.main.async {
                self.displayStockInfo(companyName: companyName, symbol: companySymbol,
                                      price: price,
                                      priceChange: priceChange)
            }
        }catch{
            print("JSON parsing error: " + error.localizedDescription)
        }
    }
    
    private func displayStockInfo(companyName: String,
                                  symbol: String, price: Double, priceChange: Double){
        self.activityIndicator.stopAnimating()
        self.companyNameLabel.text = companyName
        self.companySymbolLabel.text = symbol
        
        if(priceChange > 0){
            self.priceChangeLabel.textColor = UIColor.green
        }
        if(priceChange == 0){
            self.priceChangeLabel.textColor = UIColor.black
        }
        if(priceChange < 0){
            self.priceChangeLabel.textColor =
                UIColor.red
        }
        self.priceChangeLabel.text = "\(priceChange)"
        self.priceLabel.text = "\(price) $"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.requestQuoteUpdate()
    }
    
    private func requestQuoteUpdate(){
        self.activityIndicator.startAnimating()
        self.companyNameLabel.text = "-"
        self.companySymbolLabel.text="-"
        self.priceChangeLabel.text = "-"
        self.priceLabel.text = "-"
        
        
        
        let selectedRow = self.companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = Array(self.companies.values)[selectedRow]
        self.requestQuote(for: selectedSymbol)
        self.requestImage(for: selectedSymbol)
        
    }
    
    @IBOutlet weak var image: UIImageView!
    
    private func displayImage(url: String){
        let url = URL(string: url)

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.image.image = UIImage(data: data!)
            }
        }
    }
    
    private func requestList(){
        let url = URL(string: "https://cloud.iexapis.com/stable/stock/market/list/mostactive?token=pk_d5beea434b71472687e9ca7f3df563e0")!
        let thirdTask = URLSession.shared.dataTask(with: url){data, response, error in guard
            error == nil,
            (response as? HTTPURLResponse)?.statusCode == 200,
            let data = data
        else{
            print("ListError!")
            return
        }
            self.fillList(data: data)
        }
        thirdTask.resume()
       
    }
    
    private func fillList(data: Data){
        var companies1 = [String: String]()
        do{
           
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            
            guard
                let array = jsonObject as? Array<[String:Any]>
            else{
                print("Invalid JSON format!")
                return
            }
            for i in array{
                let company = i["companyName"] as? String
                let symbol = i["symbol"] as? String
                companies1[company ?? "unresolved"] = symbol
            }
            
        }catch{
            print("JSON parsing error: " + error.localizedDescription)
        }
        self.companies = companies1
    }
}

