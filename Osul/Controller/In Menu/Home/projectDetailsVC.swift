//
//  projectAttachmentDetailsVC.swift
//  AL-HHALIL
//
//  Created by apple on 8/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import Alamofire
import JSSAlertView
import TransitionButton

class projectDetailsVC: UIViewController, UIGestureRecognizerDelegate {
    
//     lazy var fileData = Data()
    @IBOutlet weak var dataTF: UITextField!
    @IBOutlet weak var commentsTF: UITextView!
    @IBOutlet weak var attachNameTF: UITextField!
    @IBOutlet weak var employeNameTF: UITextField!
    @IBOutlet weak var attachCollectionView: UICollectionView!
    @IBOutlet weak var rightAction: UIButton!
    @IBOutlet weak var wrongAction: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var saveBtn: TransitionButton!
    
    @IBOutlet weak var titleDetailsName: UILabel!
    var id = ""
    var levelName = ""
    var percentage = ""
    var pdf = ""
    var checkMark = ""
    var date = ""
    var projectId = ""
    var levelid = ""
    var docData : Data?
    var checkAttach = ""
    var levelData : MoreLevelDetailsModel?
    private let sectionInsets = UIEdgeInsets(top: 5.0,left: 5.0,bottom: 5.0,right: 5.0)
    var myNewView = UIView()
    var imageSelected = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getTokenReq()
    }
    func config(){
        showLoader(mainView: &myNewView)
       
        dataTF.isUserInteractionEnabled = false
        attachNameTF.isUserInteractionEnabled = false
        employeNameTF.isUserInteractionEnabled = false
        attachCollectionView.dataSource = self
        attachCollectionView.delegate = self
        attachCollectionView.registerCellNib(cellClass: attachCell.self)
        //attachCollectionView.backgroundColor = .black
        attachCollectionView.reloadData()
        get_details()
        attachNameTF.text = levelName
        employeNameTF.text = percentage
        titleDetailsName.text = "تفاصيل المرحلة / \(levelName)"
        progressView.isHidden = true
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
       
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func wrongButton(_ sender: UIButton) {
        self.checkMark = "0"
        rightAction.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        wrongAction.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        wrongAction.borderWidth = 1
        wrongAction.cornerRadius = 10

    }
    @IBAction func rightButton(_ sender: UIButton) {
        self.checkMark = "1"
        wrongAction.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        rightAction.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        rightAction.borderWidth = 1
        rightAction.cornerRadius = 10
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        saveBtn.startAnimation()
        print("checkMark eh \(self.checkMark)")
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        let params = ["emp_id": userId!, "state": checkMark ?? "" , "answer" :"", "comment":commentsTF.text ?? "" , "Pdf": docData ] as [String : Any]
        self.Doc(url:  Constants.baseURL + "project/update_Detail/\(id)", docData: docData, parameters: params, fileName: pdf)
    }
    
    @IBAction func addAttachButton(_ sender: UIButton) {
        
//      if levelData?.data?.isPDF == "1"{
        
        progressView.isHidden = false
        AttachmentHandler.shared.showAttachmentActionSheet(vc: self, sender: sender)
        AttachmentHandler.shared.imagePickedBlock = { (data , picData ,img) in
        /* get your image here */
            print("select \(data.lastPathComponent)")
            do{
                self.docData = picData
                self.pdf = data.lastPathComponent ?? ""
                self.levelData?.data?.pdf?.append(data.lastPathComponent ?? "" )
                self.attachCollectionView.insertItems(at: [IndexPath(row: (self.levelData?.data?.pdf?.count)! - 1, section: 0)])
                self.imageSelected = img
            }catch{
                    print(error)
            }
        }
        AttachmentHandler.shared.filePickedBlock = {(filePath) in
        /* get your file path url here */
            print("selectFile \(filePath)")
            do{
                self.docData =  try Data(contentsOf: filePath)
                self.pdf = filePath.lastPathComponent
                self.levelData?.data?.pdf?.append(filePath.lastPathComponent)
                self.attachCollectionView.insertItems(at: [IndexPath(row: (self.levelData?.data?.pdf?.count)! - 1, section: 0)])
            }catch{
                print(error)
            }
        }
  //  }
    }
    @IBAction func deletrLevel(_ sender: UIButton) {
        deleteLevel()
    }

  

}


