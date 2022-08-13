//
//  ClientSettingsVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/20/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//


import UIKit
import JSSAlertView
import TransitionButton

class ClientSettingsVC: BaseVC ,UITextFieldDelegate{

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addContractView: UIView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - Properties
    var refreshControl = UIRefreshControl()
    var clients: Client?
    var allClient = [ClientDatum]()
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
       // Do any additional setup after loading the view.
        config()
   }
   override func viewWillAppear(_ animated: Bool) {
       reloadVC()
       self.getTokenReq()
       searchTextField.text = ""
   }
   func config(){
       addAllViews()
       self.tableView.delegate = self
       self.tableView.dataSource = self
       refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
       tableView.addSubview(refreshControl)
       tableView.registerHeaderNib(cellClass: employeTitleCell.self)
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addClient))
       addContractView.addGestureRecognizer(tap)
     //  get_all_clients()
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
        allClient.removeAll()
        self.tableView.reloadData()
        withSearch = false
        currentPage = 0
        get_all_clients()
    }
   @objc func addClient(){
       let view = self.storyboard?.instantiateViewController(withIdentifier: "AddClientVC") as! AddClientVC
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
             getAllClientsSearchReq()
              print("Done")
          }
          if (searchTextField.text!.count == 0){
              reloadVC()
          }
      }
    }
}
//MARK: - table View protocol methods
extension ClientSettingsVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "employeTitleCell") as! employeTitleCell
         header.mainLabel.text = "اسم العميل"
         header.subLabel.text = "رقم الجوال"
         return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allClient.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "employesCell", for: indexPath) as! employesCell
         cell.nameLabel.text = allClient[indexPath.row].name
         cell.numberLabel.text = "\(indexPath.row + 1)"
         cell.jobLabel.text = allClient[indexPath.row].phone
         return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let view = self.storyboard?.instantiateViewController(withIdentifier: "AddClientVC") as! AddClientVC
         view.clientData = self.allClient[indexPath.row]
         view.addNew = false
         self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(withSearch == false){
            if(clients?.config?.totalRows ?? 0 > 10){
                if indexPath.row == (allClient.count) - 1 {
                    if(currentPage == (clients?.config?.numLinks)! - 1){
                    }else{
                        currentPage = currentPage + 1
                        get_all_clients()
                    }
                }
             }
        }
    }
}
//MARK: -  Request
extension ClientSettingsVC{
    @objc func get_all_clients(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(Client.self, router: .get_all_clients(currentPage: "\(currentPage)"), success: { [weak self] (models) in
            self?.clients = models
            if(models.status == 1){
                for clientCounter in models.data{
                    self?.allClient.append(clientCounter)
                }
                 self?.refreshControl.endRefreshing()
                 self?.tableView.reloadData()
                 self?.hideAllViews()
            }
            else if (models.status == 0 ){
                 self?.refreshControl.endRefreshing()
                 self?.hideAllViews()
                 self?.noDataView.isHidden = false
                 self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_all_clients), for: UIControl.Event.touchUpInside)
            }
          }){ [weak self] (error) in
                 self?.hideAllViews()
                 self?.errorView.isHidden = false
                 self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_all_clients), for: UIControl.Event.touchUpInside)
            }
          }else{
                hideAllViews()
                noInterNetView.isHidden = false
                self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_all_clients), for: UIControl.Event.touchUpInside)
          }
    }
    
    func getAllClientsSearchReq(){
                self.allClient.removeAll()
        self.tableView.reloadData()
                NetworkClient.performRequest(Client.self, router: .getAllClientsSearch(search: searchTextField.text!, page: "0"), success: { [weak self] (models) in
                    print("models\( models.data)")
                    self?.refreshControl.endRefreshing()
                    if(models.status == 1){
                    self?.allClient = models.data
                    self?.tableView.reloadData()
                    }
                    else if (models.status == 2 ){

                    }
                }){ [weak self] (error) in
                   
                }
            }
}
//MARK: - Loader
extension ClientSettingsVC {
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا يوجد عملاء حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
        self.showLoader(mainView: &loaderView)
        startAllAnimationBtn()
    }
    func hideAllViews(){
        self.hideLoader(mainView: &self.loaderView)
        self.hideNoDataView( mainNoDataView : &self.noDataView)
        self.hideNoInterNetView( mainNoInterNetView : &self.noInterNetView)
        self.hideErrorView( mainNoInterNetView : &self.errorView)
        self.getTokenReq()
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
