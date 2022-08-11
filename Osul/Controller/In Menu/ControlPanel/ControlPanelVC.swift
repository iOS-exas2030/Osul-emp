//
//  ControlPanelVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/3/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import SideMenu
import JSSAlertView

class ControlPanelVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var controlPanelTableView: UITableView!
    @IBOutlet weak var empName: UILabel!

    //MARK: - Properties
    var controlPanelArr = [ControlPanel]()
    var menu : SideMenuNavigationController?
    var Cons :Constants?
    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        let userName = UserDefaults.standard.value(forKey: "userName") as? String
        let jopTitle = UserDefaults.standard.value(forKeyPath: "jopTitle") as? String
        empName.text = " \(userName ?? "")/\(jopTitle ?? "")"
        // Do any additional setup after loading the view.
        config()
    }
    override func viewWillAppear(_ animated: Bool) {
        getTokenReq()
    }
    @IBAction func openProfileAction(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(view, animated: true)
    }
    func config(){
           self.controlPanelTableView.delegate = self
           self.controlPanelTableView.dataSource = self
       //    self.controlPanelTableView.isScrollEnabled = false
           self.controlPanelTableView.separatorColor = .clear
            // Table View Animation when load
           DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.controlPanelArr = [ControlPanel(imageName: "Pages 00 icon-1", departmentName: "اعدادات الموظفين و الأدوار"),
                                  ControlPanel(imageName: "Pages 00 icon-2", departmentName: "إعدادات الوظائف  و الصلاحيات"),
                                  ControlPanel(imageName: "Pages 00 icon-3", departmentName: "اعدادات خصومات الشركات"),
                                  ControlPanel(imageName: "Pages 00 icon-4", departmentName: "اعدادات انواع التعاقدات"),
                                  ControlPanel(imageName: "Pages 00 icon-5", departmentName: "اعدادات المراحل"),
                                 // ControlPanel(imageName: "Pages 00 icon-6", departmentName: "اعدادات عرض السعر"),
                                  ControlPanel(imageName: "Pages 00 icon-6", departmentName: "اعدادات قائمه العملاء"),
                                  ControlPanel(imageName: "Pages 00 icon-4", departmentName: "اعدادات الرسائل النصية"),
                                  ControlPanel(imageName: "Pages 00 icon-6", departmentName: "اعدادات عامه")
                ]
                self.controlPanelTableView.isHidden = false
                self.controlPanelTableView.reloadData()
                self.animateTableView()
        }
        // sideMenu
        menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        menu?.setNavigationBarHidden(true, animated: false)
       }

    // side Menu Action hide and show
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        menu = storyboard?.instantiateViewController(withIdentifier: "RightMenu") as? SideMenuNavigationController
        present(menu!, animated: true)
    }
}
// table View protocol methods
extension ControlPanelVC :UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controlPanelArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ControlPanelCell", for: indexPath) as! ControlPanelCell
        cell.ControlPanelImage.image = UIImage(named: "\(controlPanelArr[indexPath.row].imageName)")
        cell.ControlPanelName.text = controlPanelArr[indexPath.row].departmentName
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let view = storyboard?.instantiateViewController(withIdentifier: "employesSettingsVC") as! employesSettingsVC
              self.navigationController?.pushViewController(view, animated: true)
        }else if indexPath.row == 1{
            let view = storyboard?.instantiateViewController(withIdentifier: "Jobs_FunctionsVC") as! Jobs_FunctionsVC
              self.navigationController?.pushViewController(view, animated: true)
        }else if indexPath.row == 2{
            let view = storyboard?.instantiateViewController(withIdentifier: "CompanyCategoryVC") as! CompanyCategoryVC
            self.navigationController?.pushViewController(view, animated: true)
        }else if indexPath.row == 3{
            let view = storyboard?.instantiateViewController(withIdentifier: "ContractSettingVC") as! ContractSettingVC
            self.navigationController?.pushViewController(view, animated: true)
        }else if indexPath.row == 4{
            let view = storyboard?.instantiateViewController(withIdentifier: "phasesSettingsVC") as! phasesSettingsVC
            self.navigationController?.pushViewController(view, animated: true)
        }else if indexPath.row == 5{
             let view = storyboard?.instantiateViewController(withIdentifier: "ClientSettingsVC") as! ClientSettingsVC
             self.navigationController?.pushViewController(view, animated: true)
        }else if indexPath.row == 6{
            let view = storyboard?.instantiateViewController(withIdentifier: "smsLogsVC") as! smsLogsVC
            self.navigationController?.pushViewController(view, animated: true)
        }else if indexPath.row == 7{
            let view = storyboard?.instantiateViewController(withIdentifier: "GeneralSettingVC") as! GeneralSettingVC
                      self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
// table view Animation
extension ControlPanelVC {
    func animateTableView(){
        let fadeAnimation = TableViewAnimation.Cell.left(duration: 1.0)
        self.controlPanelTableView.animate(animation: fadeAnimation)
    }
}

