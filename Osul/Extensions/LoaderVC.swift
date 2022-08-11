//
//  LoaderVC.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/12/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LoaderVC: UIViewController {

    @IBOutlet weak var activerView: NVActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activerView.startAnimating()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

}
