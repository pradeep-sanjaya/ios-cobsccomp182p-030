import Foundation
import Firebase
import FacebookLogin

class UserService {
    
    let defaults = UserDefaults.standard
    
    
    // firebase
    func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil) {
          Auth.auth().createUser(withEmail: email, password: password) {
            
            (user, error) in
              if let e = error {
                  callback?(e)
                  return
              }
              callback?(nil)
          }
    }
    
    func login(withEmail email: String, password: String, _ callback: ((Error?) -> ())? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) {
            (user, error) in
            if let e = error {
                callback?(e)
                return
            }
            
            callback?(nil)
        }
    }
    
    func sendEmailVerification(_ callback: ((Error?) -> ())? = nil) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            callback?(error)
        })
    }
    
    func reloadUser(_ callback: ((Error?) -> ())? = nil) {
        Auth.auth().currentUser?.reload(completion: { (error) in
            callback?(error)
        })
    }
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    
    func isSgined() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        }
        
        return false
    }
    
    func getFirebaseUserId() -> String? {

        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not signed in")
            return nil
        }
        
        return userId
    }
    
    func signOutFirebase() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
    
    func updateProfileInfo(withImage image: Data? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil) {
        
        guard let user = Auth.auth().currentUser else {
            callback?(nil)
            return
        }

        if let image = image {
            let profileImgReference = Storage.storage().reference().child("profile_pictures").child("\(user.uid).png")

            _ = profileImgReference.putData(image, metadata: nil) { (metadata, error) in
                if let error = error {
                    callback?(error)
                } else {
                    profileImgReference.downloadURL(completion: { (url, error) in
                        if let url = url{
                            self.createProfileChangeRequest(photoUrl: url, name: name, { (error) in
                                callback?(error)
                            })
                        }else{
                            callback?(error)
                        }
                    })
                }
            }
        } else if let name = name {
            self.createProfileChangeRequest(name: name, { (error) in
                callback?(error)
            })
        } else {
            callback?(nil)
        }
    }
    
    func createProfileChangeRequest(photoUrl: URL? = nil, name: String? = nil, _ callback: ((Error?) -> ())? = nil) {
        
        if let request = Auth.auth().currentUser?.createProfileChangeRequest() {
            if let name = name {
                request.displayName = name
            }
            
            if let url = photoUrl {
                request.photoURL = url
            }

            request.commitChanges(completion: { (error) in
                callback?(error)
            })
        }
    }
    
    // facebook
    func signOutFacebook() -> Bool {
        let loginManager = LoginManager()
        loginManager.logOut()
        return true
    }
    
    
    // user default
    public func getLocalUser() -> User {
        
        let userDictonary = defaults.object(forKey: "user") as? [String:String] ?? [String:String]()

        if let type = userDictonary["type"] {
            let authType = AuthType.getAuthTypeByString(value: type)

            return User(
                type: authType,
                token: userDictonary["token"] ?? "",
                name: userDictonary["name"] ?? "",
                email: userDictonary["email"] ?? "",
                profileUrl: userDictonary["profileUrl"] ?? "",
                photoUrl: userDictonary["photoUrl"] ?? ""
            )
        }
        
        return User(type: AuthType.other, token: "", name: "", email: "", profileUrl: "", photoUrl: "")

    }

    public func setLocalUser(user: User) {
        let userDictonary = ["type": user.type.toString(), "token": user.token, "name": user.name, "email": user.email,  "profileUrl": user.profileUrl]
        defaults.set(userDictonary, forKey: "user")
    }
    
    public func setLocalUserWithFirebaseId(name: String, email: String, profileUrl: String) {
        guard let userId = self.getFirebaseUserId() else {
            return
        }
        
        let user = User(type: AuthType.firebase, token: userId, name: name, email: email, profileUrl: profileUrl , photoUrl: "")
        
        self.setLocalUser(user: user)
    }
    
    public func signOut() {
        let _ = signOutFirebase()
        let _ = signOutFacebook()
        defaults.removeObject(forKey:"user")
    }

}
