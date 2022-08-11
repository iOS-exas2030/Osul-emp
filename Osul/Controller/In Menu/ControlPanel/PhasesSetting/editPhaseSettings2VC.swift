//
//  editPhaseSettings2.swift
//  AL-HHALIL
//
//  Created by apple on 7/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import DropDown
import JSSAlertView

class editPhaseSettings2VC: UIViewController {
    
//MARK: - IBOutlets
    @IBOutlet weak var edit_deleteStack: UIStackView!
    @IBOutlet weak var addNewButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var percentageTF: UITextField!
    @IBOutlet weak var levelNameTF: UITextField!
    @IBOutlet weak var typeDropDown: DropDown!
    @IBOutlet weak var dropDown : DropDown!
    
//MARK: - Properties
    var get_all_contract : Contracts?
    var level_details = [Level_DetailsDatum]()
    var levelModel : Level_Details?
    var level_id = ""
    var contract_name = ""
    var contractID = ""
    var phase : Levels?
    var names = [String]()
    var check = 0
    var chosenLevel : String = ""
    var addNew = true
    var contractArray = [String]()
    var selectedContract : String? = nil
    var levelTypeId : String? = nil
    var myNewView = UIView()
    var ids = [String]()
  
//MARK: - View Controller Builder
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    override func viewWillAppear(_ animated: Bool) {
       // tableView.reloadData()
        self.getTokenReq()
        if(addNew == true){
        }else{
            get_level_details_by_level(id: level_id)
        }
    }
 
