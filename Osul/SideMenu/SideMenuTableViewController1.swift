//
//  SideMenuTableViewController1.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit


enum MenuType1: Int {
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
class SideMenuTableViewController1: UIViewController, UITableViewDelegate {
 
    @IBOutlet var menuTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
         menuTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        menuTableView.delegate = self
    //    navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.7996205688, green: 0.1996477842, blue: 0.2297141254, alpha: 0.8470588235)
     //   navigationController?.navigationBar.backgroundColor = UIColor.green
        //UIApplication.shared.statusBarView.backgroundColor = .red
        
        // Do any additional setup after loading the view.
        
     //  menuTableView.contentInset = UIEdgeInsets(top: -40, left: 0, bottom: 0, right: 0)
    }

    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let MenuType1 = MenuType1(rawValue: indexPath.row) else { return }
//        dismiss(animated: true) { [weak self] in
//            print("Dismissing: \(menuType)")}
        switch MenuType1 {
              case .mail:
                 let view = storyboard?.instantiateViewController(withIdentifier: "MailVC") as! MailVC
                 self.navigationController?.pushViewController(view, animated: true)
              case .userRequests:
                  let view = storyboard?.instantiateViewController(withIdentifier: "NewOrdersVC") as! NewOrdersVC
                 self.navigationController?.pushViewController(view, animated: true)
              case .contracts:
                  let view = storyboard?.instantiateViewController(withIdentifier: "ContractVC") as! ContractVC
                  self.navigationController?.pushViewController(view, animated: true)
              
              case .projects:
                  let view = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                  self.navigationController?.pushViewController(view, animated: true)
              case .reports:
                  let view = storyboard?.instantiateViewController(withIdentifier: "ReportsAndStatisticsVC") as! ReportsAndStatisticsVC
                   self.navigationController?.pushViewController(view, animated: true)
              case .financial:
                  let view = storyboard?.instantiateViewController(withIdentifier: "FinancialAccountsVC") as! FinancialAccountsVC
                  self.navigationController?.pushViewController(view, animated: true)
              case .controlPanel:
                  let view = storyboard?.instantiateViewController(withIdentifier: "ControlPanelVC") as! ControlPanelVC
                  self.navigationController?.pushViewController(view, animated: true)
              case .signout:
                   UserDefaults.standard.removeObject(forKey: "userId")
                   let view = storyboard?.instantiateViewController(withIdentifier: "EnteranceVC") as! EnteranceVC
                   self.navigationController?.pushViewController(view, animated: true)
            
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
