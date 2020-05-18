//
//  securityEntity.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 15/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import Foundation

public struct SecurityBiz : Decodable {
    let message: String
    let data: UserBiz
    let userId : String
    let token : String
}
