//
//  WelcomFromRegisterViewController.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 19/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class WelcomFromRegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var continuarAction: UILabel!
    @IBAction func continuarAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
