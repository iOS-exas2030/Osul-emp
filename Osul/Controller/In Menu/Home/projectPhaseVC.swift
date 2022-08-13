//
//  prolectPhaseVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/4/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import TransitionButton
import MBCircularProgressBar
import JSSAlertView
import CoreLocation
import MapKit

class projectPhaseVC: BaseVC , UIGestureRecognizerDelegate, UITextFieldDelegate, MKMapViewDelegate ,CLLocationManagerDelegate  {

    @IBOutlet weak var projectPhaseCollectionView: UICollectionView!
    var projectId = ""
    var levelData : ProjectLevelsModel?
    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20.0,left: 20.0,bottom: 20.0,right: 20.0)
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var titleNameTF: UITextField!
    @IBOutlet weak var typeDropDown: DropDown!
    @IBOutlet weak var addLevelView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var projectProgress: MBCircularProgressBarView!
    @IBOutlet weak var deleteView: UIButton!
    @IBOutlet weak var deleteProjectBtn: UIButton!
    
    
    var projectName = ""
    var precentProgress = 0.0
    var projectStatus = ""
    var levelTypeId : String? = nil
    var locationManager: CLLocationManager!
    var deletedLevelId = ""
    var createdBy = ""
    var isCreated = ""
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()

   override func viewDidLoad() {
        super.viewDidLoad()
        config()
   }
   override func viewWillAppear(_ animated: Bool) {
        get_project_levels()
        getTokenReq()
   }
   func config(){
       addAllViews()
       configureLocationManager()
       projectPhaseCollectionView.dataSource = self
       projectPhaseCollectionView.delegate = self
       projectPhaseCollectionView.registerCellNib(cellClass: ProjectPhasesCell.self)
     //  projectPhaseCollectionView!.register(ProjectPhasesCell.self, forCellWithReuseIdentifier: "ProjectPhasesCell")
       self.projectPhaseCollectionView.alwaysBounceVertical = true
       let layout = UICollectionViewFlowLayout()
       layout.minimumLineSpacing = 1.0
       layout.minimumInteritemSpacing = 1.0
       get_project_levels()
        //if createdBy == UserDefaults.standard.value(forKey: "userId") as? String{
        //    deleteView.isHidden = false
        //}else{
        //    deleteView.isHidden = true
        //}
        let type =  UserDefaults.standard.value(forKeyPath: "jopType") as? String  ?? ""
        print("type \(type)")
        print("sayedisCreated \(isCreated)")
        if type == "3" && isCreated == "1"{
            deleteProjectBtn.isHidden = false
        }else{
            deleteProjectBtn.isHidden = true
        }
       addLevelView.isHidden = true
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.popViewHide))
       self.addLevelView.addGestureRecognizer(tap)
        typeDropDown.isUserInteractionEnabled = true
        typeDropDown.selectedRowColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        typeDropDown.optionArray = ["مرحلة تفاصيل داخلية", "مرفقات المشروع"]
        typeDropDown.rowHeight = 50
        typeDropDown.didSelect{(selectedText , index ,id) in
            if selectedText == "مرحلة تفاصيل داخلية" {
                self.levelTypeId = "1"
            }else if selectedText == "مرفقات المشروع"{
                self.levelTypeId = "3"
            }
       }
       titleLabel.text = "مراحل المشروع / \(projectName)"
       setLongPress()
       let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
       tap1.cancelsTouchesInView = false
       addLevelView.addGestureRecognizer(tap1)
       titleNameTF.delegate = self
   }
    @objc func dismissKeyboard() {
        view.endEditing(true)
        addLevelView.endEditing(true)
    }
    @objc func  popViewHide (){
        //addLevelView.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == titleNameTF){
            self.view.endEditing(true)
        }else if(textField == typeDropDown){
            self.view.endEditing(true)
        }
        return true
    }
    @IBAction func addButton(_ sender: UIButton) {
         addLevelView.isHidden = false
    }
    @IBAction func closeAdding(_ sender: Any) {
        addLevelView.isHidden = true
    }
    @IBAction func addLevel(_ sender: UIButton) {
        if(titleNameTF.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم المرحلة ", buttonText: "موافق")
        }else if(typeDropDown.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد نوع المرحلة", buttonText: "موافق")
        }else{
          addLevel()
        }
    }
    func setLongPress(){
         let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
         lpgr.minimumPressDuration = 0.5
         lpgr.delaysTouchesBegan = true
         lpgr.delegate = self
         self.projectPhaseCollectionView.addGestureRecognizer(lpgr)
    }
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer?) {
        if gestureRecognizer?.state != .ended {
            return
        }
        let p = gestureRecognizer?.location(in: projectPhaseCollectionView)

        let indexPath = projectPhaseCollectionView.indexPathForItem(at: p ?? CGPoint.zero)
        if indexPath == nil {
            print("couldn't find index path")
        } else {
            // get the cell at indexPath (the one you long pressed)
            var cell: UICollectionViewCell? = nil
            if let indexPath = indexPath {
                    cell = projectPhaseCollectionView.cellForItem(at: indexPath)
                    print(indexPath.row)
                if(levelData?.data[indexPath.row]?.createdBy == "1" && levelData?.data[indexPath.row]?.empID == (UserDefaults.standard.value(forKey: "userId") as? String)!){
                    deletedLevelId = levelData?.data[indexPath.row]?.id ?? ""
                    let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حذف المرحله؟",buttonText: "موافق",cancelButtonText: "إلغاء" )
                    alertview.addAction {
                       print("done")
                        self.deleteLevel()
                      //  self.ArchivedProject(projectId : self.projectData[indexPath.row].id ?? "", projectIndex: indexPath.row)
                    }
                    alertview.addCancelAction {
                        print("cancel")
                    }
                }
            }
            // do stuff with the cell
        }
    }
    @IBAction func deleteProject(_ sender: UIButton) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حذف المشروع ؟",
                        buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.deleteProject()
        }
        alertview.addCancelAction {
            print("cancel")
        }
        
        
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    @IBAction func locationAction(_ sender: UIButton) {
        print("levelData?.lat : \(levelData?.lat ?? "")")
        print("levelData?..lng : \(levelData?.lng ?? "")")
        if(levelData?.lat == "" || levelData?.lng == "" || levelData?.lat == "0.0" || levelData?.lng == "0.0"){
           // FailureAlert.instance.showAlert(MsgAlert: "العنوان غير محدد", btnMsg: "موافق")
            JSSAlertView().warning(self,title: "تنبيه !",text:  "العنوان غير محدد",buttonText: "موافق" )
            return
        }
        let alert = UIAlertController(title: "Maps", message: "Please Select Map", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "AlKhalil Map", style: .default , handler:{ (UIAlertAction)in
            
            let view = self.storyboard?.instantiateViewController(withIdentifier: "mapVC") as! mapVC
            view.longitude = self.levelData?.lng ?? ""
            view.latitude = self.levelData?.lat ?? ""
            view.projectName = self.projectName
            view.check = false
             self.navigationController?.pushViewController(view, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Apple Map", style: .default , handler:{ (UIAlertAction)in
            self.openMapForPlace()
        }))
        alert.addAction(UIAlertAction(title: "Google Map", style: .default , handler:{ (UIAlertAction)in
            self.openGoogleMap()
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        //uncomment for iPad Support
        // We need to provide a popover sourceView when using it on iPad
        alert.popoverPresentationController?.sourceView = sender as! UIView
        self.present(alert, animated: true, completion: {
            print("completion block")
        })

    }
}

extension projectPhaseVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelData?.data.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as ProjectPhasesCell
        cell.phaseName.text = levelData?.data[indexPath.row]?.title
        
//        if(self.levelData?.data[indexPath.row]?.percent  == "0.00"){
//            cell.phasesProgress.value = CGFloat(0.0)
//        }
//        else{
//            let percent = Double(self.levelData?.data[indexPath.row]?.percent ?? "")
//            cell.phasesProgress.maxValue = CGFloat(100.0)
//
//            let num = Double(self.levelData?.data[indexPath.row]?.progress ?? "")
//            let newValue = Double(num ?? 0.0) / Double(percent ?? 0.0)
//            let final = newValue  * 100.0
//            cell.phasesProgress.value = CGFloat(final)
//        }
        
        cell.notification.isHidden = true
        if(levelData?.data[indexPath.row]?.notification == "0"){
            cell.notification.isHidden = true
        }else{
            cell.notification.setTitle(levelData?.data[indexPath.row]?.notification, for: .normal)
        }
        if levelData?.data[indexPath.row]?.isRead == "0"{
          cell.chatNotification.isHidden = false
        }else{
          cell.chatNotification.isHidden = true
        }
        cell.projectBorderView.borderWidth = 0
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        if levelData?.data[indexPath.row]?.autoComplete == "1"{
          cell.stamp.isHidden = false
            let percent = Double(self.levelData?.data[indexPath.row]?.percent ?? "")
            cell.phasesProgress.value = CGFloat(100.0)
        }else{
          cell.stamp.isHidden = true
          if(self.levelData?.data[indexPath.row]?.percent  == "0.00"){
              cell.phasesProgress.value = CGFloat(0.0)
          }
          else{
              let percent = Double(self.levelData?.data[indexPath.row]?.percent ?? "")
              cell.phasesProgress.maxValue = CGFloat(100.0)

              let num = Double(self.levelData?.data[indexPath.row]?.progress ?? "")
              let newValue = Double(num ?? 0.0) / Double(percent ?? 0.0)
              let final = newValue  * 100.0
              cell.phasesProgress.value = CGFloat(final)
          }
        }

      //  cell.createdBy = levelData?.data[indexPath.row]?.createdBy
//        if(levelData?.data[indexPath.row]?.createdBy == "1"){
//          //  let color1 = #colorLiteral(red: 0.7734938264, green: 0.0884700045, blue: 0, alpha: 1)
//            cell.projectBorderView.borderWidth = 0
//            cell.projectBorderView.backgroundColor = #colorLiteral(red: 0.697083652, green: 0.2605850995, blue: 0.2016019523, alpha: 0.4848833476)
//            cell.phasesProgress.backgroundColor = #colorLiteral(red: 0.697083652, green: 0.2605850995, blue: 0.2016019523, alpha: 0)
//          //  cell.backgroundColor = #colorLiteral(red: 0.697083652, green: 0.2605850995, blue: 0.2016019523, alpha: 0.4848833476)
//        }else{
//            cell.projectBorderView.borderWidth = 0
//            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
        cell.prepareForReuse()
        //cell.notification.setTitle(levelData?.data[indexPath.row]?.no, for: .normal)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      return CGSize(width: widthPerItem, height: 230)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if levelData?.data[indexPath.row]?.type == "1"{
            let view = storyboard?.instantiateViewController(withIdentifier: "InteriorDesignVC") as! InteriorDesignVC
            view.id = (levelData?.data[indexPath.row]!.id)!
            view.jobType = (defaults.value(forKeyPath: "jopType") as? String ?? "")
            view.projectId = projectId
            view.projectName = projectName
            view.levelName = levelData?.data[indexPath.row]?.title ?? ""
            view.projectStatus = projectStatus
            view.autoComplete = levelData?.data[indexPath.row]?.autoComplete ?? ""
            self.navigationController?.pushViewController(view, animated: true)
        }else if levelData?.data[indexPath.row]?.type == "2"{
            let view = storyboard?.instantiateViewController(withIdentifier: "MeetUpVC") as! MeetUpVC
            view.id = (levelData?.data[indexPath.row]!.id)!
            view.projectId = projectId
            view.projectName = projectName
            view.levelName = levelData?.data[indexPath.row]?.title ?? ""
            view.projectStatus = projectStatus
            view.autoComplete = levelData?.data[indexPath.row]?.autoComplete ?? ""
            self.navigationController?.pushViewController(view, animated: true)
        }else if levelData?.data[indexPath.row]?.type == "3"{
            let view = storyboard?.instantiateViewController(withIdentifier: "ProjectAttachmentsVC") as! ProjectAttachmentsVC
            view.id = (levelData?.data[indexPath.row]!.id)!
            view.projectName = projectName
            view.levelName = levelData?.data[indexPath.row]?.title ?? ""
            view.jobType = (defaults.value(forKeyPath: "jopType") as? String ?? "")
            view.projectId = projectId
            view.projectStatus = projectStatus
            view.autoComplete = levelData?.data[indexPath.row]?.autoComplete ?? ""
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    
}
extension projectPhaseVC{
    @objc func get_project_levels(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            let userId = UserDefaults.standard.value(forKey: "userId") as? String
            NetworkClient.performRequest(ProjectLevelsModel.self, router: .get_project_levels(projectId: projectId, empId: userId!), success: { [weak self] (models) in
                print("models\( models)")
                if(models.status == 1){
                    self?.levelData = models
                    self?.projectPhaseCollectionView.reloadData()
                    self?.precentProgress = 0.0
                    for levelsCounter in models.data {
                        self?.precentProgress = Double(self?.precentProgress ?? 0.0) + (Double(levelsCounter?.progress ?? "0.0") ?? 0.0)
                    }
                    if(self?.levelData?.totalPercent  == "0.00"){
                       // cell.phasesProgress.value = CGFloat(0.0)
                    }else{
                        let percent = Double(self?.levelData?.totalPercent ?? "")
                        self?.projectProgress.maxValue = CGFloat(100.0)
                        
                        let num = Double(self?.precentProgress ?? 0.0)
                        let newValue = Double(num ?? 0.0) / Double(percent ?? 0.0)
                        let final = newValue  * 100.0
                        self?.projectProgress.value = CGFloat(final)
                    }
                    self?.hideAllViews()
                }
                else if (models.status == 2 ){
                        self?.hideAllViews()
                        self?.noDataView.isHidden = false
                        self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_project_levels), for: UIControl.Event.touchUpInside)
                }
                else if (models.status == 0){
                    JSSAlertView().warning(self!,title: "تنبيه !",text: models.arMsg,buttonText: "موافق" )
                    self?.navigationController?.popViewController(animated: true)
                }
            }){ [weak self] (error) in
                        self?.hideAllViews()
                        self?.errorView.isHidden = false
                        self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_project_levels), for: UIControl.Event.touchUpInside)
            }
        }else{
                    hideAllViews()
                    noInterNetView.isHidden = false
                    self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_project_levels), for: UIControl.Event.touchUpInside)
        }
    }
    
    func addLevel(){
        NetworkClient.performRequest(AddLevelModel.self, router: .addLevel(title: titleNameTF.text ?? "", percent: "0", contract_id: levelData?.data[0]?.contractID ?? "", type: levelTypeId!, project_id: (levelData?.data[0]!.projectID)!, emp_id: (UserDefaults.standard.value(forKey: "userId") as? String)!), success: { [weak self] (models) in
           //  self?.assign = models
            print("models\( models.data)")
             if(models.status == 1){

                let alertview = JSSAlertView().success(self!,title : "حسنا",text: "تم الحفظ بنجاح", buttonText: "موافق")
                alertview.addAction {
                    self?.addLevelView.isHidden = true
                    self?.get_project_levels()
                   // self?.projectPhaseCollectionView.reloadData()
                    
                }
             }
             else if (models.status == 0 ){
             }
         }){ [weak self] (error) in
         }
     }
    
    func deleteLevel(){
       NetworkClient.performRequest(status2Model.self, router: .deleteLevel(level_id: deletedLevelId, project_id: projectId, emp_id: (UserDefaults.standard.value(forKey: "userId") as? String)!), success: { [weak self] (models) in
          //  self?.assign = models
           print("models\( models.data)")
            if(models.status == 1){

                let alertview = JSSAlertView().success(self!,title : "حسنا",text: models.arMsg, buttonText: "موافق")
               alertview.addAction {
                   self?.get_project_levels()
               }
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
        func deleteProject(){
            NetworkClient.performRequest(DeleteChatMessegeModel.self, router: .DeleteProject(project_id: projectId), success: { [weak self] (models) in
               //  self?.assign = models
                print("models\( models.data)")
                 if(models.status == 1){
                       self?.navigationController?.popViewController(animated: true)
                    self!.view.makeToast("تم الحذف بنجاح", duration: 3.0, position: .bottom)
    
                 }
                 else if (models.status == 0 ){
    
                 }
             }){ [weak self] (error) in
             }
         }

}
// MARK: - CLLocationManagerDelegate
extension projectPhaseVC {
    

    func openMapForPlace() {
        let latitude: CLLocationDegrees = Double(levelData?.lat ?? "0.0")!
        let longitude: CLLocationDegrees = Double(levelData?.lng ?? "0.0")!

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
       // mapItem.name = levelData?.data?.name
        mapItem.openInMaps(launchOptions: options)
    }
    
    func openGoogleMap() {
         if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(levelData?.lat ?? "0.0"),\(levelData?.lng ?? "0.0")&directionsmode=driving") {
                       UIApplication.shared.open(url, options: [:])
              }}
         else {
                //Open in browser
               if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(levelData?.lat ?? "0.0"),\(levelData?.lng ?? "0.0")&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
    }
}
//MARK: - Loader
extension projectPhaseVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد مراحل بالمشروع حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
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
