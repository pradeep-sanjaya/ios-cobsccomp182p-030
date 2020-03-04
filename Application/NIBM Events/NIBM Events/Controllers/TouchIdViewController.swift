import UIKit
import LocalAuthentication

class TouchIdViewController: UIViewController {
    
    let biometricAuthService = BiometricAuthService()
    
    @IBOutlet weak var biometricLoginOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autheticateUser()
    }
    
    func setupBiometricButton() {
        biometricLoginOutlet.isHidden = !biometricAuthService.canEvaluatePolicy()
        print("isHidden: \(biometricLoginOutlet.isHidden)")
        
        switch biometricAuthService.biometricType() {
        case .faceID:
            biometricLoginOutlet.setImage(UIImage(named: "faceIcon"),  for: .normal)
        default:
            biometricLoginOutlet.setImage(UIImage(named: "touchIcon"),  for: .normal)
        }
    }
    
    @IBAction func biometricLoginAction(_ sender: UIButton) {
        autheticateUser()
    }
    
    func autheticateUser() {
        biometricAuthService.authenticateUser() { [weak self] message in
            if let message = message {
                self?.presentHideAlert(withTitle: Bundle.appName(), message: message)
            } else {
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBar") as? MainTabBarController
                UIApplication.shared.windows.first?.rootViewController = mainTabBarController
            }
        }
    }
    
}
