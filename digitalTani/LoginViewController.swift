//
//  LoginViewController.swift
//  digitalTani
//
//  Created by FiqihNR on 9/18/17.
//  Copyright © 2017 FiqihNR. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.value(forKey: "token") != nil{
            DispatchQueue.main.async {
                let nextController = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = nextController
            }
        }
        else
        {
            print("token kosong")
            //loginButton.layer.cornerRadius = 4
            //registerButton.layer.cornerRadius = 4
        }
        
        
    }
    
    @IBAction func registerAction(_ sender: Any) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        //UIApplication.shared.beginIgnoringInteractionEvents()
    }
    //show and hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // login action
    
    let urlString = "https://ph.yippytech.com:5000/user/auth"
    @IBAction func loginAction(_ sender: Any) {
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        let parameter = ["username": usernameField.text!,"password": passwordField.text!,"login_type":"1"]
        
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        
        // setup request http
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
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
                        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dissmiss", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
                else if status_code == 200 {
                    print(json!)
                    let token = json?.value(forKey: "token") as! String
                    let userData = json?.value(forKey: "data") as! NSDictionary
                    let us_id: Int = userData.value(forKey: "user_id") as! Int
                    UserDefaults.standard.setTokenLogin(value: true, token: token, user_id: us_id)
                    
                    //go to next controller
                    DispatchQueue.main.async {
                        let nextController = self.storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
                        self.present(nextController, animated: true, completion: nil)
                    }
                }
            }
        }.resume()
    }
}

