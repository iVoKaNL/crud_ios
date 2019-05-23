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
    let Url = "http://localhost:8080/contacts"
    
    var myIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(url : Url)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
                print("Success! We got weather data")
                
                let weatherJSON : JSON = JSON(response.result.value!)
                print(weatherJSON[0])
                for n in 0...(weatherJSON.count - 1) {
                    let c = Contact()
                    c.id = weatherJSON[n]["id"].intValue
                    c.name = weatherJSON[n]["name"].stringValue
                    c.email = weatherJSON[n]["email"].stringValue
                    c.phone = weatherJSON[n]["phone"].stringValue
                    self.TableData.append(c)
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

        print(segue.identifier)
        if(segue.identifier == "showDetails") {
            // Get the index path from the cell that was tapped
            let indexPath = tableView.indexPathForSelectedRow
            // Get the Row of the Index Path and set as index
            let index = indexPath?.row
            // Get in touch with the DetailViewController
            let detailViewController = segue.destination as! ViewController
            // Pass on the data to the Detail ViewController by setting it's indexPathRow value
            detailViewController.index = index ?? 0

            detailViewController.name = TableData[index!].name

            detailViewController.id = TableData[index!].id
        }

    }
    
    @IBAction func unWindToTableViewList(sender: UIStoryboardSegue) {
        
    }

}
