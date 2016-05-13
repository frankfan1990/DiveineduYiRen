//
//  FriendsModel.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/3.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit

class FriendsModel: NSObject {

    private var friendsList = [String]()
    func addFirned(name:String){
        
        friendsList.append(name)
    }
}
