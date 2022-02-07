//
//  DetailsViewController.swift
//  CountryCustom
//
//  Created by user on 06/02/2022.
//

import UIKit
import Foundation

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var text: String!
    var country: Country = Country()
    var dataTitles = [
        "Official name",
        "Common name",
        "Capital",
        "Area",
        "Population",
        "Currency",
        "Region",
        "TimeZone",
        "Languages",
        "GPS Pos"
    ]

    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DetailsViewCell", bundle: nil)
        detailsTableView.register(nib, forCellReuseIdentifier: "DetailsViewCell")
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsImageView.contentMode = .scaleAspectFill
        getCall()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataTitles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsViewCell", for : indexPath) as! DetailsViewCell
//        var dataTitles = [
//            "Official name",
//            "Common name",
//            "Capital",
//            "Area",
//            "Population",
//            "Currency",
//            "Region",
//            "TimeZone",
//            "Languages",
//            "GPS Pos"
//        ]
        cell.detailsTitle.text = dataTitles[indexPath.row]
        if(indexPath.row == 0) {
            cell.detailsContent.text = country.nativeName
        }
        else if(indexPath.row == 1) {
            cell.detailsContent.text = country.name
        }
        else if(indexPath.row == 2) {
            cell.detailsContent.text = country.capital
        }
        else if(indexPath.row == 3) {
            cell.detailsContent.text = country.area?.description
        }
        else if(indexPath.row == 4) {
            cell.detailsContent.text = country.population?.description
        }
        else if(indexPath.row == 5) {
            cell.detailsContent.text = country.currencies
        }
        else if(indexPath.row == 6) {
            cell.detailsContent.text = country.region
        }
        else if(indexPath.row == 7) {
            cell.detailsContent.text = country.timezones?[0]
        }
        else if(indexPath.row == 8) {
            let languageList = country.languages
            cell.detailsContent.text = languageList?.joined(separator: ",")
        }
        else if(indexPath.row == 9) {
            let cordinates : [String] = [country.latlng![0].description, country.latlng![1].description]
            cell.detailsContent.text = cordinates.joined(separator: ",")
        }
        else {
        cell.detailsContent.text = "None"
        }
        print(indexPath.row)
        return cell
    }
    
    func getCall() {
        let urlString = "https://restcountries.com/v2/name/" + text
        let encodedurlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedurlString!)
        print(urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session2 = URLSession.shared
        session2.dataTask(with: request) { [self] (data, response, error) in
        
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String : Any]] {
        
                json.forEach({ element in
                    if let name = element["name"] as? String {
                        country.name = name
                    }
                    if let nativeName = element["nativeName"] as? String? {
                        country.nativeName = nativeName
                    }

                    if let flagArray = element["flags"] as? [String: Any] {
                        if let flag = flagArray["png"] as? String {
                            country.flag = flag
                            detailsImageView.downloaded(from:country.flag!)
                        }
                    }
                    if let alpha2code = element["alpha2Code"] as? String {
                        country.alphacode = alpha2code
                    }
                    if let area = element["area"] as? Double {
                        country.area = area
                    }
                    if let capital = element["capital"] as? String {
                        country.capital = capital
                    }
                    if let population = element["population"] as? Int {
                        country.population = population
                    }
                    if let currencies = element["currencies"] as? [[String : Any]] {
                        var currencyNameArray = [String]()
                        for (_, item) in currencies.enumerated() {
                            let currencyName = item["name"] as! String
                            let currencySymbol = item["symbol"] as! String
                            let currencyNameSymbol = currencyName + "-" + currencySymbol
                            currencyNameArray.append(currencyNameSymbol)
                        }
                        country.currencies = currencyNameArray.joined(separator: ",")
                    }
                    if let region = element["region"] as? String {
                        country.region = region
                    }
                    if let timezones = element["timezones"] as? [String] {
                        country.timezones = timezones
                    }
                    if let languages = element["languages"] as? [[String : Any]] {
                        var languageArray = [String]()
                        for (_, item) in languages.enumerated() {
                            if let languageElement = item["name"] as? String {
                                languageArray.append(languageElement)
                            }
                        }
                        country.languages = languageArray
                    }
                    if let latlng = element["latlng"] as? [Double] {
                        country.latlng = latlng
                    }
                })
                DispatchQueue.main.sync {
                    self.detailsTableView.reloadData()
                }
            }
        }.resume()
    }
    
}
