//
//  MailDetailsVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 8/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class MailDetailsVC: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var pdfCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var mainAttachmentView: UIView!
    @IBOutlet weak var mainAttachmentHeight: NSLayoutConstraint!
   
    @IBOutlet weak var commentTextView: UITextView!
    
    //MARK: - Properties
    var mailBox : MailDetailsModelDataClass?
    var mailBoxId : String!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,left: 5.0,bottom: 10.0,right: 5.0)
    private let itemsPerRow: CGFloat = 2
    var pdfs = [ArraySlice<String>]()
    
    @IBOutlet weak var moveLevelBtn: UIButton!
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    
    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
        getTokenReq()
    }
    func config(){
         addAllViews()
         get_user_mailBox()
         pdfCollectionView.dataSource = self
         pdfCollectionView.delegate = self
         let layout = UICollectionViewFlowLayout()
         layout.minimumLineSpacing = 1.0
         layout.minimumInteritemSpacing = 1.0
         self.pdfCollectionView.isHidden = false
        
         self.tableView.delegate = self
         self.tableView.dataSource = self
         tableView.registerHeaderNib(cellClass: newOrderTitleCell.self)
    }
    
    @IBAction func moveToLevelAction(_ sender: Any) {
        get_level_details()
    }
}
//MARK: - Request
extension MailDetailsVC{
//    @objc func get_user_mailbox(){
//     startAllAnimationBtn()
//     if Reachability.connectedToNetwork() {
//            NetworkClient.performRequest(OneMailBoxModel.self, router: .oneMailBox(id: mailBoxId), success: { [weak self] (models) in
//                self?.mailBox = models
//                if(models.status == 1){
//                    self?.pdfCollectionView.reloadData()
//                    self?.mainTitleLabel.text = "البريد الوارد / " + (models.data?.projectName ?? "")
//                    self?.dateLabel.text = (models.data?.date ?? "") + "   " + (models.data?.time ?? "")
//                    self?.titleLabel.text = "الموضوع : " + (models.data?.title ?? "")
//                    self?.commentLabel.text = "المشروع : " + (models.data?.comments ?? "")
//                    self?.projectNameLabel.text = "التفاصيل : " + (models.data?.projectName ?? "")
//
//                    if(models.data?.files.count == 0){
//                        self!.pdfCollectionView.isHidden = true
//                    }else{
//                        self!.pdfCollectionView.isHidden = false
//                    }
//                    self!.hideAllViews()
//                }
//                else if (models.status == 0 ){
//                     self!.hideAllViews()
//                     self!.noDataView.isHidden = false
//                     self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_user_mailbox), for: UIControl.Event.touchUpInside)
//                }
//            }){ [weak self] (error) in
//                self!.hideAllViews()
//                self!.errorView.isHidden = false
//                self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_user_mailbox), for: UIControl.Event.touchUpInside)
//            }
//     }else{
//        self.hideAllViews()
//        self.noInterNetView.isHidden = false
//        self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_user_mailbox), for: UIControl.Event.touchUpInside)
//    }
//    }
    
