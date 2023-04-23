//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Emir Türk on 17.03.2023.
//

import UIKit
import MapKit
import Parse
class DetailsVC: UIViewController, MKMapViewDelegate {

   
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsCommentLabel: UILabel!
    @IBOutlet weak var detailsMapView: MKMapView!
    var choosenPlaceId = ""
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    override func viewDidLoad() {
        super.viewDidLoad()

       getDataFromParse()
        detailsMapView.delegate = self
    }
    
    
    func getDataFromParse() {
        let query = PFQuery(className: "Places")
         query.whereKey("objectId", equalTo: choosenPlaceId)
         query.findObjectsInBackground { objects, error in
             if error != nil {
                 self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription)
             }
             else {
                 if objects != nil {
                     if objects!.count > 0 {
                         
                         // GET OBJECTS
                         let choosenPlaceObject = objects![0]
                         
                         if let placeType = choosenPlaceObject.object(forKey: "type") as? String {
                             self.detailsTypeLabel.text = placeType
                         }
                         if let placeName = choosenPlaceObject.object(forKey: "name") as? String {
                             self.detailsNameLabel.text = placeName
                         }
                         if let placeComment = choosenPlaceObject.object(forKey: "comment") as? String {
                             self.detailsCommentLabel.text = placeComment
                         }
                         if let placeLatitude = choosenPlaceObject.object(forKey: "latitude") as? String {
                             if let placeLatitudeDouble = Double(placeLatitude) {
                                 self.choosenLatitude = placeLatitudeDouble
                                 
                             }
                             
                             
                         }
                         if let placeLongitude = choosenPlaceObject.object(forKey: "longitude") as? String {
                             if let placeLongitudeDouble = Double(placeLongitude) {
                                 self.choosenLongitude = placeLongitudeDouble
                                 
                             }
                         }
                         if let imageData = choosenPlaceObject.object(forKey: "image") as? PFFileObject {
                             imageData.getDataInBackground { data, error in
                                 if error == nil {
                                     if data != nil {
                                         self.detailsImageView.image = UIImage(data: data!)
                                     }
                                 }
                             }
                         }
                         
                         // MAPS
                         let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                         let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                         let region = MKCoordinateRegion(center: location, span: span)
                         self.detailsMapView.setRegion(region, animated: true)
                         
                         let annotation = MKPointAnnotation()
                         annotation.coordinate = location
                         annotation.title = self.detailsNameLabel.text!
                         annotation.subtitle = self.detailsTypeLabel.text!
                         self.detailsMapView.addAnnotation(annotation)
                     }
                     
                 }
             }
         }
    }

    func makeAlert(titleInput : String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let addButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(addButton)
        self.present(alert, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLongitude != 0.0 && self.choosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}
