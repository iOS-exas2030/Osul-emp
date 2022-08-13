//
//  NewOrdersVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/20/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//


import UIKit
import SideMenu
import JSSAlertView
import NVActivityIndicatorView
import TransitionButton

class NewOrdersVC: BaseVC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var empName: UILabel!
    //MARK: - Properties
    var projectArr = [ClinetOrderDatum]()
    var clinetOrder: ClinetOrder?
    var header = ["نوع المشروع","تاريخ الطلب","اسم العميل","م"]
    var menu : SideMenuNavigationController?
    let defaults = UserDefaults.standard
    var refreshControl = UIRefreshControl()
    var currentPage = 0
    var Cons :Constants?
    //MARK: -status views
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
        if Reachability.connectedToNetwork() {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
        }
        config()
    }
    @IBAction func openProfileAction(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(view, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
       reloadVC()
       self.getTokenReq()
    }
    func config(){
      addAllViews()
      self.tableView.delegate = self
      self.tableView.dataSource = self
      tableView.registerHeaderNib(cellClass: newOrderTitleCell.self)
     // newOrdersSpreadSheet.isScrollEnabled = false
      menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
      SideMenuManager.default.rightMenuNavigationController = menu
      SideMenuManager.default.addPanGestureToPresent(toView: self.view)
      menu?.setNavigationBarHidden(true, animated: false)
      //getAllNewClientOrder()
      refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
      tableView.addSubview(refreshControl)
      let userName = UserDefaults.standard.value(forKey: "userName") as? String
      let jopTitle = UserDefaults.standard.value(forKeyPath: "jopTitle") as? String
      empName.text = " \(userName ?? "")/\(jopTitle ?? "")"
      empName.decideTextDirection()

    }
    @objc func reloadVC(){
        projectArr.removeAll()
        self.tableView.reloadData()
        currentPage = 0
        getAllNewClientOrder()
    }
    //Navigation Action
    @IBAction func SideMenu(_ sender: UIBarButtonItem) {
        menu = storyboard?.instantiateViewController(withIdentifier: "RightMenu") as? SideMenuNavigationController
        present(menu!, animated: true)
    }
}
//MARK: - UITableView Delegate & DataSource
extension NewOrdersVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
         let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "newOrderTitleCell") as! newOrderTitleCell
         return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projectArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewOrderCell", for: indexPath) as! NewOrderCell
               cell.numberLabel.text = "\(indexPath.row + 1)"
               cell.clientName.text = projectArr[indexPath.row].projectName
            let dateArr = projectArr[indexPath.row].projectDate?.split(separator: " ")
            cell.dateLabel.text = "\(dateArr?[0] ?? "")"
            if(projectArr[indexPath.row].projectType == "default"){
                cell.projectType.text = "---"
            }else{
                cell.projectType.text = projectArr[indexPath.row].projectType
            }
        if(projectArr[indexPath.row].view == "0"){
           cell.backgroundColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235)
        }else{
            cell.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "NewOrderdetailsVC") as! NewOrderdetailsVC
        view.projectId = projectArr[indexPath.row].projectID ?? ""
        self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(clinetOrder?.config?.totalRows ?? 0 > 10){
            if indexPath.row == (projectArr.count) - 1 {
                if(currentPage == (clinetOrder?.config?.numLinks)! - 1){
                }else{
                    if projectArr.count >= 10 {
                        currentPage = currentPage + 1
                        getAllNewClientOrder()
                    }
                }
            }
        }
    }
}
//MARK: - Request
extension NewOrdersVC{
    
    @objc func getAllNewClientOrder(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(ClinetOrder.self, router: .getAllNewClientOrder(currentPage: "\(currentPage)"), success: { [weak self] (models) in
                self?.clinetOrder = models
                self?.refreshControl.endRefreshing()
                if(models.status == 1){
                    for projectCounter in models.data!{
                        self?.projectArr.append(projectCounter)
                    }
                    self!.tableView.reloadData()
                    self!.hideAllViews()
                }
                else if (models.status == 0 ){
                    self!.hideAllViews()
                    self!.noDataView.isHidden = false
                    self?.refresDatahBtn.addTarget(self, action: #selector(self?.getAllNewClientOrder), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self!.hideAllViews()
                    self!.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.getAllNewClientOrder), for: UIControl.Event.touchUpInside)
            }
        }else{
                    hideAllViews()
                    noInterNetView.isHidden = false
                    self.refreshInterNetBtn.addTarget(self, action: #selector(self.getAllNewClientOrder), for: UIControl.Event.touchUpInside)
        }
    }
}

//MARK: - Loader
extension NewOrdersVC{
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
extension UILabel {
    func decideTextDirection () {
        let tagScheme = [NSLinguisticTagScheme.language]
        let tagger    = NSLinguisticTagger(tagSchemes: tagScheme, options: 0)
        tagger.string = self.text
        let lang      = tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language,
                                          tokenRange: nil, sentenceRange: nil)
            self.textAlignment = NSTextAlignment.right
        
        //   self.textAlignment = NSTextAlignment.left
    
    }
}