    @objc func get_user_mailBox(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(MailDetailsModel.self, router: .get_mailbox_Details(mail_id: mailBoxId, type: "1"), success: { [weak self] (models) in
                
                    if(models.status == 1){
                        self?.mailBox = models.data
                        self?.mainTitleLabel.text = "البريد الوارد / " + (models.data?.mails?[0].projectName ?? "")
                        self?.dateLabel.text = (models.data?.mails?[0].date ?? "") + "   " + (models.data?.mails?[0].time ?? "")
                        self?.titleLabel.text = "الموضوع : " + (models.data?.mails?[0].title ?? "")
                        self?.commentTextView.text = "المشروع : " + (models.data?.mails?[0].comments ?? "")
                        self?.projectNameLabel.text = "التفاصيل : " + (models.data?.mails?[0].projectName ?? "")

                        if(models.data?.mails?[0].levelID == "0"){
                            self?.moveLevelBtn.isHidden = true
                        }else{
                            self?.moveLevelBtn.isHidden = false
                        }
                        if(models.data?.files?.count == 0){
                            self?.pdfCollectionView.isHidden = false
                        }else{
                            self?.pdfCollectionView.isHidden = false
                        }
                        self?.pdfCollectionView.reloadData()
                        self?.tableView.reloadData()
                        if(models.data?.files?.count == 0){
                            self?.mainAttachmentView.isHidden = true
                            self?.mainAttachmentHeight.constant = 0
                        }
                        if(models.data?.replay?.count == 0){
                            self?.tableView.isHidden = true
                            
                        }
                        self?.hideAllViews()
                    }
                    else if (models.status == 2 ){
                        self?.hideAllViews()
                        self?.noDataView.isHidden = false
                        self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_user_mailBox), for: UIControl.Event.touchUpInside)
                    }
                }){ [weak self] (error) in
                        self?.hideAllViews()
                        self?.errorView.isHidden = false
                        self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_user_mailBox), for: UIControl.Event.touchUpInside)
                }
            }else{
                self.hideAllViews()
                self.noInterNetView.isHidden = false
                self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_user_mailBox), for: UIControl.Event.touchUpInside)
            }
    }
    @objc func get_level_details(){
      
        let userId = UserDefaults.standard.value(forKey: "userId") as? String

        NetworkClient.performRequest(LevelDetailsModel.self, router: .get_level_details(levelId: mailBox?.mails?[0].levelID ?? "", empId: userId!), success: { [weak self] (models) in
                print("models\( models)")
               // self?.levelData = models
                if(models.status == 1){
                    if models.data[0].type == "1"{
                        let view = self?.storyboard?.instantiateViewController(withIdentifier: "InteriorDesignVC") as! InteriorDesignVC
                        view.id = (models.data[0].levelID)!
                        view.projectId =  (models.data[0].projectID)!
                        view.levelName = self?.mailBox?.mails?[0].levelName ?? ""
                        self?.navigationController?.pushViewController(view, animated: true)
                    }else if models.data[0].type == "2"{
                        let view = self?.storyboard?.instantiateViewController(withIdentifier: "MeetUpVC") as! MeetUpVC
                        view.id = (models.data[0].levelID)!
                        view.projectId =  (models.data[0].projectID)!
                        view.levelName = self?.mailBox?.mails?[0].levelName  ?? ""
                        self?.navigationController?.pushViewController(view, animated: true)
                    }else if models.data[0].type == "3"{
                        let view = self?.storyboard?.instantiateViewController(withIdentifier: "ProjectAttachmentsVC") as! ProjectAttachmentsVC
                        view.id = (models.data[0].levelID)!
                        view.projectId =  (models.data[0].projectID)!
                        view.levelName = self?.mailBox?.mails?[0].levelName ?? ""
                        self?.navigationController?.pushViewController(view, animated: true)
                    }
                }
                else if (models.status == 2 ){
      
                }
            }){ [weak self] (error) in

            }
    }
//       @objc func get_project_levels(){
//
//               let userId = UserDefaults.standard.value(forKey: "userId") as? String
//        NetworkClient.performRequest(ProjectLevelsModel.self, router: .get_project_levels(projectId: mailBox?.mails?[0].projectID ?? "", empId: userId!), success: { [weak self] (models) in
//                   print("models\( models)")
//                   self?.levelData = models
//                   if(models.status == 1){
//                      if models?.data[indexPath.row]?.type == "1"{
//                          let view = storyboard?.instantiateViewController(identifier: "InteriorDesignVC") as! InteriorDesignVC
//                          view.id = (models?.data[indexPath.row]!.id)!
//
//                          self.navigationController?.pushViewController(view, animated: true)
//                      }else if models?.data[0]?.type == "2"{
//                          let view = storyboard?.instantiateViewController(identifier: "MeetUpVC") as! MeetUpVC
//                          view.id = (models?.data[indexPath.row]!.id)!
//
//                          self.navigationController?.pushViewController(view, animated: true)
//                      }else if models?.data[indexPath.row]?.type == "3"{
//                          let view = storyboard?.instantiateViewController(identifier: "ProjectAttachmentsVC") as! ProjectAttachmentsVC
//                          view.id = (models?.data[indexPath.row]!.id)!
//
//                          self.navigationController?.pushViewController(view, animated: true)
//                      }
//                   }
//                   else if (models.status == 2 ){
//
//                   }
//                   else if (models.status == 0){
//
//                   }
//               }){ [weak self] (error) in
//
//               }
//
//       }

}