    func config(){
        //showLoader(mainView: &myNewView)
       if(addNew == true){
            edit_deleteStack.isHidden = true
            dropDown.text = contract_name
            selectedContract = contractID
            self.hideLoader(mainView: &self.myNewView)
        }else{
            addNewButton.isHidden = true
            get_level_info(id: level_id)
            selectedContract = contractID
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.dragInteractionEnabled = true // Enable intra-app drags for iPhone.
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        
        tableView.reloadData()
        get_all_contracts()
        dropDown.selectedRowColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        dropDown.rowHeight = 50
        
        self.dropDown.didSelect{(selectedText , index ,id) in
            self.selectedContract = self.get_all_contract?.data[index].id
        }
        typeDropDown.didSelect{(selectedText , index ,id) in
            if selectedText == "مرحلة تفاصيل داخلية" {
                self.levelTypeId = "1"
                self.chosenLevel = "مرحلة تفاصيل داخلية"
            }else if selectedText == "مرحلة الاستبيانات"{
                self.levelTypeId = "2"
                self.chosenLevel =  "مرحلة الاستبيانات"
            }else if selectedText == "مرفقات المشروع"{
                self.levelTypeId = "3"
                self.chosenLevel =  "مرفقات المشروع"
            }
        }
        typeDropDown.isUserInteractionEnabled = true
        typeDropDown.selectedRowColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        typeDropDown.optionArray = ["مرحلة تفاصيل داخلية", "مرحلة الاستبيانات", "مرفقات المشروع"]
        typeDropDown.rowHeight = 50
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
   // add new levelDetails Button
    @IBAction func addLevelButton(_ sender: UIButton) {
        if chosenLevel == "مرحلة تفاصيل داخلية"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "InternalDetailsVC") as! InternalDetailsVC
            view.internalbackDelegate = self
            view.levelid = level_id
            view.levelType = "1"
            self.navigationController?.pushViewController(view, animated: true)
        }else if chosenLevel == "مرحلة الاستبيانات"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "BeforeDesignVC") as! BeforeDesignVC
            view.beforebBackDelegate = self
            view.levelid = level_id
            view.levelType = "2"
            self.navigationController?.pushViewController(view, animated: true)
        }else if chosenLevel == "مرفقات المشروع"{
            let view = self.storyboard?.instantiateViewController(withIdentifier: "AttatchmentVC") as! AttatchmentVC
            view.attachmentbackDelegate = self
            view.levelid = level_id
            view.levelType = "3"
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    @IBAction func addNew(_ sender: UIButton) {
        validation()
    }
    @IBAction func deleteButton(_ sender: UIButton) {
        remove_level(id: level_id)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        validation()
    }
    
    func validation(){
        if(levelNameTF.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال اسم المرحلة ", buttonText: "موافق")
        }else if(percentageTF.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء ادخال نسبة المرحلة ", buttonText: "موافق")
        }else if(typeDropDown.text == ""){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد نوع المرحلة", buttonText: "موافق")
        }else if(dropDown.text == "" ){
            JSSAlertView().danger(self, title: "خطأ", text: "برجاء تحديد نوع التعاقد", buttonText: "موافق")
        }else if(addNew == true){
               add_levels()
        }else{
              edit_level(id: level_id)
        }
    }
    //push data back to this view controller
     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepare(for: segue, sender: sender)
        let goNext = segue.destination as! BeforeDesignVC
        goNext.beforebBackDelegate = self
        let goNext2 = segue.destination as! InternalDetailsVC
        goNext2.internalbackDelegate = self
        let goNext3 = segue.destination as! AttatchmentVC
        goNext3.attachmentbackDelegate = self
    }
    @IBAction func arrangeAction(_ sender: Any) {
        let alertview = JSSAlertView().info(self,title: "تنبيه !",text: "هل تريد حفظ الترتيب  ؟",
                        buttonText: "موافق",cancelButtonText: "لاحقا" )
        alertview.addAction {
            self.controllersSortLevelsReq()
        }
        alertview.addCancelAction {
            print("cancel")
        }
    }
}
//MARK: - UITableView Delegate & DataSource
extension editPhaseSettings2VC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if level_details.count == 0  {
           typeDropDown.optionArray = ["مرحلة تفاصيل داخلية", "مرحلة الاستبيانات", "مرفقات المشروع"]
            print("11111")
            return levelModel?.data.count ?? 0
        }else  {
            typeDropDown.text = chosenLevel
            typeDropDown.optionArray = [ chosenLevel ]
            print("level count\(levelModel?.data.count)")
            print("22222")
            return levelModel?.data.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addLevelCell", for: indexPath) as! addLevelCell
        cell.levelLabel.text = levelModel?.data[indexPath.row].title
        cell.precLabel.text = (levelModel?.data[indexPath.row].percent ?? "") + " % "
        if(levelModel?.data[indexPath.row].isPDF == "0"){
            cell.attachmentImage.isHidden = true
        }
        cell.delete.addTarget(self, action: #selector(deleteRow(_ :)), for: .touchUpInside)
        if(levelModel?.data[indexPath.row].clientView == "0"){
            cell.displayStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
        }else{
            cell.displayStatus.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        }
        cell.selectedDisplayAction = {
            if(self.levelModel?.data[indexPath.row].clientView == "0"){
                self.projectLevelViewToClientReq(level_id: self.levelModel?.data[indexPath.row].id ?? "", type: "1")
                 cell.displayStatus.tintColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                self.levelModel?.data[indexPath.row].clientView = "1"
            }else{
                self.projectLevelViewToClientReq(level_id: self.levelModel?.data[indexPath.row].id ?? "", type: "0")
                 cell.displayStatus.tintColor = #colorLiteral(red: 0.3960784314, green: 0.1843137255, blue: 0.5568627451, alpha: 1)
                self.levelModel?.data[indexPath.row].clientView = "0"
            }
        }
        return cell
    }
    // delete levelDetails row 
    @objc func deleteRow(_ sender : UIButton){
        let point = sender.convert(CGPoint.zero, to: tableView)
         guard let indexpath = tableView.indexPathForRow(at: point) else {return}
        remove_level_details(id: (levelModel?.data[indexpath.row].id ?? ""), index: indexpath)
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50.0
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if levelModel?.data[indexPath.row].type == "1"{
                  let view = self.storyboard?.instantiateViewController(withIdentifier: "InternalDetailsVC") as! InternalDetailsVC
            view.id = (levelModel?.data[indexPath.row].id ?? "")
                  view.addNew = false
                  view.levelid = level_id
                  view.levelType = "1"
                  self.navigationController?.pushViewController(view, animated: true)
        }else if levelModel?.data[indexPath.row].type == "2"{
                  let view = self.storyboard?.instantiateViewController(withIdentifier: "BeforeDesignVC") as! BeforeDesignVC
            view.id = (levelModel?.data[indexPath.row].id ?? "")
                  view.addNew = false
                  view.levelid = level_id
                  view.levelType = "2"
                  self.navigationController?.pushViewController(view, animated: true)
        }else if levelModel?.data[indexPath.row].type == "3"{
                  let view = self.storyboard?.instantiateViewController(withIdentifier: "AttatchmentVC") as! AttatchmentVC
            view.id = (levelModel?.data[indexPath.row].id ?? "")
                  view.addNew = false
                  view.levelid = level_id
                  view.levelType = "3"
                  self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate

     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        levelModel?.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}
extension editPhaseSettings2VC: UITableViewDropDelegate {
    // MARK: - UITableViewDropDelegate
    
    /**
         Ensure that the drop session contains a drag item with a data representation
         that the view can consume.
    */
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return (levelModel?.canHandle(session))!
    }

    /**
         A drop proposal from a table view includes two items: a drop operation,
         typically .move or .copy; and an intent, which declares the action the
         table view will take upon receiving the items. (A drop proposal from a
         custom view does includes only a drop operation, not an intent.)
    */
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        // The .move operation is available only for dragging within a single app.
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    /**
         This delegate method is the only opportunity for accessing and loading
         the data representations offered in the drag item. The drop coordinator
         supports accessing the dropped items, updating the table view, and specifying
         optional animations. Local drags with one item go through the existing
         `tableView(_:moveRowAt:to:)` method on the data source.
    */
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            // Consume drag items.
            let stringItems = items as! [Level_DetailsDatum]
            
            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                self.levelModel?.addItem(item, at: indexPath.row)
                indexPaths.append(indexPath)
            }

            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
extension editPhaseSettings2VC: UITableViewDragDelegate {
    // MARK: - UITableViewDragDelegate
    
    /**
         The `tableView(_:itemsForBeginning:at:)` method is the essential method
         to implement for allowing dragging from a table.
    */
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return (levelModel?.dragItems(for: indexPath))!
    }
}

