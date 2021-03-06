//
//  WOFTableViewController.swift
//  WalkOfFame
//
//  Created by Jason Gresh on 10/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class WOFTableViewController: UITableViewController {
    
    var walks = [Walk]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let resourceURL = getResourceURL(from: "walk_of_fame", withExt: "json"),
        let data = getData(from: resourceURL),
            let walks = getWalks(from: data) {
            self.walks = walks
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return walks.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "WOFCellIdentifier", for: indexPath)
     
     cell.textLabel?.text = self.walks[indexPath.row].designer
     cell.detailTextLabel?.text = self.walks[indexPath.row].description
     
     return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let walk = walks[indexPath.row]
        performSegue(withIdentifier: "WOFIdentifier", sender: walk)
    }
    
    // MARK: - Get Data
    
    internal func getResourceURL(from fileName: String, withExt ext: String) -> URL? {
        let fileURL: URL? = Bundle.main.url(forResource: fileName, withExtension: ext)
        
        return fileURL
    }
    
    internal func getData(from url: URL) -> Data? {
        let fileData: Data? = try? Data(contentsOf: url)
        return fileData
    }
    
    internal func getWalks(from jsonData: Data) -> [Walk]? {
        
        do {
            let walkJSONData: Any = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let walkArrayDict = walkJSONData as? [String:Any] {
                if let allWalkArray = walkArrayDict["data"] as? [[Any]] {
                    for el in allWalkArray {
                        if let w = Walk(withArray: el) {
                            walks.append(w)
                        }
                    }
                }
            }
        }
        catch let error as NSError {
            // JSONSerialization doc specficially says an NSError is returned if JSONSerialization.jsonObject(with:options:) fails
            print("Error occurred while parsing data: \(error.localizedDescription)")
        }
        
        print("Function Array Count \(walks.count)")
        return walks
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WOFIdentifier" {
            let destination = segue.destination as? WOFViewController
            destination?.walks = sender as? Walk
        }
    }
    

}
