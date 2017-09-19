//
//  GetAspirasiDataController.swift
//  digitalTani
//
//  Created by FiqihNR on 9/19/17.
//  Copyright © 2017 FiqihNR. All rights reserved.
//

import UIKit

class GetAspirasiDataController {
    var dataArray: NSArray = []
    public func get() -> NSArray {
        let urlString = "https://ph.yippytech.com:5000/aspirasi/get"
        let url = URL(string: urlString)
        
        //setup request
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("Bearer "+UserDefaults.standard.getToken(), forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
                //print(jsonData!)
                if jsonData?.value(forKey: "status") as! Int == 200
                {
                    self.dataArray = jsonData?.value(forKey: "data") as! NSArray
                   
                    
                }
                else
                {
                    print(jsonData?.value(forKey: "message") as! String)
                }
            }
        }.resume()
     return self.dataArray
    }

}
