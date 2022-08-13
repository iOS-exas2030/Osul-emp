//
//  ContractDetailsVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/23/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import DLRadioButton
import TransitionButton
import DropDown
import MBCircularProgressBar
import CoreLocation
import MapKit

class ContractDetailsVC: BaseVC,UITextViewDelegate , UITextFieldDelegate, MKMapViewDelegate ,CLLocationManagerDelegate{
    
    //MARK: - IBOutlets
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var clientNameTextField: UITextField!
    @IBOutlet weak var orderDateTextField: UITextField!
    @IBOutlet weak var clientPhoneTextField: UITextField!
    @IBOutlet weak var openMapBtn: UIButton!
    
    @IBOutlet weak var contractTypeDropDown: DropDown!
    
    @IBOutlet weak var progressBar: MBCircularProgressBarView!
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var canceBtn: UIButton!
    
    @IBOutlet weak var estbianStatus: UIButton!
    @IBOutlet weak var priceOfferStatus: UIButton!
    @IBOutlet weak var contractStatus: UIButton!
    @IBOutlet weak var financialInfoStatus: UIButton!
    @IBOutlet weak var startWorkStatus: UIButton!
    
    
    var paisData = ["","",""]
    var progress = ""
    
    //MARK: - Properties
    var AllContractArray = [ContractsDatum]()
    var projectData = [contractDetailsProject]()
    var contratModel : ContractDetails?
    var contractArray = [String]()
    var selectedContract : Int!
    var isChecked = false
    var projectId = ""
    var ContractDetails1111 : contractDetailsProject!
    var selectedContractOBJ : OrderDataContract!
    let defaults = UserDefaults.standard
    var shareNumber = 0
    var shareType : Int = 0
    var selectedLong :Double = 0
    var selectedLat :Double = 0
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var shareservyProjectBtn: UIButton!
    @IBOutlet weak var deleteServyProjectBtn: UIButton!
    @IBOutlet weak var sharePriceOfferBtn: UIButton!
    @IBOutlet weak var deletePriceOfferBtn: UIButton!
    @IBOutlet weak var shareContractBtn: UIButton!
    @IBOutlet weak var deleteContractBtn: UIButton!
    @IBOutlet weak var shareFinancialInfoBtn: UIButton!
    @IBOutlet weak var DeleteFinancialInfoBtn: UIButton!
    @IBOutlet weak var shareReviewBtn: UIButton!

    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    var contractDone = false
    var projectPercent = ""
    
    
    //MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.isHidden = true
        canceBtn.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isTranslucent = false
        config()
        getTokenReq()
    }
    
    func config(){
        addAllViews()
        contractDone = false
       // openPaidProjectReq()
        
        configureLocationManager()
        contractDetails()
        saveBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        canceBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        clientPhoneTextField.delegate = self
        let tap4: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(enableDditOrderdetails))
        editView.addGestureRecognizer(tap4)
        let tap7: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap7.cancelsTouchesInView = false
        view.addGestureRecognizer(tap7)
        self.contractTypeDropDown.didSelect { (selectedText , index ,id) in
            self.selectedContract = index
            self.contractDone = true
        }
        clientNameTextField.delegate = self
        
        if(projectPercent  == "0"){
            progressBar.value = CGFloat(0.0)
        }else{
            let percent = Double(projectPercent)
            progressBar.maxValue = CGFloat(100.0)
            
            let num = Double(progress)
            let newValue = Double(num ?? 0.0) / Double(percent ?? 0.0)
            let final = newValue  * 100.0
            progressBar.value = CGFloat(final)
        }
        
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        if(clientNameTextField.text == ""){
            JSSAlertView().danger(self, title: "عذرا", text: "ادخل اسم العميل", buttonText: "موافق")
        }else if(clientPhoneTextField.text == ""){
            JSSAlertView().danger(self, title: "عذرا", text: "ادخل رقم الهاتف", buttonText: "موافق")
        }else{
            clientPhoneTextField.isEnabled = false
            contractTypeDropDown.isEnabled = false
            clientNameTextField.isEnabled = false
            openMapBtn.isEnabled = false
            
            openMapBtn.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            clientPhoneTextField.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            contractTypeDropDown.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            clientNameTextField.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            editView.isHidden = false
            saveBtn.isHidden = true
            canceBtn.isHidden = true
            
            clientNameTextField.text = self.projectData[0].name
            clientPhoneTextField.text = self.projectData[0].phone
            self.contractTypeDropDown.text = self.selectedContractOBJ.title
            if(self.selectedContractOBJ.title == "default"){
                self.contractTypeDropDown.text = ""
            }else{
                self.contractTypeDropDown.text = self.selectedContractOBJ.title
            }
            self.selectedLat = 0
            self.selectedLong = 0
        }
    }

    @IBAction func saveAction(_ sender: Any) {
        if(clientNameTextField.text == ""){
           JSSAlertView().danger(self, title: "عذرا", text: "ادخل اسم العميل", buttonText: "موافق")
        }else if(clientPhoneTextField.text == ""){
           JSSAlertView().danger(self, title: "عذرا", text: "ادخل رقم الهاتف", buttonText: "موافق")
        }else if(contractDone == false){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع العقد", buttonText: "موافق")
        }else{
            clientPhoneTextField.isEnabled = false
            contractTypeDropDown.isEnabled = false
            clientNameTextField.isEnabled = false
            openMapBtn.isEnabled = false
            
            openMapBtn.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            clientPhoneTextField.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            contractTypeDropDown.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            clientNameTextField.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            editContractData()
            editView.isHidden = false
            saveBtn.isHidden = true
            canceBtn.isHidden = true
        }
    }
    @IBAction func mapAction(_ sender: Any) {
        print("projectData?.lat : \(self.projectData[0].lat ?? "")")
            print("projectData?.lng : \(self.projectData[0].lng ?? "")")

            let alert = UIAlertController(title: "Maps", message: "Please Select Map", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "AlKhalil Map", style: .default , handler:{ (UIAlertAction)in
                
                let view = self.storyboard?.instantiateViewController(withIdentifier: "mapVC") as! mapVC
                view.longitude = self.projectData[0].lng ?? ""
                view.latitude = self.projectData[0].lat ?? ""
                view.projectName = self.projectData[0].name ?? ""
                view.delegete = self as ReturnLocationDelegate
                 self.navigationController?.pushViewController(view, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Apple Map", style: .default , handler:{ (UIAlertAction)in
                if(self.projectData[0].lat == "" || self.projectData[0].lng == "" || self.projectData[0].lat == "0.0" || self.projectData[0].lng == "0.0"){
                   // FailureAlert.instance.showAlert(MsgAlert: "العنوان غير محدد", btnMsg: "موافق")
                    JSSAlertView().warning(self,title: "تنبيه !",text:  "العنوان غير محدد",buttonText: "موافق" )
                    return
                }else{
                 self.openMapForPlace()
                }
            }))
            alert.addAction(UIAlertAction(title: "Google Map", style: .default , handler:{ (UIAlertAction)in
                if(self.projectData[0].lat == "" || self.projectData[0].lng == "" || self.projectData[0].lat == "0.0" || self.projectData[0].lng == "0.0"){
                   // FailureAlert.instance.showAlert(MsgAlert: "العنوان غير محدد", btnMsg: "موافق")
                    JSSAlertView().warning(self,title: "تنبيه !",text:  "العنوان غير محدد",buttonText: "موافق" )
                    return
                }else{
                 self.openGoogleMap()
                }
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
    @objc func enableDditOrderdetails(){
      //  clientPhoneTextField.isEnabled = true
        contractTypeDropDown.isEnabled = true
     //   clientNameTextField.isEnabled = true
        openMapBtn.isEnabled = true

        
        openMapBtn.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
      //  clientPhoneTextField.borderColor = #colorLiteral(red: 0.7573977113, green: 0.1014090553, blue: 0.04029526561, alpha: 1)
        contractTypeDropDown.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
    //    clientNameTextField.borderColor = #colorLiteral(red: 0.7573977113, green: 0.1014090553, blue: 0.04029526561, alpha: 1)
        
        
        openMapBtn.borderWidth = 0.5
      //  clientPhoneTextField.borderWidth = 0.5
        contractTypeDropDown.borderWidth = 0.5
     //   clientNameTextField.borderWidth = 0.5
        
      //  clientPhoneTextField.cornerRadius = 5
        contractTypeDropDown.cornerRadius = 5
     //   clientNameTextField.cornerRadius = 5
        openMapBtn.cornerRadius = 5
        
        editView.isHidden = true
        saveBtn.isHidden = false
        canceBtn.isHidden = false
    }

    // Open Explanation
    @IBAction func openExplanationAction(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ExplanationsVC") as! ExplanationsVC
        view.projectId = projectId
        self.navigationController?.pushViewController(view, animated: true)
    }
    // First Survey
    @IBAction func openFirstSurvey(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        view.urlRequest =  Constants.baseURL2 + "admins/page/view_quest/\(projectId)/"
        self.navigationController?.pushViewController(view, animated: true)
    }
    //Project Survey
    @IBAction func openProjectSurvey(_ sender: Any) {
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        view.urlRequest =  Constants.baseURL2 + "admins/page/quest2/\(projectId)/\(userId!)"
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func shareProjectSurvey(_ sender: Any) {
     //   selectNotificationView.isHidden = false
         let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sendNotificationVC") as! sendNotificationVC
         vc2.shareNumber = 1
        vc2.clientID = projectData[0].clientID ?? ""
         vc2.projectID = self.projectId
         self.present(vc2, animated: true, completion: nil)
    }
    @IBAction func deleteProjectSurvey(_ sender: Any) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حذف الاستبيان ؟",buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.deleteProjectSurveyReq()
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
    //Price Offer
    @IBAction func openPriceOffer(_ sender: Any) {
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        view.urlRequest =  Constants.baseURL2 + "admins/page/edit_temp_price/\(projectId)/\(userId!)"
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func sharePriceOffer(_ sender: Any) {
        let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sendNotificationVC") as! sendNotificationVC
        vc2.shareNumber = 2
        vc2.clientID = projectData[0].clientID ?? ""
        vc2.projectID = self.projectId
         self.present(vc2, animated: true, completion: nil)
    }
    @IBAction func deletePriceOffer(_ sender: Any) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حذف عرض السعر ؟",buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.deletePriceOfferReq()
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
    //Contract
    @IBAction func openContract(_ sender: Any) {
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        view.urlRequest =  Constants.baseURL2 + "admins/page/edit_temp_template/\(projectId)/\(userId!)"
        self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func shareContract(_ sender: Any) {
          let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sendNotificationVC") as! sendNotificationVC
         vc2.shareNumber = 3
        vc2.clientID = projectData[0].clientID ?? ""
         vc2.projectID = self.projectId
         self.present(vc2, animated: true, completion: nil)
    }
    
    @IBAction func deleteContract(_ sender: Any) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حذف العقد ؟",
                        buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.deleteContractReq()
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
    //Transfer Money
    @IBAction func openTransferMoney(_ sender: Any) {
        let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "PaidVC") as! PaidVC
        vc2.projectID = projectId
        vc2.confirmedStatus = projectData[0].confirm ?? ""
        self.present(vc2, animated: true, completion: nil)
    }
    
    @IBAction func shareTransferMoney(_ sender: Any) {
        let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "sendNotificationVC") as! sendNotificationVC
        vc2.shareNumber = 4
        vc2.clientID = projectData[0].clientID ?? ""
        vc2.projectID = self.projectId
        self.present(vc2, animated: true, completion: nil)
    }
    
    @IBAction func deleteTransferMoney(_ sender: Any) {
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد حذف المعلومات الماليه ؟",
                        buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.deleteTransferMoneyReq()
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
    @IBAction func shareNotfi(_ sender: UIButton) {
        let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ReviewNotificationVC") as! ReviewNotificationVC
        vc2.clientID = projectData[0].clientID ?? ""
             vc2.projectID = self.projectId
             self.present(vc2, animated: true, completion: nil)
    }
    
    @IBAction func startProject(_ sender: Any) {
        if(contratModel?.data[0].project[0].isCreated == "1"){
                let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StartProjectVC") as! StartProjectVC
                   vc2.delegate = self
                   vc2.projectId = self.projectId
                vc2.confirmedStatus = projectData[0].confirm ?? ""
                vc2.confirmedDate = projectData[0].confirmDate ?? ""
                // vc2.projectId = self.projectId
                   self.present(vc2, animated: true, completion: nil)
        }else{
            if(contratModel?.data[0].project[0].estbianType == "1" && contratModel?.data[0].project[0].priceType == "1" && contratModel?.data[0].project[0].templateType == "1" && contratModel?.data[0].project[0].financialType == "1" && self.contractTypeDropDown.text != "" && self.contractDone == true){
                
                let vc2 = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StartProjectVC") as! StartProjectVC
                   vc2.delegate = self
                   vc2.projectId = self.projectId
                vc2.confirmedStatus = projectData[0].confirm ?? ""
                vc2.confirmedDate = projectData[0].confirmDate ?? ""
                // vc2.projectId = self.projectId
                   self.present(vc2, animated: true, completion: nil)
             }else{
                JSSAlertView().danger(self, title: "عذرا", text: "لا يمكن تفعيل المشروع دون اكمال كافه الاجراءات", buttonText: "موافق")
             }
        }
    }
}
// MARK: - CLLocationManagerDelegate
extension ContractDetailsVC {
    

    func openMapForPlace() {
        let latitude: CLLocationDegrees = Double(self.projectData[0].lat ?? "") ?? 0.0
        let longitude: CLLocationDegrees = Double(self.projectData[0].lng ?? "") ?? 0.0

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

            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(projectData[0].lat ),\(projectData[0].lng )&directionsmode=driving") {
                       UIApplication.shared.open(url, options: [:])
              }}
         else {
                //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(projectData[0].lat ),\(projectData[0].lng )&directionsmode=driving") {
                    UIApplication.shared.open(urlDestination)
                }
            }
    }
}

extension ContractDetailsVC: StarProjectDelegate{
    func reload() {
        self.contractDetails()
    }
}
//MARK: - Request
extension ContractDetailsVC{
    
        func get_all_contracts(id : String){
           NetworkClient.performRequest(Contracts.self, router: .get_all_contracts, success: { [weak self] (models) in
                if(models.status == 1){
                  for contractCounter in models.data {
                        self?.contractArray.append(contractCounter.title)
                        self!.AllContractArray.append(ContractsDatum(id: contractCounter.id, title: contractCounter.title, price: contractCounter.price, template: contractCounter.template, pdf: contractCounter.pdf, color: contractCounter.color))
                    if(contractCounter.id == id){
                        self!.selectedContract = self!.contractArray.count - 1
                    }
                  }
                  self?.contractTypeDropDown.optionArray = self?.contractArray ?? [""]
                  self?.contractTypeDropDown.rowHeight = 50
                }
               else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
               }
           }){ [weak self] (error) in
                    JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    
    @objc func contractDetails(){
            startAllAnimationBtn()
            if Reachability.connectedToNetwork() {
               NetworkClient.performRequest(ContractDetails.self, router: .contractDetails(id : projectId), success: { [weak self] (models) in
                  self?.contratModel = models
                   if(models.status == 1){
                        for contractCounter in models.data[0].contract{
                            let obJect = OrderDataContract(id: contractCounter.id, projectID: contractCounter.projectID, contractID: contractCounter.contractID, title: contractCounter.title, price: contractCounter.price, template: contractCounter.template, pdf: contractCounter.pdf, color: contractCounter.color)
                            self!.selectedContractOBJ = obJect
                        }
                        // stbianType
                        if(models.data[0].project[0].estbianType == "0"){
                            self?.estbianStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                        }else{
                            self?.estbianStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                        }
                        // priceType
                        if(models.data[0].project[0].priceType == "0"){
                            self?.priceOfferStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                        }else{
                            self?.priceOfferStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                        }
                        //templateType
                        if(models.data[0].project[0].templateType == "0"){
                            self?.contractStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                        }else{
                            self?.contractStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                        }
                        //financialType
                        if(models.data[0].project[0].financialType == "0"){
                            self?.financialInfoStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                        }else{
                            self?.financialInfoStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                        }
                        if(models.data[0].project[0].confirm == "0"){
                            self?.startWorkStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                        }else{
                            self?.startWorkStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                        }
                        if(self?.selectedContractOBJ.title == "default"){
                            self?.contractTypeDropDown.text = ""
                            self?.contractTypeDropDown.placeholder = "حدد نوع العقد"
                        }else{
                            self?.contractTypeDropDown.text = self!.selectedContractOBJ.title
                            self?.contractDone = true
                        }
                        
                        self?.get_all_contracts(id: self!.selectedContractOBJ.contractID)
                        ///
                        self?.projectData = models.data[0].project
                        self?.clientNameTextField.text = self?.projectData[0].name
                        let dateArr = self?.projectData[0].date?.split(separator: " ")
                    self?.orderDateTextField.text = "\(dateArr?[0] ?? "")"
                        let str = self?.projectData[0].phone
                    let index = str?.index((str?.endIndex)!, offsetBy: -9)
                    let mySubstring = str?.suffix(from: index!)
                        print(mySubstring)
                    self?.clientPhoneTextField.text = String(mySubstring!)
                        self?.mainLabel.text = "التعاقدات و المتابعه / \(self?.projectData[0].name ?? "")"
                    if(self?.projectData[0].confirm == "1"){
                        self?.shareservyProjectBtn.isEnabled = false
                        self?.deleteServyProjectBtn.isEnabled = false
                        self?.sharePriceOfferBtn.isEnabled = false
                        self?.deletePriceOfferBtn.isEnabled = false
                        self?.shareContractBtn.isEnabled = false
                        self?.deleteContractBtn.isEnabled = false
                        self?.shareFinancialInfoBtn.isEnabled = false
                        self?.DeleteFinancialInfoBtn.isEnabled = false
                        //self?.shareReviewBtn.isEnabled = false
                        self?.editView.isHidden = true
                    }
                        self?.hideAllViews()
                   }
                   else if (models.status == 0 ){
                        self?.hideAllViews()
                        self?.noDataView.isHidden = false
                        self?.refresDatahBtn.addTarget(self, action: #selector(self?.contractDetails), for: UIControl.Event.touchUpInside)
                   }
               }){ [weak self] (error) in
                        self?.hideAllViews()
                        self?.errorView.isHidden = false
                        self?.refreshErrorBtn.addTarget(self, action: #selector(self?.contractDetails), for: UIControl.Event.touchUpInside)
               }
            }else{
               hideAllViews()
               noInterNetView.isHidden = false
               self.refreshInterNetBtn.addTarget(self, action: #selector(self.contractDetails), for: UIControl.Event.touchUpInside)
            }
       }
    func editContractData(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        NetworkClient.performRequest(ContractDetails.self, router: .editContractData(project_id: projectId, emp_id: userId!, phone: "966" + clientPhoneTextField.text!, contract_id: AllContractArray[selectedContract].id, lat: String(selectedLat), lng: String(selectedLong), name: clientNameTextField.text!), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح", buttonText: "موافق")
                ///
                self!.projectData = models.data[0].project
                self!.clientNameTextField.text = self!.projectData[0].name
                let dateArr = self!.projectData[0].date?.split(separator: " ")
                self!.orderDateTextField.text = "\(dateArr?[0] ?? "")"
                let str = self!.projectData[0].phone
                let index = str?.index((str?.endIndex)!, offsetBy: -9)
                let mySubstring = str?.suffix(from: index!)
                print(mySubstring)
                self!.clientPhoneTextField.text = String(mySubstring!)
                self!.mainLabel.text = "التعاقدات/ \(self?.projectData[0].name ?? "")"
                // stbianType
                if(models.data[0].project[0].estbianType == "0"){
                    self?.estbianStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                }else{
                    self?.estbianStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                }
                // priceType
                if(models.data[0].project[0].priceType == "0"){
                    self?.priceOfferStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                }else{
                    self?.priceOfferStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                }
                //templateType
                if(models.data[0].project[0].templateType == "0"){
                    self?.contractStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                }else{
                    self?.contractStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                }
                //financialType
                if(models.data[0].project[0].financialType == "0"){
                    self?.financialInfoStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                }else{
                    self?.financialInfoStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                }
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func deleteProjectSurveyReq(){
        NetworkClient.performRequest(statusModel.self, router: .deleteProjectSurvey(project_id: projectId, emp_id: (defaults.value(forKeyPath: "userId")! as? String)!),success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
                self!.view.makeToast("تم الحذف بنجاح", duration: 3.0, position: .bottom)
                 self?.estbianStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func deletePriceOfferReq(){
        NetworkClient.performRequest(statusModel.self, router: .deletePriceOffer(project_id: projectId, emp_id: (defaults.value(forKeyPath: "userId")! as? String)!),success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
                self!.view.makeToast("تم الحذف بنجاح", duration: 3.0, position: .bottom)
                self?.priceOfferStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func deleteTransferMoneyReq(){
        NetworkClient.performRequest(statusModel.self, router: .remove_paid_project(project_id: projectId, emp_id: (defaults.value(forKeyPath: "userId")! as? String)!),success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //    JSSAlertView().success(self!,title: "حسنا",text: "تم المسح بنجاح", buttonText: "موافق")
                self!.view.makeToast("تم الحذف بنجاح", duration: 3.0, position: .bottom)
               // self!.totalPriceTextField.text = "0"
              //  self!.PaidPriceTextField.text = "0"
              //  self!.NotPaidTextField.text = "0"
                self!.paisData[0] = "0"
                self!.paisData[1] = "0"
                self!.paisData[2] = "0"
                self?.financialInfoStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func deleteContractReq(){
        NetworkClient.performRequest(statusModel.self, router: .remove_contract_template_data(project_id: projectId, emp_id: (defaults.value(forKeyPath: "userId")! as? String)!),success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
            //    JSSAlertView().success(self!,title: "حسنا",text: "تم الحذف بنجاح", buttonText: "موافق")
                self!.view.makeToast("تم الحذف بنجاح", duration: 3.0, position: .bottom)
                self?.contractStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
}
extension ContractDetailsVC : ReturnLocationDelegate {
    func locationBack(lat: Double, long: Double) {
        self.selectedLat = lat
        self.selectedLong = long
    }
}
//MARK: - Loader
extension ContractDetailsVC {
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد تعاقدات حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
        self.showLoader(mainView: &loaderView)
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
