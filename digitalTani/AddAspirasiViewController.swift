//
//  AddAspirasiViewController.swift
//  digitalTani
//
//  Created by FiqihNR on 9/19/17.
//  Copyright © 2017 FiqihNR. All rights reserved.
//

import UIKit

class AddAspirasiViewController: UIViewController {

    @IBOutlet weak var sendAspirasiButton: UIButton!
    @IBOutlet weak var isiAspirasiField: UITextField!
    let urlString = "https://ph.yippytech.com:5000/aspirasi/add"
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendAspirasiButton.layer.cornerRadius = 4
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendAspirasiAction(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let parameter = ["isi": isiAspirasiField.text!,"user_id": UserDefaults.standard.value(forKey: "user_id")]
        
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        // setup request http
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+UserDefaults.standard.getToken(), forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameter, options: [])
        
        //setup session
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response{
                print(response)
            }
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                let status_code = json?.value(forKey: "status") as! Int
                let message = json?.value(forKey: "message") as! String
                print(status_code)
                
                if status_code != 200
                {
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Add Failed", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dissmiss", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
                else if status_code == 200 {
                    print(json!)
                    
                    
                    //go to next controller
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        let nextController = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
                        self.present(nextController, animated: true, completion: nil)
                    }
                }
            }
            }.resume()
    }
  
}
