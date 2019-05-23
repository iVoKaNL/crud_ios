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

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    let Url = "http://localhost:8080/contacts"
    var contact : Contact = Contact()
    var sections = ["Id", "Name", "Email", "Phone"]
    var fruit = ["Orange", "Apple"]
    var vegetables = ["Test", "Test"]
    
    var index = 0
    
    var name : String = ""
    
    var id : Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

        
        // Do any additional setup after loading the view, typically from a nib.       
    }
    
    func getData() {
        let test = "\(self.Url)/\(self.id)"
        Alamofire.request(test, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                print("Success! We got weather dataaaaa")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                self.contact.id = weatherJSON["id"].intValue
                print(self.contact.id)
                self.contact.name = weatherJSON["name"].stringValue
                self.contact.email = weatherJSON["email"].stringValue
                self.contact.phone = weatherJSON["phone"].stringValue
                
                
                self.setData()
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func setData() {
        print(self.contact)
        self.nameLabel.text = "\(self.contact.id)"
        self.realNameLabel.text = self.contact.name
        self.emailLabel.text = self.contact.email
        self.phoneLabel.text = self.contact.phone
    }


}

