//
//  UIView+SDWebImage.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import Foundation
import UIKit
import SDWebImage
import TheMovieDBNetwork

extension UIImageView {
    enum ImageType {
        case youtube
        case normal
        case genres
    }
    
    enum ImageQuality {
        case hd
        case standard
    }
    
    func loadImageWithUrl(with: String?,
                          placeholderImage: UIImage?,
                          type: ImageType = .normal,
                          quality: ImageQuality = .standard,
                          completed: SDExternalCompletionBlock?) {
        var url: URL?
        if type == .normal {
            url =  URL(string: "\(APIBase.currentEnv.imgUrl)\(quality == .standard ? "w780/" : "original/")\(with ?? "")")
        } else if type == .youtube {
            url = URL(string: "https://img.youtube.com/vi/\(with ?? "")/maxresdefault.jpg")
        } else {
            url = URL(string: with ?? "")
        }
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: url, placeholderImage: placeholderImage, options: [.scaleDownLargeImages], completed: completed)
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}


extension UIButton {
    func loadImageWithUrl(with: URL?,
                          placeholderImage: UIImage,
                          completed: SDExternalCompletionBlock?) {
        self.sd_imageIndicator = SDWebImageActivityIndicator.white
        self.sd_setImage(with: with, for: .normal, placeholderImage: placeholderImage, options: [], completed: completed)
    }
}

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func toggleDisplayWithAnimation(_ toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.alpha = 1
            }
        } else {
            self.alpha = 0
        }
    }
}

extension NSMutableAttributedString {
    enum FontWeight: String {
        case regular = "Roboto-Regular"
        case medium = "Roboto-Medium"
        case bold = "Roboto-Bold"
    }
    func bold(_ value: String, fontSize: CGFloat = 16) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontWeight.bold.rawValue, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func medium(_ value: String, fontSize: CGFloat = 14) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontWeight.medium.rawValue, size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func regular(_ value: String, fontSize: CGFloat = 14) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontWeight.regular.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
    
    func underlined(_ value: String, fontSize: CGFloat = 14, fontWeight: FontWeight = .bold) -> NSMutableAttributedString {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: fontWeight.rawValue, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize),
            .underlineStyle: NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}

extension Int {
    func minutesToHoursAndMinutes () -> String {
        if self >= 60 {
            let hours = self / 60
            let mins = self % 60
            if mins != 0 {
                return "\(hours)h \(mins)mins"
            } else {
                return "\(hours)h"
            }
        } else {
            let mins = "\(self % 60)"
            return "\(mins)mins"
        }
    }
}

extension String {
    var formattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
}
