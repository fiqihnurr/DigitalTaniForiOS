//
//  AspirasiModel.swift
//  digitalTani
//
//  Created by FiqihNR on 9/19/17.
//  Copyright © 2017 FiqihNR. All rights reserved.
//

import UIKit

class AspirasiModel {
    let aspirasi_id: Int
    let nama: String?
    var isi: String
    let postDate: String?
    var user_id: Int
    let total_pendukung: Int
    let imageUser: String?
    
    init(aspirasi_id:Int, nama:String, isi:String, postDate:String, user_id:Int, total_pendukung: Int, imageUser: String) {
        self.aspirasi_id = aspirasi_id
        self.nama = nama
        self.isi = isi
        self.postDate = postDate
        self.user_id = user_id
        self.total_pendukung = total_pendukung
        self.imageUser = imageUser
    }
    
    func postAspirasi(isi:String,user_id:Int) {
        self.isi = isi
        self.user_id = user_id
    }
    
}
