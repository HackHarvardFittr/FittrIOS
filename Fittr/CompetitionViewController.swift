//
//  CompetitionViewController.swift
//  Fittr
//
//  Created by Aditya Maru on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import MLVerticalProgressView
import SwiftGifOrigin
import MapKit
import Alamofire

class CompetitionViewController: UIViewController, CLLocationManagerDelegate {
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var nameB: UILabel!
    @IBOutlet weak var nameA: UILabel!
    @IBOutlet weak var imageB: UIImageView!
//    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var stepsB: UILabel!
    @IBOutlet weak var stepsA: UILabel!
    @IBOutlet weak var imageA: UIImageView!
    @IBOutlet weak var checkA: UIImageView!
    @IBOutlet weak var checkB: UIImageView!
    
    
    
    let locationManager = CLLocationManager()
    var didCallDelegate = false
    @IBAction func checkInButton(_ sender: AnyObject) {
        didCallDelegate = false
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    

    // Delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if didCallDelegate == true {
            return
        }
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        let latNum = Double(locValue.latitude)
//        let longNum = Double(locValue.longitude)
        let stringLat = "\(locValue.latitude)"
        let stringLong = "\(locValue.longitude)"
        print(stringLat)
        print(stringLong)
        userDefaults.set(stringLat, forKey: "lat")
        userDefaults.set(stringLong, forKey: "long")
        let parameter:Parameters = [
            "latitude" : stringLat,
            "longitude" : stringLong,
            "userid" : userDefaults.string(forKey: "userid")!
        ];
        let url = "http://35.161.109.99:4900/checkin"
        let headers = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        //
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers) .responseString { (checkIn) in
            print(checkIn)
            
        }
        didCallDelegate = true
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let progressView = VerticalProgressView();
        let progressView_2 = VerticalProgressView();
        progressView_2.frame = CGRect(x: 320, y: 320, width: 30, height: 150)
        progressView.frame = CGRect(x: 20, y: 320, width: 30, height: 150)
        progressView.progress = 0.5
        progressView_2.progress = 0.3
        progressView.fillDoneColor = UIColor.red;
        progressView_2.fillDoneColor = UIColor.blue;
        progressView.backgroundColor = UIColor(red: 115, green: 115, blue: 115, alpha: 1.0)
        progressView_2.backgroundColor = UIColor(red: 115, green: 115, blue: 115, alpha: 1.0);
        progressView.animationDuration = 0.7
        
        self.view.addSubview(progressView)
        self.view.addSubview(progressView_2)
        
        stepsA.layer.borderColor = UIColor.black.cgColor
        stepsB.layer.borderColor = UIColor.black.cgColor
        stepsA.layer.borderWidth = 3.0
        stepsB.layer.borderWidth = 3.0
        checkMarkSet(imageView: checkA, gone: true)
        checkMarkSet(imageView: checkB, gone: false)
        
        let url = "http://35.161.109.99:4900/stats"
        let parameters = [
            "userid" : (userDefaults.string(forKey: "userid"))!
        ]
        
        let headers = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers) .responseJSON { (stats) in
            
            var total: Float = 0.0
            var x:Float = 0.0;
            var y: Float = 0.0;
            if let result = stats.result.value
            {
                let JSON = result as! NSDictionary
                print("JSON IS: \(JSON)")
                if(JSON["error"] as! String == "true") {
                    let alertController = UIAlertController(title: "Error!", message: "You don't have a gym partner!", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                
                if let JSON2 = JSON["user"] as? Dictionary<String, Any>
                {
                    self.nameA.text = JSON2["name"] as! String
                    self.checkMarkSet(imageView: self.checkA, gone: (JSON2["goneToday"] as! Bool))
                    x = JSON2["dailySteps"] as! Float
                    let points = JSON2["dailyPoints"] as! String
                    self.stepsA.text = points
                    total = total + x;
                    let urlString = JSON2["imageURL"]
                    if let url = URL(string: urlString as! String) {
                        do {
                            let data = try Data(contentsOf: url)
                            self.imageA.image = UIImage(data: data)
                        }
                        catch {
                            print("Error")
                        }
                    }
                    
//                    progressView.progress = JSON2["dailySteps"] as! Float
                }
                
                if let JSON3 = JSON["opponent"] as? Dictionary<String, Any>
                {
                    self.nameB.text = JSON3["name"] as! String
                    self.checkMarkSet(imageView: self.checkB, gone: (JSON3["goneToday"] as! Bool))
                    y = JSON3["dailySteps"] as! Float
                    let points = JSON3["dailyPoints"] as! String
                    self.stepsB.text = points
                    total = total + y;
                    let urlString = JSON3["imageURL"]
                    if let url = URL(string: urlString as! String) {
                        do {
                            let data = try Data(contentsOf: url)
                            self.imageB.image = UIImage(data: data)
                        }
                        catch {
                            print("Error")
                        }
                    }
                }
                if(total == 0.0)
                {
                    progressView.setProgress(0.0, animated: true)
                    progressView_2.setProgress(0.0, animated: true)
                    
                }
                else
                {
                    
                
                    progressView.setProgress(x/total, animated: true)
                    progressView_2.setProgress(y/total, animated: true)
                }
            
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    func checkMarkSet(imageView: UIImageView, gone: Bool)
    {
        if(gone)
        {
            let imageCheck = UIImage(named: "tick");
            imageView.image = imageCheck;
        
        }
        else
        {
            let imageCheck = UIImage(named: "cross");
            imageView.image = imageCheck;
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
