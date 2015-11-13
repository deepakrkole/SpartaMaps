
import UIKit
import CoreLocation

class ViewController: UIViewController,UISearchBarDelegate, UIScrollViewDelegate,CLLocationManagerDelegate {

    
    
    let libStr = "king library"
    let engStr = "engineering building"
    let yuhStr = "yoshihiro uchida hall"
    let unionStr = "student union"
    let bbcStr = "bbc"
    let garageStr = "south parking garage"
    var selectedTag : Int = -1
    
    //MARK: Properties
    
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var mapView: UIView!
    
    @IBOutlet weak var mapImage: UIImageView!
    
    @IBOutlet weak var yuhButtonObj: UIButton!
    @IBOutlet weak var engButtonObj: UIButton!
    @IBOutlet weak var sunionButtonObj: UIButton!
    @IBOutlet weak var southButtonObj: UIButton!
    @IBOutlet weak var bbcButtonObj: UIButton!
    
    @IBOutlet weak var libButtonObj: UIButton!
    
    @IBOutlet weak var mapLocator: UIView!
    
    @IBOutlet weak var scrollViewObj: UIScrollView!
    
    var locationManager: CLLocationManager!
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "SJSU Interactive Map";
        
       
        customizeScrollView();
        
        
        searchField.delegate = self;
        scrollViewObj.delegate = self;
        
        self.mapLocator.layer.cornerRadius = 8.0;

        self.mapLocator.alpha = 0.5;
        self.mapLocator.layer.masksToBounds = true;

        
        
        self.automaticallyAdjustsScrollViewInsets = false;
        //Start Location Manager
        getLocationManager();
        
        
    }
    
    func getLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailsView" {
            
            let detailsViewController = segue.destinationViewController as! DetailViewController;
            let model = DetailModel()
            
            switch(selectedTag)
            {
            case 0:
               
                model.buildingName = "Kings Library"
                model.address = "Dr. Martin Luther King, Jr. Library, 150 East San Fernando Street, San Jose, CA 95112"
                model.imageName = "library.jpg"
                break;
                
            case 1:
                model.buildingName = "Engineering Building"
                model.address = "San José State University Charles W. Davidson College of Engineering, 1 Washington Square, San Jose, CA 95112"
                model.imageName = "engineering.jpg"
                break;
                
            case 2:
                
                model.buildingName = "Student Union"
                model.address = "Student Union Building, San Jose, CA 95112"
                model.imageName = "sunion.jpg"
                break;
                
            case 3:
                model.buildingName = "BBC"
                model.address = "Boccardo Business Complex, San Jose, CA 95112"
                model.imageName = "bbc.jpg"
                break;
                
            case 4:
                model.buildingName = "Yoshihiro Uchida Hall"
                model.address = "Yoshihiro Uchida Hall, San Jose, CA 95112"
                model.imageName = "yuh.jpg"
                break;
                
            case 5:
                model.buildingName = "South Parking Garage"
                model.address = "San Jose State University South Garage, 330 South 7th Street, San Jose, CA 95112"
                model.imageName = "garage.jpg"
                break;
                
                
            default:
                break;
            }

            model.latitude = latitude
            model.longitude = longitude
            detailsViewController.model = model
                        
        }
        
        
        print("selected tag:  \(selectedTag)")
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
     func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate;
        latitude = locValue.latitude
        longitude = locValue.longitude

        let x = Double(self.mapView.frame.width) * (fabs(self.longitude) - 121.886478)/(121.876243 - 121.886478);
        let y = Double(self.mapView.frame.height) - (Double(self.mapView.frame.height) * (Double(fabs(self.latitude))-37.331361)/(37.338800-37.331361));
        
        //Show Location on map
        self.mapLocator.center = CGPointMake(CGFloat(x), CGFloat(y));
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }

   
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        var userLocation:CLLocation = locations[0] as! CLLocation
//        let long = userLocation.coordinate.longitude
//        let lat = userLocation.coordinate.latitude;
//        
//        print(long)
//        print(lat)
//        
//    }
    
    func customizeScrollView()
    {
        self.scrollViewObj.maximumZoomScale = 4.0;
        self.scrollViewObj.zoomScale = 1.0
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {

        
        var searchQuery: String = ""
        searchQuery =  searchBar.text!
        searchQuery = searchQuery.lowercaseString

        
        if libStr.rangeOfString(searchQuery) != nil {
            
            self.makeButtonVisible(self.libButtonObj)
            
        }
        else if engStr.rangeOfString(searchQuery) != nil {
            
            self.makeButtonVisible(self.engButtonObj)
            
        }
        else if yuhStr.rangeOfString(searchQuery) != nil {
            
            self.makeButtonVisible(self.yuhButtonObj)
           
        }
        else if unionStr.rangeOfString(searchQuery) != nil {
            self.makeButtonVisible(self.sunionButtonObj)
            
        }
        else if bbcStr.rangeOfString(searchQuery) != nil {
            self.makeButtonVisible(self.bbcButtonObj)
            
        }
        else if garageStr.rangeOfString(searchQuery) != nil {
            self.makeButtonVisible(self.southButtonObj)
           
        }
        else
        {
            scrollViewObj.zoomScale = 1.0
            scrollViewObj.contentOffset = CGPoint(x: 10, y: 0)
            
            hideButton(libButtonObj)
            hideButton(yuhButtonObj)
            hideButton(southButtonObj)
            hideButton(engButtonObj)
            hideButton(bbcButtonObj)
            hideButton(sunionButtonObj)
        }
        
        
        
    }
    
    func makeButtonVisible(button: UIButton)
    {
        let cornerRadius : CGFloat = 5.0
        
        scrollViewObj.zoomToRect(button.frame, animated: true);
        
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.cornerRadius = cornerRadius
        button.transform = CGAffineTransformMakeRotation(CGFloat(5.74213));
        [self.mapView .bringSubviewToFront(button)];

    }
    
    func hideButton(button: UIButton)
    {
        button.layer.borderColor = UIColor.clearColor().CGColor
        button.layer.borderWidth = 0.0
        button.layer.cornerRadius = 0.0
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {

        return self.mapView;
    }
    
   
    @IBAction func onClick(sender: UIButton) {
        
        selectedTag = sender.tag
        
        performSegueWithIdentifier("showDetailsView", sender: self);
        
        
    }
        
   
}

