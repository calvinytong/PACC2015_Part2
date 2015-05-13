

import UIKit
import MapKit

class AViewController: UIViewController {
    
    @IBOutlet weak var LeftMapView: MKMapView!
    
    override func viewDidLoad() {
        // 1
        let location = CLLocationCoordinate2D(
            latitude: 51.50007773,
            longitude: -0.1246402
        )
        // 2
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        LeftMapView.setRegion(region, animated: true)
        
        //3
        let annotation = MKPointAnnotation()
        //annotation.setCoordinate(location)
        annotation.coordinate = location
        annotation.title = "Joseph Z."
        annotation.subtitle = "London" + "\nEfficiency: 5" + "\nCalories: 1500" + "\nTime: 20m 3s" + "\nDistance:5.2mi"
        LeftMapView.addAnnotation(annotation)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}