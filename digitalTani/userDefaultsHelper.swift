//
//  userDefaultsHelper.swift
//  digitalTani
//
//  Created by FiqihNR on 9/18/17.
//  Copyright © 2017 FiqihNR. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setTokenLogin (value:Bool, token:String, user_id:Int){
        set(value, forKey: "isLoggedIn")
        set(token, forKey: "token")
        set(user_id, forKey: "user_id")
        synchronize()
    }
    
    func getLoginStat () -> Bool {
        return bool(forKey: "isLoggedIn")
    }
    
    func getToken () -> String {
        return string(forKey: "token")!
    }
    
    func logout () {
        removeObject(forKey: "token")
        removeObject(forKey: "isLoggedIn")
        synchronize()
    }
}
