//
//  ForgotPasswordViewController.swift
//  NIBM Events
//
//  Created by Pradeep Sanjaya on 2/27/20.
//  Copyright © 2020 Pradeep Sanjaya. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}
