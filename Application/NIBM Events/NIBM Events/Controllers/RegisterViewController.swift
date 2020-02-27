//
//  RegisterViewController.swift
//  NIBM Events
//
//  Created by Pradeep Sanjaya on 2/27/20.
//  Copyright © 2020 Pradeep Sanjaya. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //addNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func addNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height:44))

        navigationBar.backgroundColor = UIColor.white

        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Title"

        // Create left and right button for navigation item
         let leftButton =  UIBarButtonItem(title: "Login", style:   .plain, target: self, action: #selector(navigationBackButt(_:)))

        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton

        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]

        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    @objc func navigationBackButt(_ sender: UIBarButtonItem) {

    }

}
