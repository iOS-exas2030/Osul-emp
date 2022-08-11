//
//  ImageDisplayVC.swift
//  AL-HHALIL
//
//  Created by apple on 9/12/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import Kingfisher
import JSSAlertView
class ImageDisplayVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var image = ""
    var selected: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

           imageView.image = selected
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(addTapped))
        let url = URL(string: image )
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
        // Do any additional setup after loading the view.
    }
    @objc func addTapped(){
        guard let img = imageView.image else {return }
        UIImageWriteToSavedPhotosAlbum(img , self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
             JSSAlertView().danger(self, title: "عذرا", text: "حدث حطأ ما حاول مره اخري", buttonText: "موافق")
        } else {
            JSSAlertView().success(self,title: "👍😃👍",text: "تم حفظ الصورة بنجاح في معرض الصور")
        }
    }
}
