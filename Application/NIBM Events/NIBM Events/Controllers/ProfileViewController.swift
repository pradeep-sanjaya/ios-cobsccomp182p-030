import UIKit
import MessageUI


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
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Profile"
        
        // Setup container ScrollView
        containerScrollView.contentSize = CGSize(width: containerScrollView.frame.size.width, height: updateOutlet.frame.origin.y + 250)
        
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
    
    
    
    
    // MARK: - Update profile
    @IBAction func updateProfileAction(_ sender: UIButton) {
        dismissKeyboard()
        
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
