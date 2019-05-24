//
//  AddContactViewController.swift
//  crud-json
//
//  Created by Ruben Van de Kamp on 23/05/2019.
//  Copyright © 2019 Ruben Van de Kamp. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    var name: String = ""
    var email: String = ""
    var phone: String = ""
    
    @IBOutlet weak var contactName: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var contactPhone: UITextField!
    
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var done: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            name = contactName.text!
            email = contactEmail.text!
            phone = contactPhone.text!
        }
    }
        
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
