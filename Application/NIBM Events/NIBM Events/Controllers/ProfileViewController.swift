import UIKit
import MessageUI
import Firebase

class ProfileViewController: BaseViewController,
    MFMailComposeViewControllerDelegate,
    UITextFieldDelegate
{
    
    /* Views */
    @IBOutlet var containerScrollView: UIScrollView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var fullNameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet weak var facebookProfileTxt: UITextField!
    @IBOutlet var updateOutlet: UIButton!
    
    /* Variables */
    var imagePicker: ImagePicker!
    let rootRef = Database.database().reference()
    var localUser:User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        
        // Setup container ScrollView
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: updateOutlet.frame.origin.y + 250)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

        self.localUser = userService.getLocalUser()
        
        fullNameTxt.text = self.localUser.name
        emailTxt.text = self.localUser.email
        facebookProfileTxt.text = self.localUser.profileUrl
    }
    
    
    
    // MARK - Textfields deligate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTxt  {
            emailTxt.becomeFirstResponder()
        }
    
        if textField == emailTxt  {
            facebookProfileTxt.becomeFirstResponder()
        }
        
        return true
    }
    
    
    // MARK: - Dismiss keyboard
    @IBAction func tapToDismissKeyboard(_ sender: UITapGestureRecognizer) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        fullNameTxt.resignFirstResponder()
        emailTxt.resignFirstResponder()
        facebookProfileTxt.resignFirstResponder()
    }
    
    
    @IBAction func chooseImageAction(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    // MARK: - Update profile
    @IBAction func updateProfileAction(_ sender: UIButton) {
        dismissKeyboard()
        
        print("----- updateProfileAction -----")
        let localUser = userService.getLocalUser()
        print("local user: \(localUser)")
        var photoUrl = ""
        
        if let image = self.profileImage.image {
            storageService.uploadUserProfile(image: image, token: localUser.token) {
                (isSuccess, url) in
                photoUrl = url!
                print("url: \(url)")
            }
        }
        
        let user = User(
            type: localUser.type,
            token: localUser.token,
            name: self.fullNameTxt.text!,
            email: self.emailTxt.text!,
            profileUrl: self.facebookProfileTxt.text!,
            photoUrl: photoUrl
        )
        
        self.userService.setLocalUser(user: user)
        
        let userRef = self.rootRef.child(COLLECTION_USERS)
                
        let firebaseUser: [String: String] = [
            USER_AUTH_TYPE: user.type.toString(),
            USER_TOKEN: user.token,
            USER_NAME: user.name,
            USER_EMAIL: user.email,
            USER_PROFILE: user.profileUrl
        ]

        userRef.child(user.token).setValue(firebaseUser) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print(ref)
            print("Data saved successfully!")
          }
        }
        
        /*
        let eventService = EventService()
        eventService.create(for: self.profileImage.image!, token: user.token)
        */
        
        /*
        userRef.childByAutoId().setValue(firebaseUser) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print(ref)
            print("Data saved successfully!")
          }
        }
        */
        
        
//        // This string containes standard HTML tags, you can edit them as you wish
//        let messageStr = "<font size = '1' color= '#222222' style = 'font-family: 'HelveticaNeue'>\(messageTxt!.text!)<br><br>You can reply to: \(emailTxt!.text!)</font>"
//        
//        let mailComposer = MFMailComposeViewController()
//        mailComposer.mailComposeDelegate = self
//        mailComposer.setSubject("Message from \(fullNameTxt!.text!)")
//        mailComposer.setMessageBody(messageStr, isHTML: true)
//        mailComposer.setToRecipients([CONTACT_EMAIL_ADDRESS])
//        
//        if MFMailComposeViewController.canSendMail() {
//            present(mailComposer, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertView(title: APP_NAME,
//                                    message: "Your device cannot send emails. Please configure an email address into Settings -> Mail, Contacts, Calendars.",
//                                    delegate: nil,
//                                    cancelButtonTitle: "OK")
//            alert.show()
//        }
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        userService.signOut()
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let mainNavigationController = storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as? MainNavigationController
        
        UIApplication.shared.windows.first?.rootViewController = mainNavigationController
        UIApplication.shared.windows.first?.makeKeyAndVisible()

    }
    
    
    // Email delegate
    func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        
        var resultMess = ""
        switch result.rawValue {
            case MFMailComposeResult.cancelled.rawValue:
                resultMess = "Mail cancelled"
            case MFMailComposeResult.saved.rawValue:
                resultMess = "Mail saved"
            case MFMailComposeResult.sent.rawValue:
                resultMess = "Thanks for contacting us!\nWe'll get back to you asap."
            case MFMailComposeResult.failed.rawValue:
                resultMess = "Something went wrong with sending Mail, try again later."
            default:break
        }
        
        simpleAlert(resultMess)
        
        dismiss(animated: false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ProfileViewController: ImagePickerDelegate {

    func didSelect(image: UIImage?) {
        self.profileImage.image = image
    }
}
