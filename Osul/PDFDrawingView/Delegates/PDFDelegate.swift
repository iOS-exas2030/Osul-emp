//
//  PDFDelegate.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/14/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import Foundation

public protocol PDFDelegate: class{
    /**
     Gets called when the PDFDrawingView changes pages
     - parameter page: The new page number
     */
    func scrolled(to page: Int)
    /**
     Gets called when the PDFDrawingView is created and ready for usage (should be instantaneous)
    */
    func viewWasCreated()
}