//MARK: - UICollectionViewDelegate , UICollectionViewDataSource
extension MailDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mailBox?.files?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PdfMailBoxCell", for: indexPath) as! PdfMailBoxCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width: CGFloat = (collectionView.frame.width - (8 * 4) - 15) / 4
        print(width)
        return CGSize(width: width, height: width + 10)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullPath: String = mailBox?.files?[indexPath.row].file ?? ""
        let fullPathArr = fullPath.split(separator: ".")
        let lastpath = fullPathArr[1]
        if lastpath == "pdf"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "DisplayPdfVC") as! DisplayPdfVC
            let fileName = mailBox?.files?[indexPath.row].file ?? ""
            view.stringurl = Constants.baseURL2 + "images/\(fileName)"
            self.navigationController?.pushViewController(view, animated: true)
        }else if lastpath == "jpeg"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = mailBox?.files?[indexPath.row].file ?? ""
            view.image =  Constants.baseURL2 + "images/\(fileName)"
            self.navigationController?.pushViewController(view, animated: true)
        }else if lastpath == "png"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = mailBox?.files?[indexPath.row].file ?? ""
            view.image =  Constants.baseURL2 + "images/\(fileName)"
            self.navigationController?.pushViewController(view, animated: true)
        }else if lastpath == "jpg"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = mailBox?.files?[indexPath.row].file ?? ""
            view.image =  Constants.baseURL2 + "images/\(fileName)"
            self.navigationController?.pushViewController(view, animated: true)
        }
        let view = self.storyboard?.instantiateViewController(withIdentifier: "DisplayPdfVC") as! DisplayPdfVC
        view.stringurl = mailBox?.files?[indexPath.row].file
        self.navigationController?.pushViewController(view, animated: true)
    }
    

}
//MARK: - UITableView Delegate & DataSource
extension MailDetailsVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mailBox?.replay!.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MailReplayCell", for: indexPath) as! MailReplayCell
               cell.commentLabel.text = mailBox?.replay?[indexPath.row].comments
               cell.dateLabel.text = (mailBox?.replay?[indexPath.row].date ?? "") + "   " + (mailBox?.replay?[indexPath.row].time ?? "")
               cell.titleLabel.text = mailBox?.replay?[indexPath.row].title
               cell.files = mailBox?.replay?[indexPath.row].attachments ?? []
        if((mailBox?.replay?[indexPath.row].attachments?.count) ?? 0 == 0){
            cell.attachmentView.isHidden = true
        }else{
           // cell.attachmentView.isHidden = true
       }
               cell.filePressed = { Attachment in
                    let fullPath: String = Attachment.file ?? ""
                    let fullPathArr = fullPath.split(separator: ".")
                    let lastpath = fullPathArr[1]
                    if lastpath == "pdf"{
                       // let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let view = self.storyboard?.instantiateViewController(withIdentifier: "DisplayPdfVC") as! DisplayPdfVC
                        let fileName = Attachment.file ?? ""
                        view.stringurl = Constants.baseURL2 +  "images/\(fileName)"
                        self.navigationController!.pushViewController(view, animated: true)
                    }else if lastpath == "jpeg"{
                      //  let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
                        let fileName = Attachment.file ?? ""
                        view.image =  Constants.baseURL2 + "images/\(fileName)"
                        self.navigationController?.pushViewController(view, animated: true)
                    }else if lastpath == "png"{
                     //   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let view =  self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
                        let fileName = Attachment.file ?? ""
                        view.image =  Constants.baseURL2 + "images/\(fileName)"
                        self.navigationController?.pushViewController(view, animated: true)
                    }else if lastpath == "jpg"{
                     //   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
                        let fileName = Attachment.file ?? ""
                        view.image =  Constants.baseURL2 + "images/\(fileName)"
                        self.navigationController?.pushViewController(view, animated: true)
                    }
               }
            return cell
    }
}
//MARK: - Loader
extension MailDetailsVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد طلبات جديده حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
        self.showLoader(mainView: &loaderView)
        startAllAnimationBtn()
    }
    func hideAllViews(){
        self.hideLoader(mainView: &self.loaderView)
        self.hideNoDataView( mainNoDataView : &self.noDataView)
        self.hideNoInterNetView( mainNoInterNetView : &self.noInterNetView)
        self.hideErrorView( mainNoInterNetView : &self.errorView)
        stopAllAnimationBtn()
    }
    func stopAllAnimationBtn(){
        self.refresDatahBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
        self.refreshErrorBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
        self.refreshInterNetBtn.stopAnimation(animationStyle: .shake, revertAfterDelay: 2, completion:nil)
    }
    func startAllAnimationBtn(){
        refreshInterNetBtn.startAnimation()
        refresDatahBtn.startAnimation()
        refreshErrorBtn.startAnimation()
    }
}
