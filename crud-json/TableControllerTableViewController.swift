//
//  TableControllerTableViewController.swift
//  crud-json
//
//  Created by Ruben Van de Kamp on 22/05/2019.
//  Copyright © 2019 Ruben Van de Kamp. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ContactTableViewCell:UITableViewCell {
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
}


class TableControllerTableViewController: UITableViewController {

    var TableData:Array<Contact> = Array<Contact>()
    let Url = "http://192.168.2.56:8080/contacts"
    var newContact : Contact = Contact()
    
    var myIndex = 0
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshContacts),
                                 for: .valueChanged)
        
        return refreshControl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(url : Url)
        
        tableView.refreshControl = refresher

        if #available(iOS 10.0, *) {
            tableView.refreshControl = refresher
        } else {
            tableView.addSubview(refresher)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc
    func refreshContacts() {
        getData(url: self.Url)
        let deadline = DispatchTime.now() + .milliseconds(1000)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
    }
 
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("count")
        return TableData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
//        cell.textLabel?.text = "\(TableData[indexPath.row].name) - \(TableData[indexPath.row].email)"
        cell.contactNameLabel?.text = "\(TableData[indexPath.row].name)"
        cell.contactEmailLabel?.text = "\(TableData[indexPath.row].email)"
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteContact(id: TableData[indexPath.row].id)
            TableData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    func getData(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                self.TableData.removeAll()
                for n in 0...(weatherJSON.count - 1) {
                    let c = Contact()
                    c.id = weatherJSON[n]["id"].intValue
                    c.name = weatherJSON[n]["name"].stringValue
                    c.email = weatherJSON[n]["email"].stringValue
                    c.phone = weatherJSON[n]["phone"].stringValue
                    self.TableData.append(c)
                    print("get")
                }
                DispatchQueue.global(qos: .userInitiated).async {
                    // Bounce back to the main thread to update the UI
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "showDetails") {
            // Get the index path from the cell that was tapped
            let indexPath = tableView.indexPathForSelectedRow
            // Get the Row of the Index Path and set as index
            let index = indexPath?.row
            // Get in touch with the DetailViewController
            let detailViewController = segue.destination as! ViewController
            // Pass on the data to the Detail ViewController by setting it's indexPathRow value
            detailViewController.id = TableData[index!].id
        }

    }
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func done(segue:UIStoryboardSegue) {
        print("done segue started")
        let addContactVC = segue.source as! AddContactViewController
        newContact.name = addContactVC.name
        newContact.email = addContactVC.email
        newContact.phone = addContactVC.phone
        addContact()
    }
    
    public func addContact() {
        let parameters = [
            "name" : newContact.name,
            "email" : newContact.email,
            "phone" : newContact.phone,
        ]
        Alamofire.request(self.Url, method:.post, parameters: parameters, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                print("Succesvol toegevoegd")
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
        self.tableView.reloadData()
    }
    
    public func deleteContact(id:Int) {
        let deleteUrl = "\(self.Url)/\(id)"
        print(deleteUrl)
        Alamofire.request(deleteUrl, method:.delete, encoding: JSONEncoding.default).responseJSON {
            response in
            if response.result.isSuccess {
                print("Succesvol toegevoegd")
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        getData(url: self.Url)
    }

}
