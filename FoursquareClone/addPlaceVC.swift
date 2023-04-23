//
//  addPlaceVC.swift
//  FoursquareClone
//
//  Created by Emir Türk on 13.03.2023.
//

import UIKit



class addPlaceVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var placeNameText: UITextField!
    @IBOutlet weak var placeTypeText: UITextField!
    @IBOutlet weak var placeCommentText: UITextField!
    @IBOutlet weak var placeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        placeImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if placeNameText.text != "" && placeTypeText.text != "" && placeCommentText.text != ""  {
            if let choosenImage = placeImageView.image {
                
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameText.text!
                placeModel.placeType = placeTypeText.text!
                placeModel.placeComment = placeCommentText.text!
                placeModel.placeImage = choosenImage
            }
            self.performSegue(withIdentifier: "toMapVC", sender: nil)
        }
        else {
            self.makeAlert(titleInput: "Error", messageInput: "Place name / type / comment ?")
        }
        
        
        
        
        
        
    }
    
    @objc func chooseImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let addButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(addButton)
        self.present(alert, animated: true)
    }
    
    
}
