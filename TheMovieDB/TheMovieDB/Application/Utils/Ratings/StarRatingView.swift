//
//  StarRatingView.swift
//  TheMovieDB
//
//  Created by DS on 16/05/21.
//

import Foundation
import UIKit
import SwiftUI

/*
public enum StarRounding: Int {
    case roundToHalfStar = 0
    case ceilToHalfStar = 1
    case floorToHalfStar = 2
    case roundToFullStar = 3
    case ceilToFullStar = 4
    case floorToFullStar = 5
}

@IBDesignable
class StarRatingView: UIView {
    
    @IBInspectable var rating: Float = 3.5 {
        didSet {
            setStarsFor(rating: rating)
        }
    }
    @IBInspectable var starColor: UIColor = UIColor.systemOrange {
        didSet {
            for starImageView in [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView] {
                starImageView?.tintColor = starColor
            }
        }
    }
    

    var starRounding: StarRounding = .roundToHalfStar {
        didSet {
            setStarsFor(rating: rating)
        }
    }
    @IBInspectable var starRoundingRawValue:Int {
        get {
            return self.starRounding.rawValue
        }
        set {
            self.starRounding = StarRounding(rawValue: newValue) ?? .roundToHalfStar
        }
    }
    
    fileprivate var hstack: StarRatingStackView?

    fileprivate let fullStarImage: UIImage = #imageLiteral(resourceName: "starFill")
    fileprivate let halfStarImage: UIImage = #imageLiteral(resourceName: "starHalf")
    fileprivate let emptyStarImage: UIImage = #imageLiteral(resourceName: "starEmpty")

    
    convenience init(frame: CGRect, rating: Float, color: UIColor, starRounding: StarRounding) {
        self.init(frame: frame)
        self.setupView(rating: rating, color: color, starRounding: starRounding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(rating: self.rating, color: self.starColor, starRounding: self.starRounding)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView(rating: 3.5, color: UIColor.systemOrange, starRounding: .roundToHalfStar)
    }
    
    
    fileprivate func setupView(rating: Float, color: UIColor, starRounding: StarRounding) {
        let bundle = Bundle(for: StarRatingStackView.self)
        let nib = UINib(nibName: "StarRatingStackView", bundle: bundle)
        let viewFromNib = nib.instantiate(withOwner: self, options: nil)[0] as! StarRatingStackView
        self.addSubview(viewFromNib)
        
        viewFromNib.translatesAutoresizingMaskIntoConstraints = false
              self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|[v]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: nil,
                    views: ["v":viewFromNib]
                 )
              )
              self.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|[v]|",
                    options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                    metrics: nil, views: ["v":viewFromNib]
                 )
              )
        
        self.hstack = viewFromNib
        self.rating = rating
        self.starColor = color
        self.starRounding = starRounding
        
        self.isMultipleTouchEnabled = false
        self.hstack?.isUserInteractionEnabled = false
    }
    
    fileprivate func setStarsFor(rating: Float) {
        let starImageViews = [hstack?.star1ImageView, hstack?.star2ImageView, hstack?.star3ImageView, hstack?.star4ImageView, hstack?.star5ImageView]
        for i in 1...5 {
            let iFloat = Float(i)
            switch starRounding {
            case .roundToHalfStar:
                starImageViews[i-1]!.image = rating >= iFloat-0.25 ? fullStarImage :
                                            (rating >= iFloat-0.75 ? halfStarImage : emptyStarImage)
            case .ceilToHalfStar:
                starImageViews[i-1]!.image = rating > iFloat-0.5 ? fullStarImage :
                                            (rating > iFloat-1 ? halfStarImage : emptyStarImage)
            case .floorToHalfStar:
                starImageViews[i-1]!.image = rating >= iFloat ? fullStarImage :
                                            (rating >= iFloat-0.5 ? halfStarImage : emptyStarImage)
            case .roundToFullStar:
                starImageViews[i-1]!.image = rating >= iFloat-0.5 ? fullStarImage : emptyStarImage
            case .ceilToFullStar:
                starImageViews[i-1]!.image = rating > iFloat-1 ? fullStarImage : emptyStarImage
            case .floorToFullStar:
                starImageViews[i-1]!.image = rating >= iFloat ? fullStarImage : emptyStarImage
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        guard let touch = touches.first else {return}
        touched(touch: touch, moveTouch: false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched moved")
        guard let touch = touches.first else {return}
        touched(touch: touch, moveTouch: true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched ended")
        guard let touch = touches.first else {return}
        touched(touch: touch, moveTouch: false)
    }
    
    var lastTouch: Date?
    fileprivate func touched(touch: UITouch, moveTouch: Bool) {
        guard !moveTouch || lastTouch == nil || lastTouch!.timeIntervalSince(Date()) < -0.1 else { return }
        print("processing touch")
        guard let hs = self.hstack else { return }
        let touchX = touch.location(in: hs).x
        let ratingFromTouch = 5*touchX/hs.frame.width
        var roundedRatingFromTouch: Float!
        switch starRounding {
        case .roundToHalfStar, .ceilToHalfStar, .floorToHalfStar:
            roundedRatingFromTouch = Float(round(2*ratingFromTouch)/2)
        case .roundToFullStar, .ceilToFullStar, .floorToFullStar:
            roundedRatingFromTouch = Float(round(ratingFromTouch))
        }
        self.rating = roundedRatingFromTouch
        lastTouch = Date()
    }
    
    
    



}
*/

