//
//  SelectMaterialMenuViewController.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 04/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class SelectMaterialMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func MaterialSelected(_ sender: UIButton) {
        print(sender.currentTitle!)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
