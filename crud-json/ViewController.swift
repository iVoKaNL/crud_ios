//
//  ViewController.swift
//  crud-json
//
//  Created by Ruben Van de Kamp on 16/05/2019.
//  Copyright © 2019 Ruben Van de Kamp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section : Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an object of the dynamic cell "PlainCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        // Depending on the section, fill the textLabel with the relevant text
        switch indexPath.section {
        case 0:
            // Fruit Section
            cell.textLabel?.text = contacts[indexPath.row].name
            break
        case 1:
            // Vegetable Section
            cell.textLabel?.text = contacts[indexPath.row].email
            break
        default:
            break
        }
        
        // Return the configured cell
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Fruit Section
            return contacts.count
        case 1:
            // Vegetable Section
            return contacts.count
        default:
            return 0
        }
    }
    
    
    
    
    let Url = "http://localhost:8080/contacts"
    var contacts : [Contact] = []
    var sections = ["Id", "Name", "Email", "Phone"]
    var fruit = ["Orange", "Apple"]
    var vegetables = ["Test", "Test"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getData(url: Url)
       
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func getData(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! We got weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON[0])
                for n in 0...10 {
                    let c = Contact()
                    c.id = weatherJSON[n]["id"].intValue
                    c.name = weatherJSON[n]["name"].stringValue
                    c.email = weatherJSON[n]["email"].stringValue
                    c.phone = weatherJSON[n]["phone"].stringValue
                    self.contacts.append(c)
                }                
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }


}

