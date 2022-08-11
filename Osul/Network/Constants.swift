
//

import Foundation
import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase


struct Constants {
 // let username = UserDefaults.standard.string(forKey: "name")
    
 //   static let userId = UserDefaults.standard.value(forKey: "userId") as? String
 //   static let userName = UserDefaults.standard.value(forKey: "userName") as? String
 //   static let userPhone = UserDefaults.standard.value(forKeyPath: "userPhone") as? String
 //   static let userEmail = UserDefaults.standard.value(forKeyPath: "userEmail") as? String
 //   static let userAddress = UserDefaults.standard.value(forKeyPath: "userAddress") as? String
 //   static let token = UserDefaults.standard.value(forKeyPath: "token") as? String
 //   static let jopTitle = UserDefaults.standard.value(forKeyPath: "jopTitle") as? String
    
    //For Edit
  //  static let baseURL = "https://test.alkhalilsys.com/app/"
  //  static let baseURL2 = "https://test.alkhalilsys.com/"
  //  static let baseImageUrl = "https://test.alkhalilsys.com/app/users/upload_photo"
    //For Real app
///    https://test.alkhalilsys.com/admins/page/quest
    
    static let baseURL = "https://appcrm.exas2030.com/app/"
    static let baseURL2 = "https://appcrm.exas2030.com/"
    static let baseImageUrl = "https://appcrm.exas2030.com/api/users/upload_photo"
//
  //  https://appcrm.exas2030.com/app/
    static let baseColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("Chat")
        static let databaseToken = databaseRoot.child("Token")
        static let databaseUser = databaseRoot.child("Users")
    }
}


enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
    case accept = "*/*"
    case acceptEncoding = "gzip;q=1.0, compress;q=0.5"
}


class saveDefaults {

    static let shared = LogInVC()
    private enum Keys {

        static let myKey = "myKey"

    }
    private var value: String {
        didSet {
            UserDefaults.standard.set( value, forKey: Keys.myKey)
        }
    }
    var userValues: String { return value }

    private init() {
        value = UserDefaults.standard.string(forKey: Keys.myKey) ?? ""
    }

}