// delegate from BeforeDesignVC
extension editPhaseSettings2VC :beforeBackAction{
    func add(array: Level_DetailsDatum, controller: BeforeDesignVC) {
        
       self.levelModel?.data.append(array)
        tableView.insertRows(at: [IndexPath(row: self.names.count - 1, section: 0)], with: .automatic)
        typeDropDown.optionArray = [ chosenLevel ]
    }
}
// delegate from InternalDetailsVC
extension editPhaseSettings2VC :internalBackAction{
    func add(array: Level_DetailsDatum, controller: InternalDetailsVC) {
        self.levelModel?.data.append(array)
        tableView.insertRows(at: [IndexPath(row: (self.levelModel?.data.count ?? 0) - 1, section: 0)], with: .automatic)
        print("2nd")
        typeDropDown.optionArray = [ chosenLevel ]
    }
}
// delegate from AttatchmentVC
extension editPhaseSettings2VC :attatchmentBackAction{
    func add(array: Level_DetailsDatum, controller: AttatchmentVC) {
        self.levelModel?.data.append(array)
        tableView.insertRows(at: [IndexPath(row: self.names.count - 1, section: 0)], with: .automatic)
        print("3rd")
        typeDropDown.optionArray = [ chosenLevel ]
    }
}
//MARK: - Request
extension editPhaseSettings2VC{
    
    func get_level_info(id : String){
        NetworkClient.performRequest(Levels.self, router: .get_level_info(id: id), success: { [weak self] (models) in
               self?.phase = models
               print("models\( models)")
            if(models.status == 1){
                
                   self?.levelNameTF.text = self?.phase?.data[0].title
                   self?.percentageTF.text = self?.phase?.data[0].percent
                   self?.dropDown.text = self?.contract_name
                   self?.levelTypeId = self?.phase?.data[0].type
               
                if self?.phase?.data[0].type == "1"{
                    self?.typeDropDown.text = "مرحلة تفاصيل داخلية"
                    self?.chosenLevel = "مرحلة تفاصيل داخلية"
                }else if self?.phase?.data[0].type == "2"{
                    self?.typeDropDown.text = "مرحلة الاستبيانات"
                    self?.chosenLevel = "مرحلة الاستبيانات"
                }else if self?.phase?.data[0].type == "3"{
                    self?.typeDropDown.text = "مرفقات المشروع"
                    self?.chosenLevel = "مرفقات المشروع"
                }
                self?.hideLoader(mainView: &self!.myNewView)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
            }
           }){ [weak self] (error) in
            print("errrorrr")
           }
    }
        
