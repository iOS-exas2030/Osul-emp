//
//  UIPrintPageRenderer-Extensions.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

extension UIPrintPageRenderer {
    public func makePDF() -> Data {
        let data = NSMutableData()

        UIGraphicsBeginPDFContextToData(data, paperRect, nil)
        prepare(forDrawingPages: NSMakeRange(0, numberOfPages))
        let bounds = UIGraphicsGetPDFContextBounds()

        for i in 0 ..< numberOfPages {
            UIGraphicsBeginPDFPage()
            drawPage(at: i, in: bounds)
        }
        UIGraphicsEndPDFContext()

        return data as Data
    }
}
