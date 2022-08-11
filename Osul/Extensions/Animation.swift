//
//  Animation.swift
//  AL-HHALIL
//
//  Created by Sayed Abdo on 7/8/20.
//  Copyright © 2020 Sayed Abdo. All rights reserved.
//


import Foundation
import UIKit
import Spring

struct Animations {
    
    
    
   static func slideDown(view: SpringImageView) {
        view.animation = "slideDown"
        view.curve = "easeInOutExpo"
        view.duration = 2.0
        view.damping = 1.2
        view.animate()
    }
    
   static func slideUp(view: SpringImageView) {
        view.animation = "slideUp"
        view.curve = "easeIn"
        view.duration = 2.0
        view.damping = 1.2
        view.animate()
    }
    
    static func fadeOutView(view: SpringView) {
        view.animation = "fadeOut"
        view.curve = "easeIn"
        view.duration = 1.5
        view.animate()
    }

    static func squeezUpView(view: SpringView) {
        view.animation = "squeezeUp"
        view.curve = "easeIn"
        view.duration = 1.0
        view.animate()
    }

    static func zoomInView(view: SpringView) {
        view.animation = "zoomIn"
        view.curve = "easeIn"
        view.duration = 1.0
        view.animate()
    }
    
}
