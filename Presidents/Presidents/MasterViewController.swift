//
//  MasterViewController.swift
//  Presidents
//
//  Created by Victor on 11/6/16.
//  Copyright © 2016 Victor. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [President]()
    var filteredObjects = [President]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
       downloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = "\(object.name) Details"
            }
        }
    }

    /*
        Gets the data from the .json
    */
    func downloadData() {
        let session = URLSession.shared
        
        guard let url = NSURL(string: "https://www.prismnet.com/~mcmahon/CS321/presidents.json") else {
            showAlert(message: "Invalid URL for JSON data.")
            return
        }
        
        weak var weakSelf = self
        
        let task = session.dataTask(with: url as URL) {
            (data, response, error) in
            // The response is a NSHTTPURLResponse, so the app should check for unexpected // status codes
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse!.statusCode != 200 {
                weakSelf!.showAlert(message: "HTTP Error: status code \(httpResponse!.statusCode).")
            } else if (data == nil && error != nil) {
                weakSelf!.showAlert(message: "No data downloaded.")
            } else {
                // Download succeeded
                let array: [AnyObject]
                
                do {
                    array = try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                } catch _ {
                    weakSelf!.showAlert(message: "Unable to parse JSON data.")
                    return
                }
                
                for dictionary in array {
                    let name = dictionary["Name"] as! String
                    let number = dictionary["Number"] as! Int
                    let startDate = dictionary["Start Date"] as! String
                    let endDate = dictionary["End Date"] as! String
                    let nickName = dictionary["Nickname"] as! String
                    let politicalParty = dictionary["Political Party"] as! String
                    let url = dictionary["URL"] as! String
                    
                    weakSelf!.objects.append(President(name: name, number: number, startDate: startDate, endDate: endDate, nickName: nickName, politicalParty: politicalParty, url: url))
                }
                
                weakSelf!.objects.sort {
                    return $0.number < $1.number
                }
                
                DispatchQueue.main.async {
                    weakSelf!.tableView!.reloadData()
                }
            }
        }
        
        task.resume()
        
    }
    
    /*
     Show alert function, if something goes wrong
    */
    func showAlert(message: String) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    /*
     Display president info and picture in the master scene
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PresidentCell
        
            let character = objects[indexPath.row]
            
            ImageProvider.sharedInstance.imageWithURLString(urlString: character.url) {
                (image: UIImage?) in
                cell.presidentImageView!.image = image
            }
            
            cell.presidentNameLabel!.text = character.name
            cell.polPartyLabel!.text = character.politicalParty
            
            return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
}
