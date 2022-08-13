//
//  CompanyCategoryVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 12/1/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import JSSAlertView
import TransitionButton

class CompanyCategoryVC: BaseVC {
    
    //MARK: - IBOutlets
    var header = ["تعديل","اسم الوظيفة/الصلاحية","م" ]
    var allCompanyCategory : CompanyCategoryModel?
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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    func config(){
        addAllViews()
        addFBtn.addTarget(self, action: #selector(addCompanyServices), for: UIControl.Event.touchUpInside)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.registerHeaderNib(cellClass: employeTitleCell.self)
        refreshControl.addTarget(self, action: #selector(getAllCompsCategory), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addCompanyServices))
        addJobView.addGestureRecognizer(tap)
        getAllCompsCategory()
        self.getTokenReq()

    }
    @objc func addCompanyServices(){
        let view = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
        view.addNew = true
        hideAllViews()
        self.navigationController?.pushViewController(view, animated: true)
    }
}
//MARK: -  table View protocol methods
extension CompanyCategoryVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "employeTitleCell") as! employeTitleCell
        header.widthConstrian.constant = 81
        header.mainLabel.text = "اسم النوع"
        header.subLabel.text = "تعديل"
        print("table \(header.bounds)")
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCompanyCategory?.data?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employesCell", for: indexPath) as! employesCell
        cell.nameLabel.text = allCompanyCategory?.data?[indexPath.row].name
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.selectAction = {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
            view.addNew = false
            view.CategoryName = (self.allCompanyCategory?.data?[indexPath.row].name)!
            view.catId = (self.allCompanyCategory?.data?[indexPath.row].id)!
            self.navigationController?.pushViewController(view, animated: true)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CompanyServicesVC") as! CompanyServicesVC
        view.catId = allCompanyCategory?.data?[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(view, animated: true)
    }
}
//MARK: -  Request
extension CompanyCategoryVC {
    @objc func getAllCompsCategory(){
        startAllAnimationBtn()
        if Reachability.connectedToNetwork(){
            NetworkClient.performRequest(CompanyCategoryModel.self, router: .getAllCompsCategory, success: { [weak self] (models) in
                self?.allCompanyCategory = models
                self?.refreshControl.endRefreshing()
                if(models.status == 1){
                    self?.tableView.reloadData()
                    self?.hideAllViews()
                }else if (models.status == 0 ){
                    self?.hideAllViews()
                    self?.noDataView.isHidden = false
                    self?.refresDatahBtn.addTarget(self, action: #selector(self?.getAllCompsCategory), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self?.hideAllViews()
                    self?.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.getAllCompsCategory), for: UIControl.Event.touchUpInside)
                }
        }else{
                    hideAllViews()
                    noInterNetView.isHidden = false
                    self.refreshInterNetBtn.addTarget(self, action: #selector(self.getAllCompsCategory), for: UIControl.Event.touchUpInside)
        }
    }
}

//MARK: - Loader
extension CompanyCategoryVC{
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
