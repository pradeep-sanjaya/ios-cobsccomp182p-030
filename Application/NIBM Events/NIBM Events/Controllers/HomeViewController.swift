import UIKit
import FacebookCore
import FacebookLogin
import Firebase

class HomeViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Events"
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        /*
        let isSigned = userService.isSgined()
        print(isSigned)
        
        let firebaseUser = userService.getFirebaseUserId();
        print(firebaseUser)
        
        userService.setLocalUserWithFirebaseId(name: "Pradeep", profileUrl: "http://localhost.com/image.jpg")
        */
    }
    
    @IBAction func getUser(_ sender: UIButton) {
        let user = userService.getLocalUser()
        print(user)
    }
    
}
