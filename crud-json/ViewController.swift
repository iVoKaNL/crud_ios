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
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    let Url = "http://192.168.2.56:8080/contacts"
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
        changeVisibility(visible: "label")
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Do any additional setup after loading the view, typically from a nib.       
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(editing) {
            print("test")
            changeVisibility(visible: "field")

        } else {
            print("normaal")
            updateContact()
            self.realNameLabel.text = self.nameField.text!
            self.emailLabel.text = self.emailField.text!
            self.phoneLabel.text = self.phoneField.text!
            changeVisibility(visible: "label")
        }
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
        self.nameField.text = self.contact.name
        self.emailField.text = self.contact.email
        self.phoneField.text = self.contact.phone
    }
    
    func updateContact() {
        let params = [
            "name" : self.nameField.text!,
            "email" : self.emailField.text!,
            "phone" : self.phoneField.text!,
        ]
        let updateUrl = "\(self.Url)/\(self.contact.id)"
        print(params)
        Alamofire.request(updateUrl, method: .put, parameters: params, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                print("done")
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }    
    }
    
    func changeVisibility(visible:String) {
        if(visible == "label") {
            self.realNameLabel.isHidden = false
            self.emailLabel.isHidden = false
            self.phoneLabel.isHidden = false
            self.nameField.isHidden = true
            self.emailField.isHidden = true
            self.phoneField.isHidden = true
        } else if (visible == "field") {
            self.realNameLabel.isHidden = true
            self.emailLabel.isHidden = true
            self.phoneLabel.isHidden = true
            self.nameField.isHidden = false
            self.emailField.isHidden = false
            self.phoneField.isHidden = false
        }
    }


}

