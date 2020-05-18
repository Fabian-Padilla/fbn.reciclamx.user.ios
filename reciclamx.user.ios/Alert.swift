//
//  Alert.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 17/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    static func ShowBasicAlert(on vc: UIViewController, with title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
