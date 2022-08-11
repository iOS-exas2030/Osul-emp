
import UIKit

extension UIViewController{
    
     func updateRoot(){
        let userId =  UserDefaults.standard.value(forKey: "userId") as? String
        let userName =  UserDefaults.standard.value(forKey: "userName") as? String
        
      //  let userId =  UserDefaults.standard.string(forKey: "writeTextViewValue")
        print("userId : \(userId)")
        print("userName : \(userName)")
        if(userId == nil || userId == ""){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
          //  let mainViewController = storyboard.instantiateViewController(withIdentifier: "LogInVC")
          //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
          //  appDelegate.window!.rootViewController = mainViewController
          //  appDelegate.window?.makeKeyAndVisible()
            let view = storyboard.instantiateViewController(withIdentifier: "LogInVC") as! LogInVC
            self.navigationController?.pushViewController(view, animated: true)
        }
        else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "home")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = mainViewController
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}

