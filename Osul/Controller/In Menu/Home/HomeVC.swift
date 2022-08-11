//
//  HomeVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo && Aya Bahaa on 7/3/20.
//  Copyright © 2020 Sayed Abdo && Aya Bahaa. All rights reserved.
//
import UIKit
import SideMenu
import JSSAlertView
import TransitionButton

class HomeVC: UIViewController, UIGestureRecognizerDelegate ,UITextFieldDelegate {

    @IBOutlet weak var projectCollectionView: UICollectionView!
    private let itemsPerRow: CGFloat = 2
    var allPoject : ProjectModel?
    var projectData = [ProjectModelDatum]()
    private let sectionInsets = UIEdgeInsets(top: 30.0,left: 20.0,bottom: 30.0,right: 20.0)
    var menu : SideMenuNavigationController?
    var refreshControl = UIRefreshControl()
   // @IBOutlet weak var empName: UILabel!
    var fromSearch = 0
    var currentPage = 0
    var withOutSearch = false
    var Cons :Constants?
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var addProject: UIButton!
    //status views
    var loaderView = UIView()
    var noDataView = UIView()
    var refresDatahBtn = TransitionButton()
    var refreshInterNetBtn = TransitionButton()
    var noInterNetView = UIView()
    var errorView = UIView()
    var refreshErrorBtn = TransitionButton()
    var addFBtn = TransitionButton()
    let dimmingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    override func viewWillAppear(_ animated: Bool) {
         reloadVC()
         getTokenReq()
        searchTextField.text = ""
    }
    func config(){
           addAllViews()
           self.navigationController?.isNavigationBarHidden = false
           projectCollectionView.dataSource = self
           projectCollectionView.delegate = self
           projectCollectionView.registerCellNib(cellClass: ProjectCell.self)
           self.projectCollectionView.alwaysBounceVertical = true
           let layout = UICollectionViewFlowLayout()
           layout.minimumLineSpacing = 1.0
           layout.minimumInteritemSpacing = 1.0
        
           menu = SideMenuNavigationController(rootViewController: SideMenuTableViewController())
                // SideMenuManager.default.rightMenuNavigationController = menu
                 SideMenuManager.default.addPanGestureToPresent(toView: self.view)
                 menu?.setNavigationBarHidden(true, animated: false)
           let progressBar = HorizontalProgressbar(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.size.height)! - 3, width: (self.navigationController?.navigationBar.frame.size.width)!, height: 3))
            
             self.navigationController?.navigationBar.addSubview(progressBar)
             progressBar.noOfChunks = 2
             progressBar.kChunkWdith = 40
             progressBar.progressTintColor = UIColor.white
             progressBar.trackTintColor = UIColor.darkGray
             progressBar.loadingStyle = .fill
             progressBar.startAnimating()
             DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                 // your code here
                 progressBar.stopAnimating()
             }
           //getAllProject()
          refreshControl.addTarget(self, action: #selector(reloadVC), for: UIControl.Event.valueChanged)
          projectCollectionView.addSubview(refreshControl)
          let userName = UserDefaults.standard.value(forKey: "userName") as? String
          let jopTitle = UserDefaults.standard.value(forKeyPath: "jopTitle") as? String
         // empName.text = " \(userName ?? "")/\(jopTitle ?? "")"
     
          
        setLongPress()
        searchView.isHidden = true
        searchViewHeight.constant = 0
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        let type =  UserDefaults.standard.value(forKeyPath: "jopType") as? String ?? ""
        print("type \(type)")
        if type == "3" || type == "2"{
            addProject.isHidden = false
        }else{
            addProject.isHidden = true
        }
    }
       @objc func handleDismiss()
       {
           UIView.animate(withDuration: 0.47, animations: {
               let window = UIApplication.shared.keyWindow
            let finalHeight = self.view.bounds.height
            
               let width = (window?.frame.width)! - 150

               self.view.frame = CGRect(x:  width, y: 0, width: self.dimmingView.frame.size.width - width , height: finalHeight)

               self.dimmingView.alpha = 0.5

           }) { (completed) in
               self.dimmingView.removeFromSuperview()
               self.view.removeFromSuperview()
           }
       }
    
    
    @objc func reloadVC(){
        print("self.fromSearch : \(self.fromSearch)")
        if(self.fromSearch == 1){
            self.hideAllViews()
        }else{
           projectData.removeAll()
           self.projectCollectionView.reloadData()
           currentPage = 0
           getAllProject()
        }
        self.fromSearch = 0
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func setLongPress(){
         let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
         lpgr.minimumPressDuration = 0.5
         lpgr.delaysTouchesBegan = true
         lpgr.delegate = self
         self.projectCollectionView.addGestureRecognizer(lpgr)
    }
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer?) {
        if gestureRecognizer?.state != .ended {
            return
        }
        let p = gestureRecognizer?.location(in: projectCollectionView)

        let indexPath = projectCollectionView.indexPathForItem(at: p ?? CGPoint.zero)
        if indexPath == nil {
            print("couldn't find index path")
        } else {
            // get the cell at indexPath (the one you long pressed)
            var cell: UICollectionViewCell? = nil
            if let indexPath = indexPath {
                cell = projectCollectionView.cellForItem(at: indexPath)
                print(indexPath.row)
                let alertview = JSSAlertView().warning(self,title: "تنبيه !",text: "هل تريد أرشفة المشروع ؟",buttonText: "موافق",cancelButtonText: "إلغاء" )
                alertview.addAction {
                   print("done")
                    self.ArchivedProject(projectId : self.projectData[indexPath.row].id ?? "", projectIndex: indexPath.row)
                }
                alertview.addCancelAction {
                    print("cancel")
                }
            }
            // do stuff with the cell
        }
    }

    @IBAction func sideMenu(_ sender: UIBarButtonItem) {
        menu = storyboard?.instantiateViewController(withIdentifier: "RightMenu") as? SideMenuNavigationController
        present(menu!, animated: true)
        
//        UIView.animate(withDuration: 0.47, animations: {
//            let window = UIApplication.shared.keyWindow
//         let finalHeight = self.view.bounds.height
//
//            let width = (window?.frame.width)! - 150
//
//            self.view.frame = CGRect(x:  width, y: 0, width: self.dimmingView.frame.size.width - width , height: finalHeight)
//
//            self.dimmingView.alpha = 0.5
//
//        }) { (completed) in
//            self.dimmingView.removeFromSuperview()
//            self.view.removeFromSuperview()
//        }
    }

    @IBAction func profileSettings(_ sender: UIBarButtonItem) {
        let view = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func cancelSearchAction(_ sender: Any) {
        searchView.isHidden = true
        searchViewHeight.constant = 0
        searchTextField.text = ""
        projectData.removeAll()
        currentPage = 0
        getAllProject()
    }
    
    @IBAction func clearSearchTextAction(_ sender: Any) {
        searchTextField.text = ""
        projectData.removeAll()
        currentPage = 0
        getAllProject()
    }
    
    @IBAction func openSearchAction(_ sender: Any) {
        searchView.isHidden = false
        searchViewHeight.constant = 50
    }
    
    @IBAction func openFiltterAction(_ sender: Any) {
        let nvc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        nvc.projectData = projectData
        nvc.delegate = self
        self.navigationController?.pushViewController(nvc, animated: true)
       // self.present(nvc, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == searchTextField {
            if (searchTextField.text!.count >= 3){
                getProjectsSearchByNameReq()
                print("Done")
            }
            if (searchTextField.text!.count == 0){
                projectData.removeAll()
                currentPage = 0
                getAllProject()
            }
        }
    }
    @IBAction func openAddProjectAction(_ sender: Any) {
        let nvc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddProjectVC") as! AddProjectVC
        self.navigationController?.pushViewController(nvc, animated: true)
    }
}

extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as ProjectCell
        cell.ProjectName.text = projectData[indexPath.row].name
        
        
//        let percent = Double(projectData[indexPath.row].percent!)
//        cell.projectProgress.maxValue = CGFloat(percent ?? 0)
//        let num = Double(projectData[indexPath.row].progress!)
//        cell.projectProgress.value = CGFloat(num ?? 0)
        
        if(self.projectData[indexPath.row].percent  == "0.00"){
            cell.projectProgress.value = CGFloat(0.0)
        }else{
            let percent = Double(self.projectData[indexPath.row].percent ?? "")
            cell.projectProgress.maxValue = CGFloat(percent ?? 0)
            
            let num = Double(self.projectData[indexPath.row].progress ?? "")
            let newValue = Double(num ?? 0.0) / Double(percent ?? 0.0)
            let final = newValue  * (percent ?? 0.0)
            cell.projectProgress.value = CGFloat(final)
        }
        
        
        cell.notification.isHidden = true
        if projectData[indexPath.row].isRead == "0"{
            cell.chatNotification.isHidden = false
        }else{
            cell.chatNotification.isHidden = true
        }
        if(projectData[indexPath.row].notification == "0"){
            cell.notification.isHidden = true
        }else{
            cell.notification.setTitle(projectData[indexPath.row].notification, for: .normal)
        }
        if(projectData[indexPath.row].confirm == "0"){
            cell.startProjectDate.text = "لم يتم التفعيل"
        }else{
             cell.startProjectDate.text = projectData[indexPath.row].confirmDate
             cell.startProjectDate.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        let color1 = hexStringToUIColor(hex: projectData[indexPath.row].color ?? "")
        cell.projectBorderView.borderColor = color1
//        cell.projectBorderView.borderColor = UIColor(hex: projectData[indexPath.row].color ?? "")
        cell.projectBorderView.borderWidth = 2
        if(projectData[indexPath.row].isCreated == "1"){
            cell.projectType.isHidden = false
        }else{
            cell.projectType.isHidden = true
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      return CGSize(width: widthPerItem, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let view = storyboard?.instantiateViewController(withIdentifier: "projectPhaseVC") as! projectPhaseVC
        view.projectId = projectData[indexPath.row].id ?? ""
        view.projectName = projectData[indexPath.row].name ?? ""
      //  view.precentProgress = projectData[indexPath.row].progress ?? ""
        view.projectStatus = self.projectData[indexPath.row].state ?? ""
        view.createdBy = self.projectData[indexPath.row].createdBy ?? ""
        view.isCreated = self.projectData[indexPath.row].isCreated ?? ""
        self.navigationController?.pushViewController(view, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(allPoject?.config?.totalRows ?? 0 > 10){
            if(withOutSearch == true){
                if indexPath.row == (projectData.count) - 1 {
                    if(currentPage == (allPoject?.config?.numLinks)! - 1){
                    }else{
                        if projectData.count >= 10 {
                            currentPage = currentPage + 1
                            getAllProject()
                        }
                    }
                }
            }
        }
    }
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
extension HomeVC: ModalDelegate{
    func changeValue(value: Int) {
        fromSearch = value
        if(value == 1){
              getAllProject()
        }
    }
}
extension HomeVC{
    @objc func getAllProject(){
        startAllAnimationBtn()
        let userId = UserDefaults.standard.value(forKey: "userId") as? String
        if Reachability.connectedToNetwork() {
            NetworkClient.performRequest(ProjectModel.self, router: .getAllProject(id: userId!, currentPage: "\(currentPage)"), success: { [weak self] (models) in
                  print("models\( models)")
                  self?.allPoject = models
                  self?.refreshControl.endRefreshing()
                  if(models.status == 1){
                     self?.refreshControl.endRefreshing()
                    self?.withOutSearch = true
                    self?.projectCollectionView.isHidden = false
                    if(self?.fromSearch == 1){
                        self?.projectCollectionView.reloadData()
                         self?.hideAllViews()
                        return
                    }else{
//                        self?.projectData = (self?.projectData.reversed())!
                    }
                    for projectCounter in models.data!{
                        self?.projectData.append(projectCounter)
                    }
                    self?.projectCollectionView.reloadData()
                    self?.hideAllViews()
                  }
                  else if (models.status == 0 ){
                        self?.hideAllViews()
                        self?.noDataView.isHidden = false
                        self?.refresDatahBtn.addTarget(self, action: #selector(self?.getAllProject), for: UIControl.Event.touchUpInside)
                  }
              }){ [weak self] (error) in
                        self?.hideAllViews()
                        self?.errorView.isHidden = false
                        self?.refreshErrorBtn.addTarget(self, action: #selector(self?.getAllProject), for: UIControl.Event.touchUpInside)
              }
        }else{
                    hideAllViews()
                    noInterNetView.isHidden = false
                    self.refreshInterNetBtn.addTarget(self, action: #selector(self.getAllProject), for: UIControl.Event.touchUpInside)
        }
      }
    
    func ArchivedProject(projectId : String,projectIndex : Int){
        NetworkClient.performRequest(status2Model.self, router: .projectArchiveProject(id: projectId), success: { [weak self] (models) in
             print("models\( models.data)")
             if(models.status == 1){
                self?.projectData.remove(at: projectIndex)
                self?.projectCollectionView.reloadData()
                self?.view.makeToast("تم ارشفه المشروع بنجاح", duration: 3.0, position: .bottom)
             }
             else if (models.status == 2 ){
                JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "حاول لاحقا")
             }
         }){ [weak self] (error) in
            
         }
     }
    
    func getProjectsSearchByNameReq(){
        self.projectData.removeAll()
        self.projectCollectionView.reloadData()
        NetworkClient.performRequest(ProjectModel.self, router: .get_ProjectsSearchByName(title: searchTextField.text!), success: { [weak self] (models) in
            print("models\( models.data)")
            self?.refreshControl.endRefreshing()
            if(models.status == 1){
                self?.withOutSearch = false
                self?.projectData = models.data!
                self?.projectCollectionView.isHidden = false
               self?.projectCollectionView.reloadData()
            }
            else if (models.status == 2 ){
                self?.projectCollectionView.isHidden = true
                self?.projectData = models.data!
                self?.projectCollectionView.reloadData()
               // JSSAlertView().danger(self!, title: "عذرا", text: models.arMsg, buttonText: "حاول لاحقا")
            }
        }){ [weak self] (error) in
           
        }
    }
}

//MARK: - Loader
extension HomeVC{
    func addAllViews(){
        self.errorView(mainNoDataView : &self.errorView, refreshBtn : &self.refreshErrorBtn)
        self.noInterNetView(mainNoDataView : &self.noInterNetView, refreshBtn :  &self.refreshInterNetBtn)
        self.noDataView(mainNoDataView: &self.noDataView, labelData: "لا توجد مشاريع حاليا", refreshBtn: &self.refresDatahBtn, addStatus : 1, addFBtn : &addFBtn)
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
