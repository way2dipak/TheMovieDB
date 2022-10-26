//
//  Font.swift
//  AdaptiveLayoutUIKit
//
//  Created by Родион on 11.07.2020.
//  Copyright © 2020 Rodion Artyukhin. All rights reserved.
//

import UIKit

enum AppFonts {
    
    static func light(size: CGFloat) -> UIFont {
        UIFont(name: "Roboto-Light", size: size.adaptedFontSize)!
    }
    
    static func regular(size: CGFloat) -> UIFont {
        UIFont(name: "Roboto-Regular", size: size.adaptedFontSize)!
    }
    
    static func medium(size: CGFloat) -> UIFont {
        UIFont(name: "Roboto-Medium", size: size.adaptedFontSize)!
    }
    
    static func bold(size: CGFloat) -> UIFont {
        UIFont(name: "Roboto-Bold", size: size.adaptedFontSize)!
    }
    
    static func black(size: CGFloat) -> UIFont {
        UIFont(name: "Roboto-Black", size: size.adaptedFontSize)!
    }
}

let isIphone = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone)
