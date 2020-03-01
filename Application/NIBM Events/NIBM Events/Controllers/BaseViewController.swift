import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class BaseViewController: UIViewController {

    public let userService = UserService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*
    public func setRootViewController(name: String) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: name)

        self.navigationController?.setViewControllers([homeViewController], animated: false)
    }
    */
    
    public func setRootViewController(name: String) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = storyboard.instantiateViewController(withIdentifier: name)
        UIApplication.shared.windows.first?.rootViewController = rootViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}
