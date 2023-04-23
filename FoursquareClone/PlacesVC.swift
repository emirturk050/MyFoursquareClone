//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Emir Türk on 13.03.2023.
//

import UIKit
import Parse
class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromParse()
    }
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
            }
            else {
                if objects != nil {
                    self.placeNameArray.removeAll()
                    self.placeIdArray.removeAll()
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String {
                            if let placeId = object.objectId  {
                                self.placeIdArray.append(placeId)
                                self.placeNameArray.append(placeName)
                            }
                        }
                    }
                    self.tableView.reloadData() }
            }
        }
    }

    @objc func logoutButtonClicked(){
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
            }
            else {
                self.performSegue(withIdentifier: "toSignupVC", sender: nil)
            }
        }
    }
    @objc func addButtonClicked(){
        self.performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let addButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(addButton)
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.choosenPlaceId = selectedPlaceId
        }
    }
}
