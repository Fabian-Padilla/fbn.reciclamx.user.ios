//
//  SetPostOptionsViewController.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 30/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class SetPostOptionsViewController: UIViewController {
    
    
    @IBOutlet var descripcionView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        self.view.addSubview(descripcionView)
        
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
