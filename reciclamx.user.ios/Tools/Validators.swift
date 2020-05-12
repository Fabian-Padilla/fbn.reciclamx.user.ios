//
//  Validators.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 11/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import Foundation

func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
