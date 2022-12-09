//
//  MapViewController.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-04.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Display the map for waterloo park 43.4655527,-80.5361756
        let ccCoordinate2D = CLLocationCoordinate2D(latitude: 43.4655527, longitude: -80.5361756)
        map.setRegion(MKCoordinateRegion(center: ccCoordinate2D, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
    }

}