    func add_levels(){
        NetworkClient.performRequest(Levels.self, router: .add_level(title: levelNameTF.text!, percent: percentageTF.text!, contract_id: selectedContract!, type: levelTypeId!), success: { [weak self] (models) in
            self?.phase = models
            print("models add level\( models)")
            if(models.status == 1){
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
                self?.navigationController?.popViewController(animated: true)
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    func edit_level(id : String){
        NetworkClient.performRequest(Levels.self, router: .edit_level(level_id: id , title: levelNameTF.text!, percent: percentageTF.text!, contract_id: selectedContract! , type: levelTypeId ?? ""), success: { [weak self] (models) in
            self?.phase = models
            print("models\( models)")
            if(models.status == 1){
             self?.navigationController?.popViewController(animated: true)
             JSSAlertView().success(self!,title: "حسنا",text: "تم التعديل بنجاح")
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
               JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func remove_level(id : String){
        NetworkClient.performRequest(Levels.self, router: .remove_level(id: id), success: { [weak self] (models) in
            self?.phase = models
            print("models\( models)")
            if(models.status == 1){
              self?.navigationController?.popViewController(animated: true)
              JSSAlertView().success(self!,title: "حسنا",text: "تم الحذف بنجاح")
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")

        }
    }
  
    func get_all_contracts(){
        NetworkClient.performRequest(Contracts.self, router: .get_all_contracts, success: { [weak self] (models) in
            self?.get_all_contract = models
            print("models\( models)")
            if(models.status == 1){
                for contractCounter in models.data {
                    self?.contractArray.append(contractCounter.title)
                    print("array\( self?.contractArray)")
                }
            self?.dropDown.optionArray = self?.contractArray ?? [""]
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
            }
    }
    
    func get_level_details_by_level(id : String){
        self.levelModel?.data.removeAll()
        NetworkClient.performRequest(Level_Details.self, router: .get_level_details_by_level(id: id), success: { [weak self] (models) in
            self?.levelModel = models
            print("aya\( models)")
            if(models.status == 1){
                print("sssss\(models.data)")
                for count in models.data{
//                    self?.level_details.append(Level_DetailsDatum(id: count.id, title: count.title, levelID: count.levelID, percent: count.percent, type: count.type, comment: count.comment, isPDF: count.isPDF, questionType: count.questionType, state: count.state, values: count.values, pdf: count.pdf))
                 //   self?.level_details = models.data
                   //self?.names.append(count.title)
                }
                self?.level_details = models.data
                print("names\(self?.levelModel?.data.count)")
               self?.tableView.reloadData()
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
            //JSSAlertView().danger(self!, title: "عذرا", text: "تأكد من اتصالك بالانترنت", buttonText: "موافق")
        }
    }
    func remove_level_details(id : String, index : IndexPath){
        NetworkClient.performRequest(Level_Details.self, router: .remove_level_details(id: id), success: { [weak self] (models) in
            self?.levelModel = models
            print("models\( models)")
            if(models.status == 1){
                self?.level_details.remove(at: index.row)
               // self?.levelModel?.data.remove(at: index.row)
                self?.levelModel?.data = self!.level_details
                self?.tableView.deleteRows(at: [index], with: .left)
                print("sayed abdo: \(self!.levelModel?.data.count)")
               // self?.tableView.reloadData()
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
    func projectLevelViewToClientReq(level_id : String, type : String){
        NetworkClient.performRequest(status2Model.self, router: .projectLevelViewToClient(level_id: level_id, type: type), success: { [weak self] (models) in
            print("models\( models)")
            if(models.status == 1){
               // self?.tableView.reloadData()
            }
            else if (models.status == 0 ){
            }
        }){ [weak self] (error) in
        }
    }
    
    func controllersSortLevelsReq(){
        ids.removeAll()
        for idsCounter in levelModel!.data{
            ids.append(idsCounter.id)
        }
        print(ids)
       NetworkClient.performRequest(status4Model.self, router: .controllersSortLevelsDetails(id: ids), success: { [weak self] (models) in
           print("models\( models.data)")
            if(models.status == 1){
                JSSAlertView().success(self!,title: "حسنا",text: "تم الحفظ بنجاح")
            }
            else if (models.status == 0 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "موافق")
            }
        }){ [weak self] (error) in
            JSSAlertView().danger(self!, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
        }
    }

}
