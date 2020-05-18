//
//  userBiz.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 15/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import Foundation

public struct UserBiz : Codable {
    let _id: String?
    let email: String
    let nombreCorto = ""
    let nombres: String
    let apellidoPaterno: String
    let apellidoMaterno: String?
    let fechaNacimiento: String
    let emailValidado: Bool
    let password: String
    let fechaInsercion: String?
}
