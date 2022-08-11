//
//  MailVC.swift
//  AL-HHALIL
//
//  Created by apple on 7/28/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import SwipeCellKit
import SideMenu
import JSSAlertView
import TransitionButton

class MailVC: UIViewController /*, SwipeTableViewCellDelegate*/ {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var mailTableView: UITableView!
    
    //MARK: - Properties
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var menu : SideMenuNavigationController?
    var usesTallCells = false
    let defaults = UserDefaults.standard
    var mailBoxArr = [MailModelDatum]()
    var allMailBox : MailModel?
    @IBOutlet weak var empName: UILabel!
    var myNewView = UIView()
    var refreshControl = UIRefreshControl()
    var Cons :Constants?
    var currentPage = 0

    
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
       getTokenReq()
    }

    @IBAction func openProfileAction(_ sender: Any) {
        let view = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func config(){
        addAllViews()
        //tables View Congigration
        self.mailTableView.delegate = self
        self.mailTableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
        mailTableView.addSubview(refreshControl)
        mailTableView.allowsSelection = true
        mailTableView.allowsMultipleSelectionDuringEditing = true
        mailTableView.rowHeight = UITableView.automaticDimension
        mailTableView.registerCellNib(cellClass: MailCell.self)
        view.layoutMargins.left = 32
        //slide menu
        menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        menu?.setNavigationBarHidden(true, animated: false)
        //get_user_mailbox()
        let userName = UserDefaults.standard.value(forKey: "userName") as? String
        let jopTitle = UserDefaults.standard.value(forKeyPath: "jopTitle") as? String
        empName.text = " \(userName ?? "")/\(jopTitle ?? "")"
    }
    @objc func reloadVC(){
        mailBoxArr.removeAll()
        self.mailTableView.reloadData()
        currentPage = 0
        get_user_mailbox()
    }
    //Navigation Action
    @IBAction func SIdeMenu(_ sender: UIBarButtonItem) {
        menu = storyboard?.instantiateViewController(withIdentifier: "RightMenu") as? SideMenuNavigationController
        present(menu!, animated: true)
    }
}
//MARK: - UITableView Delegate & DataSource
extension MailVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mailBoxArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // let cell = tableView.dequeue() as MailCell
      //  cell.delegate = self
        let cell = tableView.dequeueReusableCell(withIdentifier: "MailCell", for: indexPath) as! MailCell
        
        cell.projectNameLabel.setTitle(mailBoxArr[indexPath.row].projectName, for: .normal)
        if(mailBoxArr[indexPath.row].bdg == "0"){
        }else{
            if #available(iOS 13.0, *) {
                cell.projectNameLabel.setImage(UIImage(systemName: "doc.plaintext"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
        }
        cell.titleLabel.text = mailBoxArr[indexPath.row].title
        cell.dateLabel.text = mailBoxArr[indexPath.row].date
        cell.timeLabel.text = mailBoxArr[indexPath.row].time
        cell.commentLabel.text = mailBoxArr[indexPath.row].comments
        
        if(mailBoxArr[indexPath.row].view == "0"){
            cell.statusView.backgroundColor = #colorLiteral(red: 0.4763007164, green: 0.2721414864, blue: 0.625670135, alpha: 0.8470588235)
        }else{
            cell.statusView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        return cell
    }
    
    //this feature canceled
    /*
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .left else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
        }
            // customize the action appearance
        deleteAction.image = UIImage(named: "trash")
        
        let forward = SwipeAction(style: .default, title: "Forward") { action, indexPath in
            // handle action by updating model with deletion
        }
            // customize the action appearance
        forward.image = UIImage(named: "forward")
        forward.hidesWhenSelected = true
        
        let back = SwipeAction(style: .default, title: "Backward") { action, indexPath in
            // handle action by updating model with deletion
        }
        // customize the action appearance
        back.image = UIImage(named: "back")
        back.hidesWhenSelected = true
        back.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return [deleteAction, forward, back]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        //options.expansionStyle = orientation == .right ? .selection : .destructive
        //options.transitionStyle = defaultOptions.transitionStyle
        return options
    }
 */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = self.storyboard?.instantiateViewController(withIdentifier: "MailDetailsVC") as! MailDetailsVC
        view.mailBoxId = mailBoxArr[indexPath.row].id
        print("sayed 12 :)  : \(mailBoxArr[indexPath.row].id)")
        self.navigationController?.pushViewController(view, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(allMailBox?.config?.totalRows ?? 0 > 10){
            if indexPath.row == (mailBoxArr.count) - 1 {
                if(currentPage == (allMailBox?.config?.numLinks)! - 1){
                }else{
                    if mailBoxArr.count >= 10 {
                        currentPage = currentPage + 1
                        get_user_mailbox()
                    }
                }
            }
        }
    }
}
//MARK: - Request
extension MailVC{
    @objc func get_user_mailbox(){
         startAllAnimationBtn()
         if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(MailModel.self, router: .mailBox(id:defaults.value(forKeyPath: "userId") as! String, currentPage: "\(currentPage)"), success: { [weak self] (models) in
                self?.allMailBox = models
                self?.refreshControl.endRefreshing()
                print(models)
                if(models.status == 1){
                    for mailBoxCounter in models.data{
                        self?.mailBoxArr.append(mailBoxCounter)
                    }
                    self!.mailTableView.reloadData()
                    self!.hideAllViews()
                }
                else if (models.status == 0 ){
                    self!.hideAllViews()
                    self!.noDataView.isHidden = false
                    self?.refresDatahBtn.addTarget(self, action: #selector(self?.get_user_mailbox), for: UIControl.Event.touchUpInside)
                }
            }){ [weak self] (error) in
                    self!.hideAllViews()
                    self!.errorView.isHidden = false
                    self?.refreshErrorBtn.addTarget(self, action: #selector(self?.get_user_mailbox), for: UIControl.Event.touchUpInside)
            }
         }else{
                hideAllViews()
                noInterNetView.isHidden = false
                self.refreshInterNetBtn.addTarget(self, action: #selector(self.get_user_mailbox), for: UIControl.Event.touchUpInside)
        }
    }
}
//MARK: - Loader
extension MailVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد رسائل بريد", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
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
