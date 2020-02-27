//
//  LoginViewController.swift
//  NIBM Events
//
//  Created by Pradeep Sanjaya on 2/26/20.
//  Copyright © 2020 Pradeep Sanjaya. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class LoginViewController: UIViewController, LoginButtonDelegate {
        
    /* Views */
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*
        let button = FBLoginButton(permissions: [.publicProfile, .email])
        button.delegate = self
        button.center = view.center
        view.addSubview(button)
        */
    }
    
    @IBAction func loginButt(_ sender: UIButton) {
        
    }
    
    @IBAction private func loginWithFacebookButt() {
        let loginManager = LoginManager()
        loginManager.logIn(
            permissions: [.publicProfile, .userFriends],
            viewController: self
        ) { result in
            self.loginManagerDidComplete(result)
        }
    }
    
    @IBAction func forgotPasswordButt(_ sender: UIButton) {
        
    }
    
    @IBAction func registerButt(_ sender: UIButton) {
//        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
//        let registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterController")
//        self.navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func loginManagerDidComplete(_ result: LoginResult) {
        
        var title = ""
        var message = ""
        
        switch result {
        case .cancelled:
            title="Login Cancelled"
            message="User cancelled login."
            
        case .failed(let error):
            title = "Login Fail"
            message = "Login failed with error \(error)"
            
        case .success(let grantedPermissions, _, _):
            title = "Login Success"
            message = "Login succeeded with granted permissions: \(grantedPermissions)"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("Did complete login via LoginButton with result \(String(describing: result)) " +
            "error\(String(describing: error))")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did logout via LoginButton")
    }
    
    @IBAction func getInfoAction(_ sender: UIButton) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) {
            (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                
                if (result?.isCancelled)!{
                    return
                }
                
                if (fbloginresult.grantedPermissions.contains("email")) {
                    self.getFBUserData()
                }
            }
        }
        
    }
    
    func getFBUserData() {
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    guard let userDict = result as? [String:Any] else {
                        return
                    }
                    if let picture = userDict["picture"] as? [String:Any] ,
                        let imgData = picture["data"] as? [String:Any] ,
                        let imgUrl = imgData["url"] as? String {
                        //self.uURLString = imgUrl
                        let url = URL(string: imgUrl)
                        print(imgUrl)
                        print(url ?? "")
                        print(imgData)
                                                
                        let imageUrl:URL = URL(string: imgUrl)!
                        
                        DispatchQueue.global(qos: .userInitiated).async  {
                            
                            let imageData:Data = try! Data(contentsOf: imageUrl)
                            
                            // Add photo to a cell as a subview
                            DispatchQueue.main.async {
                                let image = UIImage(data: imageData)
//                                self.profileImage.image = image
//                                self.profileImage.contentMode = UIView.ContentMode.scaleAspectFit
                            }
                        }
                    }
                        
                    if let name = userDict["name"] as? String {
                        print(name)
                        //self.name = n
                    }
                        
                    if let email = userDict["email"] as? String {
                        print(email)
                        //self.email = e
                    }
                    //self.socialLogIn()
                 }
            })
        }
    }
}
