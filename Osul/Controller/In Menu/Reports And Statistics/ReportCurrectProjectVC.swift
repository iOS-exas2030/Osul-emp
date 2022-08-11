////
////  ReportCurrectProjectVC.swift
////  AL-HHALIL
////
////  Created by Sayed Abdo on 8/27/20.
////  Copyright © 2020 Sayed Abdo. All rights reserved.
////
//
//import UIKit
//
//class ReportCurrectProjectVC: UIViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//
//    override func viewDidLoad() {
//       super.viewDidLoad()
//       // Do any additional setup after loading the view.
//   }
//    override func viewWillAppear(_ animated: Bool) {
//        config()
//    }
//   func config(){
//       self.tableView.delegate = self
//       self.tableView.dataSource = self
//       tableView.registerHeaderNib(cellClass: employeTitleCell.self)
//   }
//}
//// table View
//extension ReportCurrectProjectVC : UITableViewDelegate , UITableViewDataSource{
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "employeTitleCell") as! employeTitleCell
//        header.mainLabel.text = "اسم المشروع"
//        header.subLabel.text = "مده التاخير"
//        print("table \(header.bounds)")
//        return header
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCurrectProjectCell", for: indexPath) as! ReportCurrectProjectCell
//        cell.numberLabel.text = "\(indexPath.row + 1)"
//        cell.nameLabel.text = "مشروع محمد حسن"
//        cell.timeLabel.text = "لا يوجد"
//        return cell
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50.0
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let view = self.storyboard?.instantiateViewController(identifier: "FollowReportVC") as! FollowReportVC
//         self.navigationController?.pushViewController(view, animated: true)
//    }
//}
//// Request
//extension ReportCurrectProjectVC {
//    
//}
