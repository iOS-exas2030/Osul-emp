//
//  SideMenuTableViewController.swift
//  SideMenu
//
//  Created by Jon Kent on 4/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import JSSAlertView


enum MenuType: Int {
    case image
    case mail
    case userRequests
    case contracts
    case projects
    case reports
    case financial
    case controlPanel
    case signout
}
class SideMenuTableViewController: UITableViewController {
 
    @IBOutlet var menuTableView: UITableView!
    
    @IBOutlet weak var notiNum: UIButton!
    @IBOutlet weak var notiNum1: UIButton!
    @IBOutlet weak var notiNum2: UIButton!
    @IBOutlet weak var chatNum: UIButton!
    
    
    var check = false
    let defaults = UserDefaults.standard
    var allNotifcationCount : NotificationStatus?
    override func viewDidLoad() {
        super.viewDidLoad()
         menuTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        menuTableView.contentInset = UIEdgeInsets(top: -68.5, left: 0, bottom: 0, right: 0)
         GetNotifcationCountReq()
    }
    
    func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.notiNum.isHidden = true
        self.notiNum1.isHidden = true
        self.notiNum2.isHidden = true
        self.chatNum.isHidden = true
//        self.notiNum1.isEnabled = false
//        self.notiNum1.isEnabled = false
    }
    
    func GetNotifcationCountReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(NotificationStatus.self, router: .GetNotifcationCount(id: userId!), success: { [weak self] (models) in
              print("models\( models)")
              if(models.status == 1){
                    self?.allNotifcationCount = models
                    if(models.data?.newMails == 0){
                        self?.notiNum.isHidden = true
                    }else{
                        self?.notiNum.isHidden = false
                        self?.notiNum.setTitle("\(models.data?.newMails ?? 0)", for: .normal)
                    }
                    
                    if(models.data?.newProjects == 0){
                        self?.notiNum1.isHidden = true
                    }else{
                        self?.notiNum1.isHidden = false
                        self?.notiNum1.setTitle("\(models.data?.newProjects ?? 0)", for: .normal)
                    }
                    
                    if(models.data?.newContract == 0){
                        self?.notiNum2.isHidden = true
                    }else{
                        self?.notiNum2.isHidden = false
                        self?.notiNum2.setTitle("\(models.data?.newContract ?? 0)", for: .normal)
                    }
                    if(models.data?.chat == 0){
                        self?.chatNum.isHidden = true
                    }else{
                        self?.chatNum.isHidden = false
                        self?.chatNum.setTitle("\(models.data?.chat ?? 0)", for: .normal)
                    }
              }
              else if (models.status == 0 ){
              }
          }){ [weak self] (error) in
              }
      }
   func logOutReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(status2Model.self, router: .logOut(user_id: userId!), success: { [weak self] (models) in
            
            print("models\( models)")
            if(models.status == 1){
                UserDefaults.standard.removeObject(forKey: "userId")
                UserDefaults.standard.removeObject(forKey: "rememberMe")
                UserDefaults.standard.removeObject(forKey: "userName")
                UserDefaults.standard.removeObject(forKey: "userPhone")
                UserDefaults.standard.removeObject(forKey: "userEmail")
                UserDefaults.standard.removeObject(forKey: "userAddress")
                UserDefaults.standard.removeObject(forKey: "isContracting")
                UserDefaults.standard.removeObject(forKey: "isProjects")
                UserDefaults.standard.removeObject(forKey: "isReport")
                UserDefaults.standard.removeObject(forKey: "isFinancial")
                UserDefaults.standard.removeObject(forKey: "isClientOrder")
                UserDefaults.standard.removeObject(forKey: "isSettings")
                UserDefaults.standard.removeObject(forKey: "isProgressTime")
                UserDefaults.standard.removeObject(forKey: "jopType")
                UserDefaults.standard.removeObject(forKey: "jopTitle")
                
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
                UserDefaults.standard.reset()
                
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                
                
                if let appDomain = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: appDomain)
                }
                
                self?.resetDefaults()
                UserDefaults.standard.synchronize()
                UserDefaults.resetStandardUserDefaults()
                print("qqqq : \(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)")
                
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "EnteranceVC") as! EnteranceVC
                self?.navigationController?.pushViewController(view, animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
              JSSAlertView().danger(self!, title: "عذرا", text: "حاول مره اخري", buttonText: "موافق")
            }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row) else { return }
