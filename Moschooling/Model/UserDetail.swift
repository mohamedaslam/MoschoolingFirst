//
//  UserDetail.swift
//  MoschoollingApp
//
//  Created by Mohammed Aslam on 18/01/18.
//  Copyright © 2018 Moschoolling. All rights reserved.
//

import Foundation

struct UserDetail {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email!
        
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
