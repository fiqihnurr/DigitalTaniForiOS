//
//  LogoutViewController.swift
//  digitalTani
//
//  Created by FiqihNR on 9/19/17.
//  Copyright © 2017 FiqihNR. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {

    @IBAction func logoutAction(_ sender: Any) {
        
        let urlString = "https://ph.yippytech.com:5000/user/logout"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("Bearer "+UserDefaults.standard.getToken(), forHTTPHeaderField: "Authentication")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                print(json!)
            }
            
        }.resume()
        UserDefaults.standard.logout()
        DispatchQueue.main.async {
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "loginDigitalTani") as! LoginViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = nextController
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