//        dismiss(animated: true) { [weak self] in
//            print("Dismissing: \(menuType)")}
        switch menuType {
              case .mail:
                 let view = storyboard?.instantiateViewController(withIdentifier: "MailVC") as! MailVC
                 self.navigationController?.pushViewController(view, animated: true)
              case .userRequests:
                  if( defaults.value(forKeyPath: "isClientOrder")! as! String == "0"){
                        JSSAlertView().warning( self,title: "عذرا",text: "لا يمكنك الدخول", buttonText: "موافق",delay: 1)
                   }else{
                        let view = storyboard?.instantiateViewController(withIdentifier: "NewOrdersVC") as! NewOrdersVC
                        self.navigationController?.pushViewController(view, animated: true)
                   }
              case .contracts:
                if( defaults.value(forKeyPath: "isContracting")! as! String == "0"){
                        JSSAlertView().warning( self,title: "عذرا",text: "لا يمكنك الدخول", buttonText: "موافق",delay: 1)
                  }else{
                       let view = storyboard?.instantiateViewController(withIdentifier: "ContractVC") as! ContractVC
                       self.navigationController?.pushViewController(view, animated: true)
                  }
              case .projects:
                    if( defaults.value(forKeyPath: "isProjects")! as! String == "0"){
                    JSSAlertView().warning( self,title: "عذرا",text: "لا يمكنك الدخول", buttonText: "موافق",delay: 1)
                    }else{
                        let view = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                         self.navigationController?.pushViewController(view, animated: true)
                    }
              case .reports:
                    if( defaults.value(forKeyPath: "isReport")! as! String == "0"){
                        JSSAlertView().warning( self,title: "عذرا",text: "لا يمكنك الدخول", buttonText: "موافق",delay: 1)
                    }else{
                        let view = storyboard?.instantiateViewController(withIdentifier: "ReportsAndStatisticsVC") as! ReportsAndStatisticsVC
                        self.navigationController?.pushViewController(view, animated: true)
                    }
              case .financial:
                     if( defaults.value(forKeyPath: "isFinancial")! as! String == "0"){
                        JSSAlertView().warning( self,title: "عذرا",text: "لا يمكنك الدخول", buttonText: "موافق",delay: 1)
                     }else{
                        let view = storyboard?.instantiateViewController(withIdentifier: "FinancialAccountsVC") as! FinancialAccountsVC
                        self.navigationController?.pushViewController(view, animated: true)
                     }
              case .controlPanel:
                    if( defaults.value(forKeyPath: "isSettings")! as! String == "0"){
                        JSSAlertView().warning( self,title: "عذرا",text: "لا يمكنك الدخول", buttonText: "موافق",delay: 1)
                    }else{
                        let view = storyboard?.instantiateViewController(withIdentifier: "ControlPanelVC") as! ControlPanelVC
                        self.navigationController?.pushViewController(view, animated: true)
                    }
              case .signout:
                   logOutReq()
                  // Switcher.updateRoot()
              default:
                  dismiss(animated: true)
           }
        }
    
    }
//extension UIApplication {
//    var statusBarView: UIView? {
//        if responds(to: Selector(("statusBar"))) {
//            return value(forKey: "statusBar") as? UIView
//        }
//        return nil
//    }
//}

extension UserDefaults {

    enum Keys: String, CaseIterable {

        case unitsNotation
        case temperatureNotation
        case allowDownloadsOverCellular

    }

    func reset() {
        Keys.allCases.forEach { removeObject(forKey: $0.rawValue) }
    }

}
