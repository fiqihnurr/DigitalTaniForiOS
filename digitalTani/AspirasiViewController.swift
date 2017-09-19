//
//  AspirasiViewController.swift
//  digitalTani
//
//  Created by FiqihNR on 9/18/17.
//  Copyright © 2017 FiqihNR. All rights reserved.
//

import UIKit

class AspirasiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var aspirasiTable: UITableView!
   
    let urlString = "https://ph.yippytech.com:5000/aspirasi/get"
    var aspirasis = [AspirasiModel]()
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(populateRefresher), for: UIControlEvents.valueChanged)
        aspirasiTable.addSubview(refresher)
        getAspirasiData()
        
        aspirasiTable.delegate = self
        aspirasiTable.dataSource = self
        aspirasiTable.rowHeight=UITableViewAutomaticDimension
        aspirasiTable.estimatedRowHeight=206
        navigationItem.title = "Aspirasi"
    }

    
    func getAspirasiData (){
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
                print(jsonData!)
                if jsonData?.value(forKey: "status") as! Int == 200
                {
                    let dataArray = jsonData?.value(forKey: "data") as! NSArray
                    for dataAspirasi in dataArray
                    {
                        if let aspirasiDict = dataAspirasi as? NSDictionary
                        {
                            print(aspirasiDict)
                            let aspirasiIdInt: Int = aspirasiDict.value(forKey: "aspirasi_id") as! Int
                            let nameStr: String = aspirasiDict.value(forKey: "name") as! String
                            let isiStr: String = aspirasiDict.value(forKey: "isi") as! String
                            let datePostStr: String = aspirasiDict.value(forKey: "datePost") as! String
                            let this_user_id = Int(aspirasiDict.value(forKey: "user_id") as! String)
                            let voters: Int = aspirasiDict.value(forKey: "total_pendukung") as! Int
                            let imageUrl: String = {
                                if let imageUser = aspirasiDict.value(forKey: "picture") as? String{
                                 return imageUser
                                }
                                return "default"
                            }()
                            
                            self.aspirasis.append(AspirasiModel(aspirasi_id: aspirasiIdInt, nama: nameStr, isi: isiStr, postDate: datePostStr, user_id:this_user_id!, total_pendukung: voters, imageUser: imageUrl))
                            
                            OperationQueue.main.addOperation({
                                self.aspirasiTable.reloadData()
                            })
                        }
                    }
                }
                else
                {
                    print(jsonData?.value(forKey: "message") as! String)
                }
            }
        }.resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aspirasis.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(aspirasis[indexPath.row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aspirasiCell", for: indexPath) as! AspirasiTableViewCell
        if self.aspirasis[indexPath.row].imageUser != "default" {
            let imageURL = NSURL(string: self.aspirasis[indexPath.row].imageUser!)
            let imageData = NSData(contentsOf: imageURL! as URL)
            cell.imageUser.image = UIImage(data: imageData! as Data)
        }
        
        //cell.dukungButton.setTitle("Batal Dukung", for: .normal)
        if self.aspirasis[indexPath.row].user_id == UserDefaults.standard.value(forKey: "user_id") as! Int{
            cell.dukungButton.isHidden = true
        }
        cell.totalPendukung.text = String(self.aspirasis[indexPath.row].total_pendukung)
        cell.namaUserLabel.text = self.aspirasis[indexPath.row].nama
        cell.isiAspirasiLabel.text = self.aspirasis[indexPath.row].isi
        cell.tanggalPostLabel.text = self.aspirasis[indexPath.row].postDate
        
        return (cell)
    }
    
    func populateRefresher () {
        
        getAspirasiData()
        aspirasiTable
        refresher.endRefreshing()
    }
    
}
