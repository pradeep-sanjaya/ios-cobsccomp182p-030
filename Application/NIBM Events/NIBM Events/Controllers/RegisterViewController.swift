import UIKit
import Firebase

class RegisterViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var passwordRetypeTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUIControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func prepareUIControls() {
        preparePassword()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func preparePassword() {
        passwordTxt.layer.borderWidth = 1
        passwordTxt.layer.borderColor = UIColor.init(named: "DarkBlue")?.cgColor
        add(image: UIImage(named: "Eye")!, toTextField: passwordTxt)
        
        //let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 40))
        //passwordRetypeTxt.leftView = paddingView
        passwordRetypeTxt.leftViewMode = .always
        passwordRetypeTxt.layer.borderWidth = 1
        passwordRetypeTxt.layer.borderColor = UIColor.init(named: "DarkBlue")?.cgColor
    }
    
    public func add(image: UIImage, toTextField control: UITextField)  {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(control.frame.size.width - 40), y: CGFloat(5), width: CGFloat(40), height: CGFloat(40))
        button.addTarget(self, action: #selector(self.eyeTapped), for: .touchUpInside)
        control.rightView = button
        control.rightViewMode = .always
    }
    
    @objc func eyeTapped(_ sender: UIButton) {
        print("eye tapped")
        passwordTxt.isSecureTextEntry.toggle()
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        validate()
        
        if let email = emailTxt.text, let password = passwordTxt.text {
            userService.createUser(email: email, password: password) {
                (error) in
            }
            
            let profileUrl = URL(string: "https://irs3.4sqi.net/img/user/original/HBVX4T2WQOGG20FE.png")

            userService.setLocalUserWithFirebaseId(name: self.nameTxt.text!, email: emailTxt.text! , profileUrl: profileUrl?.absoluteString ?? "")
        }


        /*
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nameTxt.text!
        changeRequest?.photoURL = profileUrl
        changeRequest?.commitChanges {
            (error) in
        }
        */
    }
    
    func validate() {
        guard let name = nameTxt.text, name != "" else {
            print("name is empty")
            UIViewUtil.setUnsetError(of: nameTxt, forValidStatus: false)
            nameTxt.becomeFirstResponder()
            return
        }
        
        UIViewUtil.setUnsetError(of: nameTxt, forValidStatus: true)
        
        guard let email = emailTxt.text, email != "", Validator.isValidEmail(email) else {
            print("email is empty")
            UIViewUtil.setUnsetError(of: emailTxt, forValidStatus: false)
            emailTxt.becomeFirstResponder()
            return
        }
        
        UIViewUtil.setUnsetError(of: emailTxt, forValidStatus: true)
        
        guard let password = passwordTxt.text, password != "" else {
            print("password is empty")
            UIViewUtil.setUnsetError(of: passwordTxt, forValidStatus: false)
            passwordTxt.becomeFirstResponder()
            return
        }
        
        UIViewUtil.setUnsetError(of: passwordTxt, forValidStatus: true)
        
        guard let passwordRetype = passwordRetypeTxt.text,
            passwordRetype != "",
            password == passwordRetype else {
            print("retype password is empty")
            UIViewUtil.setUnsetError(of: passwordRetypeTxt, forValidStatus: false)
            passwordRetypeTxt.becomeFirstResponder()
            return
        }
        
        UIViewUtil.setUnsetError(of: passwordRetypeTxt, forValidStatus: true)
    }
    
    /*
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
     */
    
    @objc func navigationBackButt(_ sender: UIBarButtonItem) {
    }

}
