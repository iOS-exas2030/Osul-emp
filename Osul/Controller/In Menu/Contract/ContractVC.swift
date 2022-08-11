//
//  ContractVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/3/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import SideMenu
import JSSAlertView
import TransitionButton

class ContractVC: UIViewController ,UITextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!

    //MARK: - Properties
    var allcontract :  ContractModel?
    var contractArr = [ContractModelDatum]()
    var menu : SideMenuNavigationController?
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var empName: UILabel!
    var currentPage = 0
    var withSearch = true
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
       // getContractProjectSearchReq()
    }
    override func viewWillAppear(_ animated: Bool) {
       reloadVC()
       getTokenReq()
       searchTextField.text = ""
    }
    @IBAction func openProfileAction(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(view, animated: true)
    }
    func config(){
        addAllViews()
        //tables View Congigration
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerHeaderNib(cellClass: contractTitleCell.self)
     //   getAllContract()
        //slide menu
        menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.rightMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        menu?.setNavigationBarHidden(true, animated: false)
        refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        let userName = UserDefaults.standard.value(forKey: "userName") as? String
        let jopTitle = UserDefaults.standard.value(forKeyPath: "jopTitle") as? String
        empName.text = " \(userName ?? "")/\(jopTitle ?? "")"
        
        searchView.isHidden = true
        searchViewHeight.constant = 0
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let tap7: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap7.cancelsTouchesInView = false
        view.addGestureRecognizer(tap7)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @objc func reloadVC(){
        contractArr.removeAll()
        self.tableView.reloadData()
        currentPage = 0
        withSearch = false
        getAllContract()
    }
    //Navigation Action
    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        menu = storyboard?.instantiateViewController(withIdentifier: "RightMenu") as? SideMenuNavigationController
        present(menu!, animated: true)
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
                getContractProjectSearchReq()
                print("Done")
            }
            if (searchTextField.text!.count == 0){
                reloadVC()
            }
        }
      }
}
//MARK: - UITableView Delegate & DataSource
extension ContractVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contractArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContractCell", for: indexPath) as! ContractCell
        let dateArr = contractArr[indexPath.row].projectDate?.split(separator: " ")
        cell.orderDate.text = "\(dateArr?[0] ?? "")"
        if(contractArr[indexPath.row].projectType == "default"){
            cell.contractType.text = "- - -"
        }else{
           cell.contractType.text = contractArr[indexPath.row].projectType
        }
        cell.clientName.text = contractArr[indexPath.row].projectName
        let num = Double(contractArr[indexPath.row].projectProgress ?? "0.0") ?? 0.0
        cell.projectProgress.value = CGFloat(num ?? 0)
        
        if(self.contractArr[indexPath.row].projectPercent  == "0"){
            cell.projectProgress.value = CGFloat(0.0)
        }else{
            let percent = Double(self.contractArr[indexPath.row].projectPercent ?? "0.0") ?? 0.0
            cell.projectProgress.maxValue = 100.0
            
            let num = Double(self.contractArr[indexPath.row].projectProgress ?? "0.0") ?? 0.0
            if(percent > 0){
                let newValue = Double(num ?? 0.0) / Double(percent ?? 0.0)
                let final = newValue  * 100.0
                cell.projectProgress.value = CGFloat(final)
            }else{
                cell.projectProgress.value = CGFloat(0.0)
            }
            
            
        }
        if(self.contractArr[indexPath.row].projectType  == "0"){
            
        }
        
        
        if(contractArr[indexPath.row].view == "0"){
            cell.statusView.backgroundColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235)
            cell.projectProgress.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cell.dataView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cell.projectNameView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cell.contractTypeView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        }else{
            cell.statusView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "ContractDetailsVC") as! ContractDetailsVC
        view.projectId = contractArr[indexPath.row].projectID ?? ""
        view.progress = contractArr[indexPath.row].projectProgress ?? ""
        view.projectPercent = contractArr[indexPath.row].projectPercent ?? ""
        self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(withSearch == false){
            if(allcontract?.config?.totalRows ?? 0 > 10){
                if indexPath.row == (contractArr.count) - 1 {
                        if(currentPage == (allcontract?.config?.numLinks)! - 1){
                        }else{
                            if contractArr.count >= 10 {
                                currentPage = currentPage + 1
                                getAllContract()
                            }
                        }
                 }
              }
        }
    }
}

//MARK: - Request
extension ContractVC{
    @objc func getAllContract(){
         startAllAnimationBtn()
         if Reachability.connectedToNetwork() {
            let userId = UserDefaults.standard.value(forKey: "userId") as? String
            NetworkClient.performRequest(ContractModel.self, router: .getAllContract(id: userId!, currentPage: "\(currentPage)"), success: { [weak self] (models) in
                    self?.allcontract = models
                    self?.refreshControl.endRefreshing()
                    if(models.status == 1){
                        for contractCounter in models.data!{
                            self?.contractArr.append(contractCounter)
                        }
                        self?.tableView.reloadData()
                        self?.hideAllViews()
                    }
                    else if (models.status == 0){
                        self?.hideAllViews()
                        self?.noDataView.isHidden = false
                        self?.refresDatahBtn.addTarget(self, action: #selector(self?.getAllContract), for: UIControl.Event.touchUpInside)
                    }
                }){ [weak self] (error) in
                        self?.hideAllViews()
                        self?.errorView.isHidden = false
                        self?.refreshErrorBtn.addTarget(self, action: #selector(self?.getAllContract), for: UIControl.Event.touchUpInside)
                }
        }else{
           hideAllViews()
           noInterNetView.isHidden = false
           self.refreshInterNetBtn.addTarget(self, action: #selector(self.getAllContract), for: UIControl.Event.touchUpInside)
        }
    }
    
    func getContractProjectSearchReq(){
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        self.contractArr.removeAll()
        self.tableView.reloadData()
        NetworkClient.performRequest(ContractModel.self, router: .getContractProjectSearch(search: searchTextField.text!, page: "0", user_id:  userId!), success: { [weak self] (models) in
            print("models\( models.data)")
            self?.refreshControl.endRefreshing()
            if(models.status == 1){
                self?.contractArr = models.data!
                self?.tableView.reloadData()
            }
            else if (models.status == 2 ){
            }
        }){ [weak self] (error) in
        }
    }
}
//MARK: - Loader
extension ContractVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد تعاقدات حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
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
