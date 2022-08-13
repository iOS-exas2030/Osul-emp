//
//  editPhaseSettings1VC.swift
//  AL-HHALIL
//
//  Created by apple on 7/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton
import MBCircularProgressBar

class editPhaseSettings1VC: BaseVC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addNewButton: UIStackView!
    @IBOutlet weak var projectProgress: MBCircularProgressBarView!
    
    //MARK: - Properties
    var contract_id = ""
    var contract_name = ""
    var phase : Levels?
    var totalProcessValue = 0.0
    var ids = [String]()
    
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    
    @IBOutlet weak var arrangeBtn: TransitionButton!
    //MARK: - View Controller Builder
    override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
         config()
        
    }
    func config(){
      addAllViews()
      self.tableView.delegate = self
      self.tableView.dataSource = self
      self.tableView.dragInteractionEnabled = true // Enable intra-app drags for iPhone.
      self.tableView.dragDelegate = self
      self.tableView.dropDelegate = self
      get_level_by_contract()
      tableView.registerHeaderNib(cellClass: phaseTitleCell.self)
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addLevel))
      addNewButton.addGestureRecognizer(tap)
      addFBtn.addTarget(self, action: #selector(addLevel), for: UIControl.Event.touchUpInside)
      let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
      tap1.cancelsTouchesInView = false
      view.addGestureRecognizer(tap1)
      self.getTokenReq()
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func addLevel (){
         let view = self.storyboard?.instantiateViewController(withIdentifier: "editPhaseSettings2VC") as! editPhaseSettings2VC
         view.contract_name = contract_name
         view.contractID = contract_id
         self.hideAllViews()
         self.navigationController?.pushViewController(view, animated: true)
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
extension editPhaseSettings1VC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "phaseTitleCell") as! phaseTitleCell
        header.number.text = "م"
        header.firstTitle.text = "إسم المرحلة"
        header.secondTitle.text = "نسبةالمرحلة"
        header.thirdTitle.text = "تعديل"
        header.secondTitleWidth.constant = 100
        print("table \(header.bounds)")
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phase?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "editphase1Cell", for: indexPath) as! editphase1Cell
            cell.numberLabel.text = "\(indexPath.row + 1)"
            cell.phaseName.text = phase?.data[indexPath.row].title
            cell.percentagePhase.text = phase?.data[indexPath.row].percent
            cell.selectAction = {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "editPhaseSettings2VC") as! editPhaseSettings2VC
                view.level_id = self.phase?.data[indexPath.row].id ?? ""
                view.contract_name = self.contract_name
                view.contractID = self.contract_id
                view.addNew = false
                self.navigationController?.pushViewController(view, animated: true)
            }
            
            return cell
    }
    // MARK: - UITableViewDelegate

     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        phase?.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
}
extension editPhaseSettings1VC: UITableViewDropDelegate {
    // MARK: - UITableViewDropDelegate
    
    /**
         Ensure that the drop session contains a drag item with a data representation
         that the view can consume.
    */
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return (phase?.canHandle(session))!
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
            let stringItems = items as! [LevelsDatum]
            
            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                self.phase?.addItem(item, at: indexPath.row)
                indexPaths.append(indexPath)
            }

            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
}
extension editPhaseSettings1VC: UITableViewDragDelegate {
    // MARK: - UITableViewDragDelegate
    
    /**
         The `tableView(_:itemsForBeginning:at:)` method is the essential method
         to implement for allowing dragging from a table.
    */
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return (phase?.dragItems(for: indexPath))!
    }
}
//MARK: - Request
extension editPhaseSettings1VC{
    @objc func get_level_by_contract(){
        startAllAnimationBtn()
        totalProcessValue = 0.0
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(Levels.self, router: .get_level_by_contract(id:contract_id), success: { [weak self] (models) in
                self?.phase = models
                if(models.status == 1){
                    self?.tableView.reloadData()
                    for totalcounter in models.data{
                        self?.totalProcessValue = (self?.totalProcessValue ?? 0.0) + Double(totalcounter.percent)!
                    }
                    let num = Double(self?.totalProcessValue ?? 0.0)
                    self?.projectProgress.value = CGFloat(num)
                    self?.hideAllViews()
                }
                else if (models.status == 0 ){
                   self?.hideAllViews()
                   self?.noDataView.isHidden = false
                   self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_level_by_contract), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                   self?.hideAllViews()
                   self?.errorView.isHidden = false
                   self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_level_by_contract), for: UIControl.Event.touchUpInside)
            }
        }else{
                   hideAllViews()
                   noInterNetView.isHidden = false
                   self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_level_by_contract), for: UIControl.Event.touchUpInside)
        }
    }
    func controllersSortLevelsReq(){
        ids.removeAll()
        for idsCounter in phase!.data{
            ids.append(idsCounter.id)
        }
        print(ids)
       NetworkClient.performRequest(status4Model.self, router: .controllersSortLevels(id: ids), success: { [weak self] (models) in
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
//MARK: - Loader
extension editPhaseSettings1VC {
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا يوجد مراحل حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
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