extension projectDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelData?.data?.pdf?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = attachCollectionView.dequeue(indexPath: indexPath) as attachCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - (8 * 4) - 15) / 4
        print(width)
        return CGSize(width: width, height: width + 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var fullPath: String = levelData?.data?.pdf![indexPath.row] ?? ""
        let fullPathArr = fullPath.split(separator: ".")
        var lastpath = fullPathArr[1]
        print("it is\(lastpath)")
        //print("sleep \(levelData?.data?.pdf![indexPath.row])")
        if lastpath == "pdf"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "DisplayPdfVC") as! DisplayPdfVC
            let fileName = levelData?.data?.pdf?[indexPath.row]
            view.stringurl =  Constants.baseURL2 + "images/\(fileName ?? "")"
            self.navigationController?.pushViewController(view, animated: true) 
        }else if lastpath == "jpeg"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = levelData?.data?.pdf?[indexPath.row]
            view.image =  Constants.baseURL2 + "images/\(fileName ?? "")"
            view.selected = imageSelected
            self.navigationController?.pushViewController(view, animated: true)
            
        }else if lastpath == "png"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = levelData?.data?.pdf?[indexPath.row]
            view.image =  Constants.baseURL2 + "images/\(fileName ?? "")"
            view.selected = imageSelected
            self.navigationController?.pushViewController(view, animated: true)
            
        }else if lastpath == "jpg"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "ImageDisplayVC") as! ImageDisplayVC
            let fileName = levelData?.data?.pdf?[indexPath.row]
            view.image =  Constants.baseURL2 + "images/\(fileName ?? "")"
            view.selected = imageSelected
            self.navigationController?.pushViewController(view, animated: true)
            
        }
    }
}


extension projectDetailsVC{
    func get_details(){
        NetworkClient.performRequest(MoreLevelDetailsModel.self, router: .get_one_level_detail(levelId: id), success: { [weak self] (models) in
            print("models\( models)")
            self?.levelData = models
           
            if(models.status == 1){
                self?.attachCollectionView.reloadData()
                self?.attachNameTF.text = models.data?.title
                self?.titleDetailsName.text = "تفاصيل المرحلة / \(models.data?.title ?? "")"
                self?.employeNameTF.text = models.data?.percent
                if models.data?.date == nil {
                    self?.dataTF.text = self?.date
                }else{
                   self?.dataTF.text = models.data?.date
            }
                self?.commentsTF.text = models.data?.comment
                if models.data?.state == "0" {
                    self?.checkMark = "0"
                    self?.wrongAction.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                    self?.wrongAction.borderWidth = 1
                }else if models.data?.state == "1" {
                    self?.checkMark = "1"
                    self?.rightAction.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                    self?.rightAction.borderWidth = 1
                }
                self?.hideLoader(mainView: &self!.myNewView)
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    func deleteLevel(){
        NetworkClient.performRequest(DeleteChatMessegeModel.self, router: .deleteLevelDetails(id: id), success: { [weak self] (models) in
          //  self?.assign = models
           print("models\( models.data)")
            if(models.status == 1){

                let alertview = JSSAlertView().success(self!,title : "حسنا",text: models.arMsg, buttonText: "موافق")
               alertview.addAction {
                self?.navigationController?.popViewController(animated: true)
               }
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
        }
    }
    func Doc(url: String, docData: Data?, parameters: [String : Any], onCompletion: (() -> Void)? = nil, onError: ((Error?) -> Void)? = nil, fileName: String){
             let headers: HTTPHeaders = [
                 "Content-type": "multipart/form-data"
             ]
             AF.upload(multipartFormData: { (multipartFormData) in
                let fullPathArr = fileName.split(separator: ".")
                var lastpath = fullPathArr.last
                print(lastpath)
                if lastpath == "pdf"{
                    if let data = docData{
                        multipartFormData.append(data, withName: "pdf[]", fileName: "file.pdf", mimeType: "application/pdf")
                    }
                }else if lastpath == "png"{
                    if let data = docData{
                        multipartFormData.append(data, withName: "pdf[]", fileName: "file.jpg", mimeType: "application/jpg")
                    }
                }else{
                    if let data = docData{
                        multipartFormData.append(data, withName: "pdf[]", fileName: "file.jpg", mimeType: "application/jpg")
                    }
                }

                 for (key, value) in parameters {
                     multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                 }
             }, to: url, method: .post, headers: headers) .responseJSON { response in
                switch response.result{
                 case .success(let upload):
                    
//                    upload.uploadProgress(closure: { (Progress) in
//                        self.progressView.progress = Float(Progress.fractionCompleted)
//                    print("Upload Progress: \(Progress.fractionCompleted)")
//                    })

                         print("Succesfully uploaded")
                         self.saveBtn.stopAnimation()
                         JSSAlertView().success(self,title: "حسنا",text: "تم الحفظ بنجاح")
                            self.navigationController?.popViewController(animated: true)
                         if let err = response.error{
                             onError?(err)
                            self.saveBtn.stopAnimation()
                            JSSAlertView().danger(self, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
                             return
                         }
                     
                 case .failure(let error):
                     print("Error in upload: \(error.localizedDescription)")
                     self.saveBtn.stopAnimation()
                     onError?(error)
                 }
             }
           self.saveBtn.stopAnimation()
         }

//    func edit_details(){
//        AppDelegate.LevelID = Int(id)
//        NetworkClient.performRequest(MoreLevelDetailsModel.self, router: .edit_details(title: attachNameTF.text ?? "", level_id: levelid, percent: employeNameTF.text ?? "", is_pdf: "", type: "", values: [""], question_type: "", project_id: projectId), success: { [weak self] (models) in
//            print("models\( models)")
//            self?.levelData = models
//            if(models.status == 1){
//                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
//            }
//            else if (models.status == 0 ){
//                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
//            }
//        }){ [weak self] (error) in
//        }
//    }


}