public enum StarType{

    /// 整颗星星
    case `default`
    /// 半颗星星
    case half
    /// 不限制
    case unlimited
}

public class StarRatingView: UIView {
    
    /// 默认整颗星星
    lazy var starType:StarType = .unlimited
    
    /// 是否滑动,default is true
    var isPanEnable = true{
        didSet{
            if isPanEnable {
                /// 滑动手势
                let pan = UIPanGestureRecognizer(target: self,action: #selector(startPan))
                
                addGestureRecognizer(pan)
            }
        }
    }
    
    /// 星星的间隔,default is 5.0
    lazy var starSpace:CGFloat = 5.0
    
    /// 当前的星星数量,default is 0
    lazy var currentStarCount:CGFloat = 0
    
    /// 上次评分
    lazy var lastScore:CGFloat = -1
    
    /// 最少星星
    lazy var leastStar:CGFloat = 0
    
    /// 星星总数量,default is 5
    lazy var totalStarCount:CGFloat = 5
    
    /// 动画时间,default is 0.1
    lazy var animateDuration = 0.1
    
    /// 灰色星星视图
    lazy var unStarView:UIView = .init()
    
    /// 点亮星星视图
    lazy var starView:UIView = .init()
    
    /// 评分回调
    var scoreBlock:((CGFloat)->())?
    
    
    // MARK: - 对象实例化
    public override convenience init(frame: CGRect) {
        
        self.init(frame:frame, totalStarCount:5.0, currentStarCount:0.0, starSpace:5.0)
    }
    
    public init(frame:CGRect, totalStarCount:CGFloat, currentStarCount:CGFloat, starSpace:CGFloat) {
        
        super.init(frame: frame)
        
        self.totalStarCount = totalStarCount
        
        self.currentStarCount = currentStarCount
        
        /// 点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(startTap))
        
        addGestureRecognizer(tap)
        
        unStarView = setupStarView("unStar.png")
        
        addSubview(unStarView)
        
        starView = setupStarView("star.png")
        
        insertSubview(starView, aboveSubview: unStarView)
        
        showStarRate()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




// MARK: - CustomMethod
public extension StarRatingView{
    
    func show(type:StarType = .default, isPanEnable:Bool = true, leastStar:CGFloat = 0, completion:@escaping (_ score:CGFloat)->()) {
        
        self.starType = type
        
        self.isPanEnable = isPanEnable
        
        self.leastStar = leastStar
        
        self.scoreBlock = completion
        
    }
    
}



// MARK: - UI
extension StarRatingView {
    
    /// 绘制星星UI
    fileprivate func setupStarView(_ imageName:String) -> UIView {
        
        let starView = UIView(frame: bounds)
        
        starView.clipsToBounds = true
        
        let stackView = UIStackView(frame: bounds)
        
        stackView.axis = .horizontal
        
        stackView.distribution = .fillEqually
        
        stackView.spacing = starSpace
        
        starView.addSubview(stackView)
        
        //添加星星
        for _ in 0..<Int(totalStarCount) {
            let bundle = Bundle(for: StarRatingView.self)
            let image = UIImage(named: imageName, in: bundle, compatibleWith: nil)
            let imageView = UIImageView(image: image?.sd_tintedImage(with: #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1)))
            stackView.addArrangedSubview(imageView)
            
        }
        return starView
    }
    
    
    /// 显示评分
    fileprivate func showStarRate(){
        UIView.animate(withDuration: animateDuration, animations: {
            
            var count = self.currentStarCount
            
            if count < self.leastStar {
                
                count = self.leastStar
                
            }
            
            let spaceCount = ceil(count)
            
            let boundsW = self.bounds.width - (self.totalStarCount - 1) * self.starSpace
            
            let boundsH = self.bounds.height
            
            var starW:CGFloat = 0
            
            switch self.starType{
                
            case .default:
                
                count = ceil(count)
                
            case .half:
                
                count = ceil(count * 2) / 2
                
            case .unlimited:
                break
            }
            
            if self.lastScore == count{
                return
            }else{
                self.lastScore = count
            }
            
            self.scoreBlock?(count)
            
            starW = count / self.totalStarCount * boundsW + (spaceCount - 1) * self.starSpace
            
            if starW < 0 {
                starW = 0
            }
            
            self.starView.frame = CGRect(x: 0, y: 0, width: starW, height: boundsH)
        })
    }
    
}




// MARK: - 手势交互
extension StarRatingView {
    
    /// 滑动评分
    @objc func startPan(_ pan:UIPanGestureRecognizer) {
        
        var offX:CGFloat = 0
        
        if pan.state == .began{
            
            offX = pan.location(in: self).x
            
        }else if pan.state == .changed{
            
            offX += pan.location(in: self).x
            
        }else{
            
            return
        }
        
        if offX < 0 {
            
            offX = 0
            
        }
        
        if offX > bounds.maxX {
            
            offX = bounds.maxX
        }
        
        currentStarCount = offX / bounds.width * totalStarCount
        
        showStarRate()
        
    }
    
    /// 点击评分
    @objc func startTap(_ tap:UITapGestureRecognizer) {
        
        let offX = tap.location(in: self).x
        
        currentStarCount = offX / bounds.width * totalStarCount
        
        showStarRate()
        
    }
    
    
    
    
}
