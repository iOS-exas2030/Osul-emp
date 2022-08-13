//
//  employesSettingsVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/22/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class employesSettingsVC: BaseVC ,UITextFieldDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContractView: UIView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    //MARK: - Properties
    var users: Employee?
    var allUser = [EmployeeDatum]()
    var refreshControl = UIRefreshControl()
    var currentPage = 0
    var withSearch = false
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
        config()
       // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       reloadVC()
       searchTextField.text = ""
    }
    func config(){
        addAllViews()
       // get_all_users()
       self.tableView.delegate = self
       self.tableView.dataSource = self
       refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
       tableView.addSubview(refreshControl)
       tableView.registerHeaderNib(cellClass: employeTitleCell.self)
       addFBtn.addTarget(self, action: #selector(addEmploye), for: UIControl.Event.touchUpInside)
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addEmploye))
       addContractView.addGestureRecognizer(tap)
        
        searchView.isHidden = true
        
        searchViewHeight.constant = 0
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let tap7: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap7.cancelsTouchesInView = false
        view.addGestureRecognizer(tap7)
        self.getTokenReq()

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func reloadVC(){
        allUser.removeAll()
        self.tableView.reloadData()
        currentPage = 0
        withSearch = false
        get_all_users()
    }
    @objc func addEmploye (){
       let view = self.storyboard?.instantiateViewController(withIdentifier: "addEmployeVC") as! addEmployeVC
       hideAllViews()
       self.navigationController?.pushViewController(view, animated: true)
    }
    @IBAction func cancelSearchAction(_ sender: Any) {
        if(searchTextField.text == ""){
            searchView.isHidden = true
            searchViewHeight.constant = 0
            searchTextField.text = ""
        }else{
            searchView.isHidden = true
            searchViewHeight.constant = 0
            searchTextField.text = ""
            reloadVC()
        }
    }
    
    @IBAction func clearSearchTextAction(_ sender: Any) {
        searchTextField.text = ""
        reloadVC()
    }
    
    @IBAction func openSearchAction(_ sender: Any) {
        searchView.isHidden = false
        searchViewHeight.constant = 50
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
      if textField == searchTextField {
          if (searchTextField.text!.count >= 3){
              withSearch = true
              getAllUsersSearchReq()
              print("Done")
          }
          if (searchTextField.text!.count == 0){
              reloadVC()
          }
      }
    }
}
// table View protocol methods
extension employesSettingsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "employeTitleCell") as! employeTitleCell
        print("table \(header.bounds)")
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("allUser.count : \(allUser.count)")
        return allUser.count 
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employesCell", for: indexPath) as! employesCell
        cell.nameLabel.text = allUser[indexPath.row].name
        cell.numberLabel.text = "\(indexPath.row + 1)"
        if allUser[indexPath.row].jopType == "1" {
            cell.jobLabel.text = "موظف عام"
        }else if allUser[indexPath.row].jopType == "2"{
             cell.jobLabel.text = "مدير عام الفرع"
        }else if allUser[indexPath.row].jopType == "3"{
            cell.jobLabel.text = "مدير عام الفروع"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let view = self.storyboard?.instantiateViewController(withIdentifier: "addEmployeVC") as! addEmployeVC
       // view.employeData = self.users?.data[indexPath.row ]
        view.id = (self.allUser[indexPath.row].id)
         view.addNew = false
         self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(withSearch == false){
            if(users?.config?.totalRows ?? 0 > 10){
                if indexPath.row == (allUser.count) - 1 {
                    if(currentPage == (users?.config?.numLinks)! - 1){
                    }else{
                        currentPage = currentPage + 1
                        get_all_users()
                    }
                }
            }
        }
    }
}
//MARK: -  Request
extension employesSettingsVC {
    @objc func get_all_users(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork(){
            NetworkClient.performRequest(Employee.self, router: .get_all_users(currentPage: "\(currentPage)"), success: { [weak self] (models) in
                self?.users = models
                self?.refreshControl.endRefreshing()
                if(models.status == 1){
                    for userCounter in models.data{
                        self?.allUser.append(userCounter)
                    }
                    self?.tableView.reloadData()
                    self?.hideAllViews()
                }
                else if (models.status == 0 ){
                      self?.hideAllViews()
                      self?.noDataView.isHidden = false
                      self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_all_users), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                      self?.hideAllViews()
                      self?.errorView.isHidden = false
                      self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_all_users), for: UIControl.Event.touchUpInside)
            }
         }else{
                     hideAllViews()
                     noInterNetView.isHidden = false
                     self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_all_users), for: UIControl.Event.touchUpInside)
         }
    }
        func getAllUsersSearchReq(){
            self.allUser.removeAll()
            self.tableView.reloadData()
            NetworkClient.performRequest(Employee.self, router: .getAllUsersSearch(search: searchTextField.text!, page: "0"), success: { [weak self] (models) in
                print("models\( models.data)")
                self?.refreshControl.endRefreshing()
                if(models.status == 1){
                    self?.allUser = models.data
                self?.tableView.reloadData()
                }
                else if (models.status == 2 ){
                }
            }){ [weak self] (error) in
               
            }
        }
}

//MARK: - Loader
extension employesSettingsVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا يوجد موظفين حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
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
