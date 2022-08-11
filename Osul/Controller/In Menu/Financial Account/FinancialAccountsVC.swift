//
//  FinancialAccountsVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo && Aya Bahaa on 7/3/20.
//  Copyright © 2020 Sayed Abdo && Aya Bahaa. All rights reserved.
//

import UIKit
import JSSAlertView
import SideMenu
class FinancialAccountsVC: UIViewController {

    @IBOutlet weak var FinancialAccountsTableView: UITableView!
    var FinancialAccountsArr = [FinancialAccounts]()
    var menu : SideMenuNavigationController?
    @IBOutlet weak var empName: UILabel!
    var Cons :Constants?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        // Do any additional setup after loading the view.
        let userName = UserDefaults.standard.value(forKey: "userName") as? String
        let jopTitle = UserDefaults.standard.value(forKeyPath: "jopTitle") as? String
        empName.text = " \(userName ?? "")/\(jopTitle ?? "")"
    }
    @IBAction func openProfileAction(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(view, animated: true)
    }
    func config(){
        self.FinancialAccountsTableView.delegate = self
        self.FinancialAccountsTableView.dataSource = self
        self.FinancialAccountsTableView.isScrollEnabled = false
        self.FinancialAccountsTableView.separatorColor = .clear
        // Table View Animation when load
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
        self.FinancialAccountsArr = [FinancialAccounts(imageName: "Pages 00 icon-11", departmentName: "سندات القبض"),
                               FinancialAccounts(imageName: "Pages 00 icon-12", departmentName: "سندات الصرف"),
                               FinancialAccounts(imageName: "Pages 00 icon-13", departmentName: "كشف حساب عميل"),
                               FinancialAccounts(imageName: "Pages 00 icon-14", departmentName: "كشف حساب مصروفات مشروع"),
                               FinancialAccounts(imageName: "Pages 00 icon-11", departmentName: "المطالبة المالية")
                              ]
         self.FinancialAccountsTableView.isHidden = false
         self.FinancialAccountsTableView.reloadData()
         self.animateTableView()
         }
        // sideMenu
        menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        menu?.setNavigationBarHidden(true, animated: false)
        getTokenReq()
    }
    // side Menu Action hide and show
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        menu = storyboard?.instantiateViewController(withIdentifier: "RightMenu") as? SideMenuNavigationController
        present(menu!, animated: true)
    }
}
// table View protocol methods
extension FinancialAccountsVC :UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FinancialAccountsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "FinancialAccountsCell", for: indexPath) as! FinancialAccountsCell
        cell.FinancialAccountsImage.image = UIImage(named: "\(FinancialAccountsArr[indexPath.row].imageName)")
        cell.FinancialAccountsName.text = FinancialAccountsArr[indexPath.row].departmentName
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let view = storyboard?.instantiateViewController(withIdentifier: "receiptVC") as! receiptVC
            view.reqesrType = 1
            self.navigationController?.pushViewController(view, animated: true)
        }
        if indexPath.row == 1 {
            let view = storyboard?.instantiateViewController(withIdentifier: "receiptVC") as! receiptVC
            view.reqesrType = 2
            self.navigationController?.pushViewController(view, animated: true)
        }
        if indexPath.row == 2 {
            let view = storyboard?.instantiateViewController(withIdentifier: "ClientAccountStatementVC") as! ClientAccountStatementVC
            view.checkVC = "1"
            self.navigationController?.pushViewController(view, animated: true)
        }
        if indexPath.row == 3 {
            let view = storyboard?.instantiateViewController(withIdentifier: "ClientAccountStatementVC") as! ClientAccountStatementVC
            view.checkVC = "2"
            self.navigationController?.pushViewController(view, animated: true)
        }
        if indexPath.row == 4 {
            let view = storyboard?.instantiateViewController(withIdentifier: "FinancialClaimVC") as! FinancialClaimVC
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
}
// table view Animation
extension FinancialAccountsVC {
    func animateTableView(){
       let fadeAnimation = TableViewAnimation.Cell.left(duration: 1.0)
       self.FinancialAccountsTableView.animate(animation: fadeAnimation)
    }
}
