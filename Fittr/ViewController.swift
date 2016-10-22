//
//  ViewController.swift
//  Fittr
//
//  Created by Aditya Maru on 2016-10-21.
//  Copyright © 2016 Aditya Maru. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate {
    @IBOutlet weak var profilePicture: UIImageView!

    @IBAction func selectPic(_ sender: AnyObject) {
        selectPicture();

    }
    @IBAction func stripeButton(_ sender: AnyObject) {
        }
    @IBOutlet weak var gymInput: UITextField!
    @IBOutlet weak var pickerMenu: UIPickerView!
    @IBOutlet weak var nameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        profilePicture.clipsToBounds = true;
        profilePicture.layer.borderWidth = 1.0;
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.white.cgColor
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        <#code#>
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
//            Alamofire.upload(jpegData, to: "35.161.109.99:4900/upload").responseJSON { response in
//                debugPrint(response)
//            }
            profilePicture.image = UIImage(data: jpegData)
            DispatchQueue.global().async {
                self.send2Server();
            }
            profilePicture.layer.cornerRadius = (profilePicture.image?.size.width)!/2

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
