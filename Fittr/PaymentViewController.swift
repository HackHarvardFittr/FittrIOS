//
//  PaymentViewController.swift
//  Fittr
//
//  Created by Arpit Hamirwasia on 2016-10-22.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Setup Payment"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton))
        // Do any additional setup after loading the view.
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
