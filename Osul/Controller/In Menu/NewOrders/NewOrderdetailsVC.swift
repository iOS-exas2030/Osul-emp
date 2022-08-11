//
//  NewOrderVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/19/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton
import CoreLocation
import MapKit

class NewOrderdetailsVC: UIViewController , UITextFieldDelegate,  MKMapViewDelegate ,CLLocationManagerDelegate {

    //MARK: - IBOutlets
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var explainTableView: UITableView!
    @IBOutlet weak var acceptBtn: TransitionButton!
    @IBOutlet weak var refuseBtn: TransitionButton!
    
    @IBOutlet weak var clientNameTextField: UITextField!
    @IBOutlet weak var orderDateTextField: UITextField!
    @IBOutlet weak var clientPhoneTextField: UITextField!
    @IBOutlet weak var contractTypeDropDown2: DropDown!
    @IBOutlet weak var openMapBtn: UIButton!
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addExplainView: UIView!
    @IBOutlet weak var canceBtn: UIButton!
    
    @IBOutlet weak var estbianStatus: UIButton!
    
    //MARK: - Properties
    var explanation = [ExplanationModelDatum]()
    var projectData = [OrderDataProject]()
    var selectedContractOBJ : OrderDataContract!
    var allData : OrderData?
    var projectId = ""
    var AllContractArray = [ContractsDatum]()
    var contractArray = [String]()
    var selectedContract = ""
    let defaults = UserDefaults.standard
    var contractDone = false
    var editStatus = false
    var myNewView = UIView()
    var selectedLong :Double = 0
    var selectedLat :Double = 0
    var currentPage = 0
    var locationManager: CLLocationManager!
    var explanations = [ExplanationModelDatum]()
    var allExplanations : ExplanationModel?

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
        saveBtn.isHidden = true
        canceBtn.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
        self.navigationController?.navigationBar.isTranslucent = false
        getTokenReq()
    }
    func config(){
        addAllViews()
        self.explainTableView.delegate = self
        self.explainTableView.dataSource = self
        acceptBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        refuseBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        getnewOrderDetails()
        configureLocationManager()
        saveBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        canceBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        //get_all_contracts()
        clientPhoneTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addExplain))
        addExplainView.addGestureRecognizer(tap)
        
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(enableDditOrderdetails))
        editView.addGestureRecognizer(tap1)

        self.contractTypeDropDown2.didSelect{(selectedText , index ,id) in
            self.contractDone = true
            self.selectedContract = self.AllContractArray[index].id
        }
        let tap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap2.cancelsTouchesInView = false
        view.addGestureRecognizer(tap2)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    @objc func addExplain(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "AddExplanationVC") as! AddExplanationVC
        view.projectId = projectId
        self.navigationController?.pushViewController(view, animated: true)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = "1234567890"
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        let maxLength = 9
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength && alphabet
    }

    @IBAction func cancelAction(_ sender: Any) {
        if(clientNameTextField.text == ""){
            JSSAlertView().danger(self, title: "عذرا", text: "ادخل اسم العميل", buttonText: "موافق")
        }else if(clientPhoneTextField.text == ""){
            JSSAlertView().danger(self, title: "عذرا", text: "ادخل رقم الهاتف", buttonText: "موافق")
        }else{
            editStatus = false
            clientPhoneTextField.isEnabled = false
            contractTypeDropDown2.isEnabled = false
            clientNameTextField.isEnabled = false
            openMapBtn.isEnabled = false
            
            openMapBtn.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            clientPhoneTextField.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            contractTypeDropDown2.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            clientNameTextField.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            editView.isHidden = false
            saveBtn.isHidden = true
            canceBtn.isHidden = true
            
            clientNameTextField.text = self.projectData[0].name
            let str = self.projectData[0].phone
            let index = str.index(str.endIndex, offsetBy: -9)
            let mySubstring = str.suffix(from: index)
            print(mySubstring)
            self.clientPhoneTextField.text = String(mySubstring)
            
            self.contractTypeDropDown2.text = self.selectedContractOBJ.title
            if(self.selectedContractOBJ.title == "default"){
                self.contractTypeDropDown2.text = ""
            }else{
                self.contractTypeDropDown2.text = self.selectedContractOBJ.title
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
        }else if(clientPhoneTextField.text?.count != 9){
            JSSAlertView().danger(self, title: "عذرا", text: "ادخل رقم الهاتف مكون من ٩ رقم", buttonText: "موافق")
        }else if(contractDone == false){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع العقد", buttonText: "موافق")
        }else{
            
            clientPhoneTextField.isEnabled = false
            contractTypeDropDown2.isEnabled = false
            clientNameTextField.isEnabled = false
            openMapBtn.isEnabled = false
            
            openMapBtn.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            clientPhoneTextField.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            contractTypeDropDown2.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            clientNameTextField.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            editOrderData()
            editView.isHidden = false
            saveBtn.isHidden = true
            canceBtn.isHidden = true
            
            editStatus = false
        }
    }
    @IBAction func mapAction(_ sender: UIButton) {
        print("projectData?.lat : \(self.projectData[0].lat ?? "")")
            print("projectData?.lng : \(self.projectData[0].lng ?? "")")

            let alert = UIAlertController(title: "Maps", message: "Please Select Map", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "AlKhalil Map", style: .default , handler:{ (UIAlertAction)in
                
                let view = self.storyboard?.instantiateViewController(withIdentifier: "mapVC") as! mapVC
                view.longitude = self.projectData[0].lng ?? ""
                view.latitude = self.projectData[0].lat ?? ""
                view.projectName = self.projectData[0].name
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
        editStatus = true
        clientPhoneTextField.isEnabled = true
        contractTypeDropDown2.isEnabled = true
        clientNameTextField.isEnabled = true
        openMapBtn.isEnabled = true

        openMapBtn.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        clientPhoneTextField.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        contractTypeDropDown2.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        clientNameTextField.borderColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        
        openMapBtn.borderWidth = 0.5
        clientPhoneTextField.borderWidth = 0.5
        contractTypeDropDown2.borderWidth = 0.5
        clientNameTextField.borderWidth = 0.5
        
        clientPhoneTextField.cornerRadius = 5
        contractTypeDropDown2.cornerRadius = 5
        clientNameTextField.cornerRadius = 5
        openMapBtn.cornerRadius = 5
        editView.isHidden = true
        saveBtn.isHidden = false
        canceBtn.isHidden = false
    }

    @IBAction func AcceptAction(_ sender: Any) {
        acceptBtn.startAnimation()
        if(editStatus == true){
            JSSAlertView().danger(self, title: "عذرا", text: "برجاء حفظ التعديلات", buttonText: "موافق")
            acceptBtn.stopAnimation()
        }
//        else if(contractDone == false){
//            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد نوع العقد", buttonText: "موافق")
//            acceptBtn.stopAnimation()
//        }
//        else if(selectedLong == 0){
//            JSSAlertView().danger(self, title: "عذرا", text: "برجاء تحديد الموقع", buttonText: "موافق")
//        }
        else{
            let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد قبول المشروع ؟",
                            buttonText: "موافق",cancelButtonText: "لاحقا" )
            alertview.addAction {
                self.acceptNewOrder()
            }
            alertview.addCancelAction {
                print("cancel")
                self.acceptBtn.stopAnimation()
            }
        }
    }
    
    @IBAction func refuseAction(_ sender: Any) {
         refuseBtn.startAnimation()
        let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد رفض الطلب ؟",
                        buttonText: "موافق",cancelButtonText: "إلغاء" )
        alertview.addAction {
            self.cancelNewOrder()
        }
        alertview.addCancelAction {
            print("cancel")
            self.refuseBtn.stopAnimation()
        }
    }
    
    @IBAction func openFirstSurvey(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        view.urlRequest =  Constants.baseURL2 + "admins/page/view_quest/\(projectId)"
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func openProjectSurvey(_ sender: Any) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as! WebViewVC
        view.urlRequest =  Constants.baseURL2 + "admins/page/quest2/\(projectId)"
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func shareProjectSurvey(_ sender: Any) {
        let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد ارسال إستبيان المشاريع ؟",
                        buttonText: "موافق",cancelButtonText: "لاحقا" )
        alertview.addAction {
            self.shareProjectSurveyReq()
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
}
//MARK: - UITableView Delegate & DataSource
extension NewOrderdetailsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return explanation.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "clientInfoNewOrderCell", for: indexPath) as! clientInfoNewOrderCell
            cell.fixedLabel.text = explanation[indexPath.row].title
            cell.changedLabel.text = explanation[indexPath.row].date
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "AddExplanationVC") as! AddExplanationVC
        view.currentExplanation = explanation[indexPath.row]
        view.addNew = false
        view.fromAll = false
        self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       if(allData?.config?.totalRows ?? 0 > 10){
        print(indexPath.row)
            if indexPath.row == (explanation.count) - 1 {
                if(currentPage == (allData?.config?.numLinks)! - 1){
                }else{
                    currentPage = currentPage + 1
                    getAllProjectExplanation()
                }
            }
        }
    }
}
// MARK: - CLLocationManagerDelegate
extension NewOrderdetailsVC {
    func openMapForPlace() {

        let latitude: CLLocationDegrees = Double(self.projectData[0].lat )!
        let longitude: CLLocationDegrees = Double(self.projectData[0].lng )!

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
//MARK: - Request
extension NewOrderdetailsVC{
    
    @objc func getnewOrderDetails(){
         startAllAnimationBtn()
         if Reachability.connectedToNetwork() {
                NetworkClient.performRequest(OrderData.self, router: .newOrderDetails(id: projectId), success: { [weak self] (models) in
                    print("models\( models)")
                    if(models.status == 1){
                        self?.allData = models
                        for contractCounter in models.data[0].contract{
                            let obJect = OrderDataContract(id: contractCounter.id, projectID: contractCounter.projectID, contractID: contractCounter.contractID, title: contractCounter.title, price: contractCounter.price, template: contractCounter.template, pdf: contractCounter.pdf, color: contractCounter.color)
                            self!.selectedContractOBJ = obJect
                        }
                        self!.contractTypeDropDown2.text = self!.selectedContractOBJ.title
                        if(self!.selectedContractOBJ.title == "default"){
                            self!.contractTypeDropDown2.text = ""
                        }else{
                            self!.contractTypeDropDown2.text = self!.selectedContractOBJ.title
                        }
                        self!.get_all_contracts(id: self!.selectedContractOBJ.contractID)
                        ///
                        if(self!.selectedContractOBJ.contractID == "1"){
                            self!.contractDone = false
                        }else{
                            self!.contractDone = true
                        }
                        if(models.data[0].project[0].estbianType == "0"){
                            self?.estbianStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                        }else{
                            self?.estbianStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                        }
                        
                        self!.projectData = models.data[0].project
                        self!.clientNameTextField.text = self!.projectData[0].name
                        let dateArr = self!.projectData[0].date.split(separator: " ")
                        self!.orderDateTextField.text = "\(dateArr[0])"
                        let str = self!.projectData[0].phone
                        let index = str.index(str.endIndex, offsetBy: -9)
                        let mySubstring = str.suffix(from: index)
                        print(mySubstring)
                        self!.clientPhoneTextField.text = String(mySubstring)
                        self!.mainLabel.text = "طلبات العملاء الجدد/ \(self!.projectData[0].name)"
                        ///
                        self!.explanation = models.data[0].explan
                        self!.explanation = self!.explanation.reversed()
                        self!.explainTableView.reloadData()
                        self!.hideAllViews()
                    }
                    else if (models.status == 0 ){
                        self!.hideAllViews()
                        self!.noDataView.isHidden = false
                        self?.refresDatahBtn.addTarget(self, action: #selector(self?.getnewOrderDetails), for: UIControl.Event.touchUpInside)
                    }
                }){ [weak self] (error) in
                        self!.hideAllViews()
                        self!.errorView.isHidden = false
                        self?.refreshErrorBtn.addTarget(self, action: #selector(self?.getnewOrderDetails), for: UIControl.Event.touchUpInside)
                }
         }else{
                   hideAllViews()
                   noInterNetView.isHidden = false
                   self.refreshInterNetBtn.addTarget(self, action: #selector(self.getnewOrderDetails), for: UIControl.Event.touchUpInside)
        }
    }
    
    func acceptNewOrder(){
        NetworkClient.performRequest(statusModel.self, router: .acceptNewOrder(emp_id: defaults.value(forKeyPath: "userId")! as! String, project_id: projectId), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
                self?.acceptBtn.stopAnimation()
                JSSAlertView().success(self!,title: "حسنا",text: models.arMsg)
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "NewOrdersVC") as! NewOrdersVC
                self?.navigationController?.pushViewController(view, animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                self?.acceptBtn.stopAnimation()
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
                self?.acceptBtn.stopAnimation()
        }
    }
    func cancelNewOrder(){
        NetworkClient.performRequest(statusModel.self, router: .cancelNewOrder(emp_id: defaults.value(forKeyPath: "userId")! as! String, project_id: projectId), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
              //  JSSAlertView().success(self!,title: "حسنا",text: "تم حذف المشروع بنجاح")
                self?.refuseBtn.stopAnimation()
                let view = self?.storyboard?.instantiateViewController(withIdentifier: "NewOrdersVC") as! NewOrdersVC
                self?.navigationController?.pushViewController(view, animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                self?.refuseBtn.stopAnimation()
            }
        }){ [weak self] (error) in
                JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
                self?.refuseBtn.stopAnimation()
        }
    }
    func get_all_contracts(id : String){
           NetworkClient.performRequest(Contracts.self, router: .get_all_contracts, success: { [weak self] (models) in
                if(models.status == 1){
                  for contractCounter in models.data {
                        self?.contractArray.append(contractCounter.title)
                        self!.AllContractArray.append(ContractsDatum(id: contractCounter.id, title: contractCounter.title, price: contractCounter.price, template: contractCounter.template, pdf: contractCounter.pdf, color: contractCounter.color))
                    if(contractCounter.id == id){
                        self!.selectedContract = "\(self!.contractArray.count - 1)"
                    }
                  }
                  self?.contractTypeDropDown2.optionArray = self?.contractArray ?? [""]
                  self?.contractTypeDropDown2.rowHeight = 50
                }
               else if (models.status == 0 ){
                    JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
               }
           }){ [weak self] (error) in
                    JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func editOrderData(){
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
        let final = formatter.number(from: clientPhoneTextField.text!)
        NetworkClient.performRequest(OrderData.self, router: .editOrderData(project_id: projectId, emp_id: defaults.value(forKeyPath: "userId")! as! String, phone:"966" +  "\(final!)", contract_id: selectedContract , lat: String(selectedLat), lng: String(selectedLong), name: clientNameTextField.text!), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
                
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح", buttonText: "موافق")
                ///
                self!.projectData = models.data[0].project
                self!.clientNameTextField.text = self!.projectData[0].name
                let dateArr = self!.projectData[0].date.split(separator: " ")
                self!.orderDateTextField.text = "\(dateArr[0])"
                if(models.data[0].project[0].estbianType == "0"){
                    self?.estbianStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                }else{
                    self?.estbianStatus.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                }
                let str = self!.projectData[0].phone
                let index = str.index(str.endIndex, offsetBy: -9)
                let mySubstring = str.suffix(from: index)
                print(mySubstring)
                self!.clientPhoneTextField.text = String(mySubstring)
                self!.mainLabel.text = "طلبات العملاء الجدد/ \(self!.projectData[0].name)"
                ///
                self!.explanation = models.data[0].explan
                self!.explanation = self!.explanation.reversed()
                self!.explainTableView.reloadData()
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func shareProjectSurveyReq(){
        NetworkClient.performRequest(statusModel.self, router: .shareMainProjectSurvey(project_id: projectId, client_id: projectData[0].clientID, contract_id: "1", emp_id: (defaults.value(forKeyPath: "userId")! as? String)!),success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
                self?.currentPage = 0
                self?.getAllProjectExplanation()
                JSSAlertView().success(self!,title: "حسنا",text: "تم إرسال الإشعار بنجاح", buttonText: "موافق")
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text:models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    
    
    @objc func getAllProjectExplanation(){
        NetworkClient.performRequest(ExplanationModel.self, router: .getAllProjectExplanation(id: projectId, currentPage: "\(currentPage)"), success: { [weak self] (models) in
                self?.allExplanations = models
                if(models.status == 1){
                    self?.explanation = models.data.reversed()
                    self!.explainTableView.reloadData()
                }
                else if (models.status == 0 ){
                     JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
                }
            }){ [weak self] (error) in
                   JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
    }
}
extension NewOrderdetailsVC : ReturnLocationDelegate {
    func locationBack(lat: Double, long: Double) {
        self.selectedLat = lat
        self.selectedLong = long
    }
}
//MARK: - Loader
extension NewOrderdetailsVC{
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
