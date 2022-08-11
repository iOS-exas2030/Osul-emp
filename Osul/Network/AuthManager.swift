
//

import Foundation

// consider this a real user manager or auth or whatever that has the authentication key stored
// var userId : String =  UserDefaults.standard.value(forKey: "acces") as? String ?? ""

class AuthManager {
    
  
    static var loggedIn = false
    
    static func authKey() -> String {
        return "Bearer "
    }
}
