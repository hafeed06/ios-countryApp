//
//  ViewController.swift
//  CountryCustom
//
//  Created by user on 01/01/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    


    @IBOutlet var tableView: UITableView!
    
    
    var flags : [String] = []
    var countriesname : [String] = []
    var alpha2codes : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCall()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = countriesname[indexPath.row]
        return cell
    }
    
    // getCall Function Definition
    
    func getCall() {
        let url = URL(string: "https://restcountries.com/v2/all")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { [self] (data, response, error) in
            
//            if let response = response {
//                print(response)
//            }
            
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]] {
                
                json.forEach({ element in
                    if let name = element["name"] as? String { self.countriesname.append(name)
                    }
                    if let flag = element["flag"] as? String {
                        self.flags.append(flag)
                    }
                    if let alpha2code = element["alpha2Code"] as? String {
                        self.alpha2codes.append(alpha2code)
                    }
                })
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
                
                
            }
            
        }.resume()
    }


}

