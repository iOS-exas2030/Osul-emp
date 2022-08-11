//
//  meetUpThirdCell.swift
//  AL-HHALIL
//
//  Created by apple on 11/4/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit
import Photos
protocol YourCellDelegate: NSObjectProtocol{
    func didPressCell(sender: Int)
    func selectionimage(sender : UIButton ,tag: Int )
}

class meetUpThirdCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var imageQues: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let sectionInsets = UIEdgeInsets(top: 5.0,left: 5.0,bottom: 5.0,right: 5.0)
    var values = [""]
    var selectAction: ((_ sender : UIButton)->())?
    var delegate:YourCellDelegate?
  //  var myViewController: MeetUpVC!

    override func awakeFromNib() {
        super.awakeFromNib()
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.registerCellNib(cellClass: attachCell.self)
        print("pics \(values)")
        // Initialization code
    }

    @IBAction func addImageButton(_ sender: UIButton) {
        self.selectAction?(sender)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension meetUpThirdCell : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return values.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(indexPath: indexPath) as attachCell
        
      delegate?.selectionimage(sender: cell.attachment, tag: indexPath.row)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - (8 * 4) - 15) / 10
        print(width)
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didPressCell(sender: indexPath.row)
        

    }
}
