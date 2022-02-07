//
//  ViewController.swift
//  CountryCustom
//
//  Created by user on 01/01/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    


    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar : UISearchBar!
    

    var countries = [Country]()
    var filteredCountries = [Country]()
    
    var flags : [String] = []
    var countriesname : [String] = []
    var alpha2codes : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib(nibName: "CoutryViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CoutryViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        getCall()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredCountries.isEmpty {
            return filteredCountries.count
        }
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var country: Country = Country()
        if !filteredCountries.isEmpty {
            country = filteredCountries[indexPath.row]
        }
        else {
            country = countries[indexPath.row]
        }

        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? DetailsViewController else {
            return
        }
        
        if let countryname = country.name {
            detailsViewController.text = countryname
            print(countryname)
        }
        
        detailsViewController.modalPresentationStyle = .fullScreen
        present(detailsViewController, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries.removeAll()
        for country in countries {
            if let countryname = country.name?.lowercased() {
                if(countryname.starts(with: searchText.lowercased())) {
                    filteredCountries.append(country)
                }
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoutryViewCell", for : indexPath) as! CoutryViewCell
        var country: Country = Country()
        if !filteredCountries.isEmpty {
            country = filteredCountries[indexPath.row]
        }
        else {
            country = countries[indexPath.row]
        }
        cell.alphacode.text = country.alphacode
        cell.countryname.text = country.name
        cell.flagimg.downloaded(from:country.flag!)
        cell.flagimg.contentMode = .scaleAspectFill
        cell.flagimg.clipsToBounds = true
        
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
                    let country = Country()
                    
                    if let name = element["name"] as? String {
                        self.countriesname.append(name)
                        country.name = name
                    }
                    if let flagArray = element["flags"] as? [String: Any] {
                        if let flag = flagArray["png"] as? String {
                            self.flags.append(flag)
                            country.flag = flag
                        }
//                        self.flags.append(flag)
                    }
                    if let alpha2code = element["alpha2Code"] as? String {
                        self.alpha2codes.append(alpha2code)
                        country.alphacode = alpha2code
                        
                    }
                    countries.append(country)
                    
                })
                
                DispatchQueue.main.sync {
                    self.tableView.reloadData()
                }
                
                
            }
            
        }.resume()
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

