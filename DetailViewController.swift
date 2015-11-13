
import UIKit

class DetailViewController: UIViewController {

    var model :DetailModel!
    
    @IBOutlet weak var buildNameLabel: UILabel!
    @IBOutlet weak var addrText: UITextView!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var buildingImage: UIImageView!
    var api_key : String = "AIzaSyBszQi2OVtp2WLjAu9bxP2PZxXeJTMkOq4"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("reached in detail view")
        buildNameLabel.text = model.buildingName
        addrText.text = model.address
        buildingImage.image = UIImage(named: model.imageName)
        
        let origin : String = String(model.latitude) + "," + String(model.longitude)
        let dest : String = model.address
        
        var url : String = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=";
        url = url + origin;
        url = url + "&destinations=" + dest;
        url = url + "&key=" + api_key;
        
        let urlConn = NSURL(string: url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!);
        
        //load asynchronously
        let task = NSURLSession.sharedSession().dataTaskWithURL(urlConn!) {(data, response, error) in

            print("response is \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
            
            let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            let json = self.convertStringToDictionary(datastring);
            let distance = json!["rows"]![0]["elements"]!![0]["distance"]!!["text"]
            let time = json!["rows"]![0]["elements"]!![0]["duration"]!!["text"]
            
            
            print(distance)
            print(time)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.distanceLabel.text = distance as? String
                self.timeLabel.text = time as? String
            });
        }
        
        task.resume()
        
        
        // http req format:
        //https://maps.googleapis.com/maps/api/distancematrix/json?origins=Seattle&destinations=San+Francisco&key=YOUR_API_KEY
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }

}
