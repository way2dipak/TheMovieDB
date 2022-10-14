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

enum AppColors {
    static func getColorFor(genres: String) -> UIColor {
        switch genres {
        case "Action":
            return #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        case "Adventure":
            return #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
        case "Animation":
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case "Comedy":
            return #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        case "Crime":
            return #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case "Documentary":
            return #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)
        case "Drama":
            return #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        case "Family":
            return #colorLiteral(red: 1, green: 0.5212053061, blue: 1, alpha: 1)
        case "Fantasy":
            return #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)
        case "History":
            return #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)
        case "Horror":
            return #colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1)
        case "Music":
            return #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        case "Mystery":
            return #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        case "Romance":
            return #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
        case "Science Fiction":
            return #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        case "TV Movie":
            return #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 1)
        case "Thriller":
            return #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        case "War":
            return #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        case "Western":
            return #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        default:
            return #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        }
    }
}

let isIphone = (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone)
