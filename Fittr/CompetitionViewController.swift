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
    @IBOutlet weak var imageB: UIImageView!
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
        let userDefaults = UserDefaults.standard
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        let latNum = Double(locValue.latitude)
//        let longNum = Double(locValue.longitude)
        let stringLat = "\(locValue.latitude)"
        let stringLong = "\(locValue.longitude)"
        print(stringLat)
        print(stringLong)
        userDefaults.set(stringLat, forKey: "lat")
        userDefaults.set(stringLong, forKey: "long")
        print("latitude is: \(userDefaults.string(forKey: "lat"))")
        print("longitude is: \(userDefaults.string(forKey: "long"))")
        let parameter:Parameters = [
            "latitude" : stringLat,
            "longitude" : stringLong
        ];
        let url = "http://35.161.109.99:4900/checkin"
        let headers = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        //
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers) .response { (response) in
            print(response)
        }
        didCallDelegate = true
    }
    
    @IBOutlet weak var stepsB: UILabel!
    @IBOutlet weak var stepsA: UILabel!
    @IBOutlet weak var imageA: UIImageView!
    @IBOutlet weak var checkA: UIImageView!
    @IBOutlet weak var checkB: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var progressView = VerticalProgressView();
        var progressView_2 = VerticalProgressView();
        progressView_2.frame = CGRect(x: 310, y: 320, width: 50, height: 150)
        progressView.frame = CGRect(x: 20, y: 320, width: 50, height: 150)
        progressView.progress = 0.5
        progressView_2.progress = 0.3
        progressView.fillDoneColor = UIColor.red;
        progressView_2.fillDoneColor = UIColor.blue;
        progressView.backgroundColor = UIColor(red: 115, green: 115, blue: 115, alpha: 1.0)
        progressView_2.backgroundColor = UIColor(red: 115, green: 115, blue: 115, alpha: 1.0);
        progressView.animationDuration = 0.7

        self.view.addSubview(progressView)
        self.view.addSubview(progressView_2)
        
        stepsA.layer.borderColor = UIColor.blue.cgColor
        stepsB.layer.borderColor = UIColor.red.cgColor
        stepsA.layer.borderWidth = 3.0
        stepsB.layer.borderWidth = 3.0
        checkMarkSet(imageView: checkA, gone: true)
        checkMarkSet(imageView: checkB, gone: false)
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
