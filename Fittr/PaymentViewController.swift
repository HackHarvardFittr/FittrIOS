//
//  PaymentViewController.swift
//  Fittr
//
//  Created by Arpit Hamirwasia on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import CoreMotion

let pedometer = CMPedometer()

class PaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setup Payment"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton))
        // Do any additional setup after loading the view.
        PedometerCall()
    }
    
    func PedometerCall() {
        if(CMPedometer.isStepCountingAvailable()) {
            let fromDate = Date(timeIntervalSinceNow: -86700 * 7)
            pedometer.queryPedometerData(from: fromDate, to: Date(), withHandler: { (pedodata, error) in
                print("DATA IS : \(pedodata)")
                print("STEPS IS: \(pedodata?.numberOfSteps)")
                print(error)
            })
        }
        else {
            print("Cannot retrieve pedometer info")
        }
    }
    
    func doneButton() {
        
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
