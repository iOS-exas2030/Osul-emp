//
//  ColorPickerViewController.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/21/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//


import UIKit

class ColorPickerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Global variables
    var tag: Int = 0
    var color: UIColor = UIColor.gray
    var delegate: EditContractSettingVC? = nil
    
    // This function converts from HTML colors (hex strings of the form '#ffffff') to UIColors
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // UICollectionViewDataSource Protocol:
    // Returns the number of rows in collection view
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    // UICollectionViewDataSource Protocol:
    // Returns the number of columns in collection view
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 16
    }
    // UICollectionViewDataSource Protocol:
    // Inilitializes the collection view cells
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.tag = tag
        tag = tag + 1
        
        return cell
    }
    
    // Recognizes and handles when a collection view cell has been selected
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var colorPalette: Array<String>
        
        // Get colorPalette array from plist file
        let path = Bundle.main.path(forResource: "colorPalette", ofType: "plist")
        let pListArray = NSArray(contentsOfFile: path!)
        
    //    if let colorPalettePlistFile = pListArray {
            let colorPalettePlistFile = pListArray
            colorPalette = colorPalettePlistFile as! [String]
            let cell: UICollectionViewCell  = collectionView.cellForItem(at: indexPath)! as UICollectionViewCell
            let hexString = colorPalette[cell.tag]
            color = hexStringToUIColor(hexString)
           // self.view.backgroundColor = color
            delegate?.hexString = hexString
            delegate?.setButtonColor(color)
        
           
    //    }
    }
}
