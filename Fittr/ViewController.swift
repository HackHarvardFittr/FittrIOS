//
//  ViewController.swift
//  Fittr
//
//  Created by Aditya Maru on 2016-10-21.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
   
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var sliderOutlet: UISlider!
    
    @IBOutlet weak var sliderAge: UILabel!
    @IBAction func slider(_ sender: AnyObject) {
        sliderAge.text = String(Int(sliderOutlet.value)) + " lbs"
    }
    
    public var workoutArray = [String]()
    public let userDefaults = UserDefaults.standard;

    @IBOutlet weak var profilePicture: UIImageView!

    @IBAction func selectPic(_ sender: AnyObject) {
        selectPicture();
        uploadButton.isHidden = true
    }
    @IBAction func stripeButton(_ sender: AnyObject) {
        var parameter:Parameters = [
            "name" : nameInput.text!,
            "gymAddress" : gymInput.text!,
            "favouriteWorkout" : workoutArray[pickerMenu.selectedRow(inComponent: 0)],
            "weight" : sliderAge.text!
            ];
        var url = "http://35.161.109.99:4900/submitprofile"
        let headers = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        //
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers) .response { (response) in
            print(response)
        }
        
    }
    @IBOutlet weak var gymInput: UITextField!
    @IBOutlet weak var pickerMenu: UIPickerView!
    @IBOutlet weak var nameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        profilePicture.clipsToBounds = true;
        profilePicture.layer.borderWidth = 1.0;
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.borderColor = UIColor.white.cgColor
        pickerMenu.delegate = self;
        pickerMenu.dataSource = self;
//        profilePicture.backgroundColor = UIColor.red
        nameInput.delegate = self
        gymInput.delegate = self
        pickerMenu.delegate = self
        sliderOutlet.value = sliderOutlet.minimumValue;
        sliderAge.text = String(Int(sliderOutlet.value)) + " lbs"
        title = "Profile Page"
        
        if(userDefaults.string(forKey: "name") != nil)
        {
            nameInput.text = userDefaults.string(forKey: "name");
        }
        
        if(userDefaults.string(forKey: "gymAddress") != nil)
        {
            gymInput.text = userDefaults.string(forKey: "gymAddress");
        }
        
        if(userDefaults.object(forKey: "pickerIndex") != nil)
        {
            pickerMenu.selectRow(userDefaults.object(forKey: "pickerIndex") as! Int, inComponent: 0, animated: true)
        }
        

        workoutArray.append("Deadlift")
        workoutArray.append("Bench Press")
        workoutArray.append("Squat")
        workoutArray.append("OH")
        workoutArray.append("Barbell Rows")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameInput.resignFirstResponder()
        gymInput.resignFirstResponder()
        userDefaults.set(nameInput.text, forKey: "name");
        userDefaults.set(gymInput.text, forKey: "gymAddress");
        print(pickerMenu.selectedRow(inComponent: 0));
        userDefaults.set(pickerMenu.selectedRow(inComponent: 0), forKey: "pickerIndex")
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return workoutArray.count;
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return workoutArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = UIImageJPEGRepresentation(image, 80) {
            profilePicture.image = UIImage(data: jpegData)
            profilePicture.layer.cornerRadius = (profilePicture.frame.size.width)/2

            DispatchQueue.global().async {
                self.send2Server();
            }
            

        }
        print("Image path is: \(imagePath)")
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func send2Server()
    {
        //Use image name from bundle to create NSData
        let image : UIImage = profilePicture.image!
        //Now use image to create into NSData format
        let imageData:NSData = UIImagePNGRepresentation(image)! as NSData
        
       
        
        let strBase64 = imageData.base64EncodedString(options: [])
        var parameter:Parameters = [
            "image" : strBase64
        ];
//        Alamofire.request("35.161.109.99:4900/upload", method: .post, parameters: parameter, encoding: URLEncoding.default)
//
        var url = "http://35.161.109.99:4900/upload"
        let headers = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
//
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headers) .response { (response) in
            print(response)
        }      }
    

}
