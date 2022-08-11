//
//  assignEmployeVC.swift
//  AL-HHALIL
//
//  Created by apple on 8/27/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit


enum ahmed {
    case phone
    case mobile
    case usb
}

class assignEmployeVC: UIViewController {

    @IBOutlet weak var assignDropDown: DropDown!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleName: UILabel!
    var add = [String]()
    var assign : AssignModel?
    var LevelId = ""
    var projectId : String!
    var nameArray = [String]()
    var user = [AssignedUser]()
    var selectedUser : String? = nil
    let defaults = UserDefaults.standard
    var selectedIndex : Int?
    var selected = ""
    var projectStatus = ""
    var projectLevel = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        config()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    func config(){
            self.tableView.delegate = self
            self.tableView.dataSource = self
            titleName.text = "مشرفى المرحله / \(projectLevel)"
            assignDropDown.selectedRowColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            //assignDropDown.optionArray = [ "اختياري", "نص"]
            assignDropDown.rowHeight = 50
            self.assignDropDown.didSelect{(selectedText , index ,id) in
                self.selectedUser = self.assign?.data?.availableUsers?[index].name
                self.selected = selectedText
                self.selectedIndex = index
            }
            get_assigned_users(LevelId: LevelId)
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        if self.selected == ""  {
            print("not assign")
        }else {
            assign_user(emp: assign?.data?.availableUsers?[selectedIndex!].id ?? "", LevelId: LevelId, projectID: projectId)
            print("assign")
            self.selected = ""
         // self.get_assigned_users(LevelId: "3")
        }
    }
}

extension assignEmployeVC : UITableViewDelegate , UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assign?.data?.assignedUsers?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as assignEmployeCell
        cell.nameLabel.text = assign?.data?.assignedUsers?[indexPath.row].name
        if(assign?.data?.assignedUsers?[indexPath.row].jopType == "1"){
            cell.jobTitleLabel.text = "موظف عام"
        }else if(assign?.data?.assignedUsers?[indexPath.row].jopType == "2"){
            cell.jobTitleLabel.text = "مدير عام الفرع"
        }else if(assign?.data?.assignedUsers?[indexPath.row].jopType == "3"){
            cell.jobTitleLabel.text = "مدير عام الفروع"
        }
        cell.deleteButton.addTarget(self, action: #selector(deleteRow(_ :)), for: .touchUpInside)
        return cell
    }
    @objc func deleteRow(_ sender : UIButton){
         let point = sender.convert(CGPoint.zero, to: tableView)
         guard let indexpath = tableView.indexPathForRow(at: point) else {return}
        remove_assign_user(permission:(assign?.data?.assignedUsers?[indexpath.row].permissionID)!, empId:defaults.value(forKeyPath: "userId")! as! String ,index: indexpath)

     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let view = self.storyboard?.instantiateViewController(identifier: "projectAttachmentDetailsVC") as! projectAttachmentDetailsVC
//        self.navigationController?.pushViewController(view, animated: true)

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
}

extension assignEmployeVC {
    func get_assigned_users(LevelId : String){
        nameArray.removeAll()
        NetworkClient.performRequest(AssignModel.self, router: .get_assigned_users(level_id: LevelId, state: projectStatus), success: { [weak self] (models) in
             self?.assign = models
             print("models\( models)")
             if(models.status == 1){
                self?.tableView.reloadData()
                for emp in ((models.data?.availableUsers)!) {
                    self?.nameArray.append(emp.name ?? "")
                  //  self?.assignDropDown.text = emp.name
                }
                self?.assignDropDown.optionArray = self?.nameArray ?? [""]
             }
             else if (models.status == 0 ){
             }
         }){ [weak self] (error) in
         }
     }
    func assign_user(emp :String, LevelId : String , projectID : String){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(AssignModel.self, router: .assign_user( emp: emp, level_id: LevelId, project_id: projectID,sender:userId!), success: { [weak self] (models) in
            self?.assign = models
            print("models\( models)")
            if(models.status == 1){
            
                self?.tableView.reloadData()
                self?.selectedUser = ""
                self?.assignDropDown.text = self?.selectedUser
                self?.get_assigned_users(LevelId: LevelId)
//                for emp in ((self?.assign?.data?.availableUsers)!) {
//                 //   self?.nameArray = [""]
//                self?.nameArray.append(emp.name ?? "")
//               // self?.tableView.insertRows(at: [IndexPath(row: (self?.assign?.data?.assignedUsers?.count ?? 0) - 1, section: 0)], with: .automatic)
//                             //  self?.assignDropDown.text = emp.name
//            }
//                    self?.assignDropDown.optionArray = self?.nameArray ?? [""]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func remove_assign_user(permission :String, empId : String , index: IndexPath){
        NetworkClient.performRequest(AssignModel.self, router: .remove_assign_user(permission_id: permission, emp_id: empId), success: { [weak self] (models) in
                print("models\( models)")
                if(models.status == 1){
                    self?.assign?.data?.assignedUsers?.remove(at: index.row)
                    self?.tableView.deleteRows(at: [index], with: .left)
                    self!.get_assigned_users(LevelId: self!.LevelId)
//                    for emp2 in (models.data?.availableUsers)! {
//                     //   self?.nameArray = [""]
//                        self?.nameArray.append(emp.name ?? "")
//                    }
//                    self?.assignDropDown.optionArray = self?.nameArray ?? [""]
                }
                else if (models.status == 0 ){
                }
            }){ [weak self] (error) in
            }
        }
}
