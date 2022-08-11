//
//  ArchiveProjectsVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/28/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView

class ArchiveProjectsVC: UIViewController {

   @IBOutlet weak var tableView: UITableView!
   var refreshControl = UIRefreshControl()
   var currentPage = 0
   var fromDateTF = ""
   var toDateTF = ""

   
    var ArchivedProject = [ArchiveProjectDataModelDatum]()
    var allArchivedProject : ArchiveProjectDataModel?
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         config()
    }
    override func viewWillAppear(_ animated: Bool) {
       reloadVC()
       getTokenReq()
    }
    func config(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerHeaderNib(cellClass: employeTitleCell.self)
    }
    @objc func reloadVC(){
        ArchivedProject.removeAll()
        currentPage = 0
        archiveProjectSearchReq()
    }
}
// table View
extension ArchiveProjectsVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArchivedProject.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArchiveProjectsCell", for: indexPath) as! ArchiveProjectsCell
        cell.projectNameLabel.text = ArchivedProject[indexPath.row].name
        cell.timeLabel.text = ArchivedProject[indexPath.row].date
        cell.projectTypeLabel.text = ArchivedProject[indexPath.row].projectType
        let num = Double(ArchivedProject[indexPath.row].progress)
        cell.projectProgress.value = CGFloat(num ?? 0)
        if(ArchivedProject[indexPath.row].isAccepted == "0"){
            cell.projectStatus.isHidden = false
        }else{
            cell.projectStatus.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(ArchivedProject[indexPath.row].isAccepted == "0"){
            
        }else{
            let view = storyboard?.instantiateViewController(withIdentifier: "projectPhaseVC") as! projectPhaseVC
            view.projectId = ArchivedProject[indexPath.row].id
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (ArchivedProject.count) - 1 {
            if(currentPage == (allArchivedProject?.config?.numLinks)! - 1){
            }else{
                currentPage = currentPage + 1
                archiveProjectSearchReq()
            }
        }
    }
}
// Request
extension ArchiveProjectsVC{
    func archiveProjectSearchReq(){
        NetworkClient.performRequest(ArchiveProjectDataModel.self, router: .getArchiveProjectData( date_in: fromDateTF, date_out: toDateTF, page: "\(currentPage)"), success: { [weak self] (models) in
            print("models\( models.data)")
            if(models.status == 1){
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "ArchiveProjectsVC") as! ArchiveProjectsVC
                view.ArchivedProject = models.data
                view.ArchivedProject = view.ArchivedProject.reversed()
                for archivedCounter in models.data.reversed(){
                    self?.ArchivedProject.append(archivedCounter)
                }
                self?.tableView.reloadData()
            }
            else if (models.status == 0 ){
                JSSAlertView().warning(self!, title: "عذرا", text: "لا توجد مشاريع بالارشيف", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
}

