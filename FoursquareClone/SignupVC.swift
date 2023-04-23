//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Emir Türk on 12.03.2023.
//

import UIKit
import Parse
class SignupVC: UIViewController {

    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
    }

    @IBAction func signupClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != ""{
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            user.signUpInBackground { success, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }
                else {
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Username / Password ?")
        }
        
    }
    
    @IBAction func signinClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { user, error in
                 
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
                }
                else {
                    // SEGUE
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
                
                    
            }
            
        }
        else {
            makeAlert(titleInput: "Error", messageInput: "Username / Password??")
        }
        
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let addButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(addButton)
        self.present(alert, animated: true)
    }
    

}
