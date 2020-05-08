//
//  NewUserViewController.swift
//  reciclamx.user.ios
//
//  Created by Guillermo Padilla Lam on 03/05/20.
//  Copyright © 2020 gp Apps. All rights reserved.
//

import UIKit

class NewUserViewController: UIViewController {
    
    @IBOutlet weak var birthDayText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.birthDayText.setInputViewDatePicker(target: self, selector:#selector(tapDone) )
        
        
    }
    
    @objc func tapDone() {
        if let datePicker = self.birthDayText.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.birthDayText.text = dateformatter.string(from: datePicker.date)
        }
        self.birthDayText.resignFirstResponder()
    }           	
    
    @IBAction func SaveNewUserAction(_ sender: UIButton) {
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
