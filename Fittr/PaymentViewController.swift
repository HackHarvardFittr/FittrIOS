//
//  PaymentViewController.swift
//  Fittr
//
//  Created by Arpit Hamirwasia on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import CoreMotion
import Alamofire

let pedometer = CMPedometer()

class PaymentViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setup Payment"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton))
        // Do any additional setup after loading the view.
    }
    
    func PedometerCall() {
        if(CMPedometer.isStepCountingAvailable()) {
            print("Sending data!")
            let fromDate = Date(timeIntervalSinceNow: -86700 * 7)
            pedometer.queryPedometerData(from: fromDate, to: Date(), withHandler: { (pedodata, error) in
                print("DATA IS : \(pedodata)")
                print("STEPS IS: \(pedodata?.numberOfSteps)")
                let parameter:Parameters = [
                    "pedometer": Int((pedodata?.numberOfSteps)!),
                    "userid" : self.userDefaults.string(forKey: "userid")!
                ];
                let url = "http://35.161.109.99:4900/appstart"
                let headers = [
                    "Content-Type" : "application/x-www-form-urlencoded"
                ]
                Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers) .responseString { (checkIn) in
                    print("Sent data!")
                }
            })
        }
        else {
            print("Cannot retrieve pedometer info")
        }
    }
    
    func doneButton() {
        var landingPage = LandingPageViewController()
        self.navigationController?.pushViewController(landingPage, animated: true)
        PedometerCall()
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
