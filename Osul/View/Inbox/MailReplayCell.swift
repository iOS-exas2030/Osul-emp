//
//  MailReplayCell.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 9/30/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

class MailReplayCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var attachmentCollectionView: UICollectionView!
    @IBOutlet weak var attachmentView: UIView!
    var files = [Attachment]()
    
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,left: 5.0,bottom: 10.0,right: 5.0)
    private let itemsPerRow: CGFloat = 2
    
    var filePressed : ((Attachment) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        attachmentCollectionView.dataSource = self
        attachmentCollectionView.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
extension MailReplayCell : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PdfMailBoxCell", for: indexPath) as! PdfMailBoxCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width: CGFloat = (collectionView.frame.width - (8 * 4) - 15) / 4
        print(width)
        return CGSize(width: width, height: width + 10)
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let fileWasPressed = files[indexPath.row]
        self.filePressed!(fileWasPressed)
//        let fullPath: String = files[indexPath.row].file ?? ""
//        let fullPathArr = fullPath.split(separator: ".")
//        let lastpath = fullPathArr[1]
//        if lastpath == "pdf"{
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let view = storyboard.instantiateViewController(identifier: "DisplayPdfVC") as! DisplayPdfVC
//            let fileName = files[indexPath.row].file ?? ""
//            view.stringurl = "https://urampos.com/khalil/images/\(fileName)"
//            navigationController.pushViewController(view, animated: true)
//        }else if lastpath == "jpeg"{
//            let view = self.storyboard.instantiateViewController(identifier: "ImageDisplayVC") as! ImageDisplayVC
//            let fileName = files[indexPath.row].file ?? ""
//            view.image = "https://urampos.com/khalil/images/\(fileName)"
//            self.navigationController?.pushViewController(view, animated: true)
//        }else if lastpath == "png"{
//            let view = storyboard.instantiateViewController(identifier: "ImageDisplayVC") as! ImageDisplayVC
//            let fileName = files[indexPath.row].file ?? ""
//            view.image = "https://urampos.com/khalil/images/\(fileName)"
//            self.navigationController?.pushViewController(view, animated: true)
//        }else if lastpath == "jpg"{
//            let view = self.storyboard.instantiateViewController(identifier: "ImageDisplayVC") as! ImageDisplayVC
//            let fileName = files[indexPath.row].file ?? ""
//            view.image = "https://urampos.com/khalil/images/\(fileName)"
//            self.navigationController?.pushViewController(view, animated: true)
//        }
    }
}
