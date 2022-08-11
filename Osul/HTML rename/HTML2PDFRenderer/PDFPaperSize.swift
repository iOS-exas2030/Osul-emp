//
//  PDFPaperSize.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/13/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//

import UIKit

extension HTML2PDFRenderer {
    public enum PaperSize {
        case a4
        case letter

        var size: CGSize {
            switch self {
            case .a4:
                return CGSize(width: 595.2, height: 841.8)

            case .letter:
                return CGSize(width: 612, height: 792)

            }
        }
    }
}
