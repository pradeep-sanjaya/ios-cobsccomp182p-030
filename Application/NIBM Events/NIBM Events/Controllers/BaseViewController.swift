import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class BaseViewController: UIViewController {

    public let userService = UserService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func setRootViewController(name: String) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")

        self.navigationController?.setViewControllers([homeViewController], animated: false)
    }
    
    /*
    public func add(image: UIImage, toTextField control: UITextField)  {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(control.frame.size.width - 40), y: CGFloat(5), width: CGFloat(40), height: CGFloat(40))
        button.addTarget(self, action: #selector(self.eyeTapped), for: .touchUpInside)
        control.rightView = button
        control.rightViewMode = .always
    }
    
    @objc func eyeTapped(_ sender: UITextField) {
        print("eye tapped")
        sender.isSecureTextEntry.toggle()
    }
    */
}
