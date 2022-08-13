//
//  Jobs&FunctionsVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/20/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class Jobs_FunctionsVC: BaseVC {

    //MARK: - IBOutlets
    var header = ["تعديل","اسم الوظيفة/الصلاحية","م" ]
    var all_users_groups : UserGroup?
    @IBOutlet weak var addJobView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
         config()
    }
    func config(){
        addAllViews()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addJobsDetails))
        addJobView.addGestureRecognizer(tap)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        addFBtn.addTarget(self, action: #selector(addJobsDetails), for: UIControl.Event.touchUpInside)
        tableView.registerHeaderNib(cellClass: employeTitleCell.self)
        refreshControl.addTarget(self, action: #selector(get_all_users_groups), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        get_all_users_groups()
        self.getTokenReq()

    }
    @objc func addJobsDetails (){
         let view = self.storyboard?.instantiateViewController(withIdentifier: "JobsDetailsVC") as! JobsDetailsVC
         self.hideAllViews()
         self.navigationController?.pushViewController(view, animated: true)
    }
}
//MARK: -  Request
extension Jobs_FunctionsVC {
    @objc func get_all_users_groups(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork(){
            NetworkClient.performRequest(UserGroup.self, router: .get_all_users_groups, success: { [weak self] (models) in
                self?.all_users_groups = models
                self?.refreshControl.endRefreshing()
                if(models.status == 1){
                    self?.tableView.reloadData()
                    self?.hideAllViews()
                }else if (models.status == 0 ){
                    self?.hideAllViews()
                    self?.noDataView.isHidden = false
                    self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_all_users_groups), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self?.hideAllViews()
                    self?.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_all_users_groups), for: UIControl.Event.touchUpInside)
                }
        }else{
                    hideAllViews()
                    noInterNetView.isHidden = false
                    self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_all_users_groups), for: UIControl.Event.touchUpInside)
        }
    }
}
// table View protocol methods
extension Jobs_FunctionsVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "employeTitleCell") as! employeTitleCell
        header.widthConstrian.constant = 81
        header.mainLabel.text = "اسم الوظيفة/الصلاحية"
        header.subLabel.text = "تعديل"
        print("table \(header.bounds)")
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return all_users_groups?.data.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employesCell", for: indexPath) as! employesCell
        cell.nameLabel.text = all_users_groups?.data[indexPath.row].title
        cell.numberLabel.text = "\(indexPath.row + 1)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let view = self.storyboard?.instantiateViewController(withIdentifier: "JobsDetailsVC") as! JobsDetailsVC
         view.id = self.all_users_groups?.data[indexPath.row].id ?? ""
         view.userGroup = (self.all_users_groups?.data[indexPath.row])!
         view.userGroup.isProjects = "1"
         view.addNew = false
         self.navigationController?.pushViewController(view, animated: true)
    }
}

//MARK: - Loader
extension Jobs_FunctionsVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد صلحيات وظائف حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 0, addFBtn : &addFBtn)
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
