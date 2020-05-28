//
//  SelectMaterialMenuViewController.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 04/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class SelectMaterialMenuViewController: UIViewController {
    
    var welcomeMode: Bool = false
    
    enum buttonIdentifier {
        case pet
        case electrodomestico
        case aluminio
        case papel
        case tecnologia
        case tetrapak
        case plastico
        case acumulador
        case ropa
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if welcomeMode == true {
            performSegue(withIdentifier: "goToWelcomFromNewUser", sender: self)
        }
    }
    
    @IBAction func MaterialSelected(_ sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
    }

}
