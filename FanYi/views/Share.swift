//
//  Share.swift
//  FanYi
//
//  Created by Jorn on 2019/2/25.
//  Copyright © 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import UIKit

@objc protocol ShareDelegate {
    func share(_ share: Share, didSelectRowAt index: Int);
    @objc optional func didCancelShare(_ share: Share);
}

class Share: NSObject {
    private let mItems = ["WeChat", "Moments", "Weibo", "More"]
    private let mItemWidth = 80
    private let mItemHeight = 100
    private let mContentHeight = 200
    private let mSpase10 = 10
    private let mSpase20 = 20
    
    weak var mDelegate: ShareDelegate?
    
    private var mContentView: UIView!
    var mWindow: UIButton!
    
    var isHidden: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3, animations: {
                if self.isHidden {
                    self.mWindow.alpha = 0
                    self.mContentView.center = CGPoint(x: kMAIN_SCREEN_WIDTH / 2,
                                                       y: kMAIN_SCREEN_HEIGHT + CGFloat(self.mContentHeight / 2))
                } else {
                    self.mWindow.isHidden = self.isHidden
                    self.mWindow.alpha = 1
                    
                    self.mContentView.center = CGPoint(x: kMAIN_SCREEN_WIDTH / 2,
                                                       y: kMAIN_SCREEN_HEIGHT - CGFloat(self.mContentHeight / 2))
                }
            }) { (isCompelet) in
                if isCompelet {
                    self.mWindow.isHidden = self.isHidden
                }
            }
        }
    }
    
    
    static func create() -> Share {
        let share = Share()
        share.mContentView = share.setupView()
        
        share.mWindow = { () -> UIButton in
            let window = UIButton(frame: CGRect(x: 0,
                                                y: 0,
                                                width: kMAIN_SCREEN_WIDTH,
                                                height: kMAIN_SCREEN_HEIGHT))
            window.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
            window.addTarget(share, action: #selector(onClickWindow), for: .touchUpInside)
            window.addSubview(share.mContentView)
            return window
        }()
        
        return share
    }
    
    @objc private func onClickWindow() {
        self.isHidden = !self.isHidden
    }
    
    private func setupView() -> UIView {
        // spase of start and end
        let header = (Int(kMAIN_SCREEN_WIDTH) - (self.mSpase10 * 2 + self.mSpase20 * 3 + self.mItemWidth * 4)) / 2
        var index = 0
        let contentView = { () -> UIView in
            let view = UIView(frame: CGRect(x: 0,
                                            y: kMAIN_SCREEN_HEIGHT,
                                            width: kMAIN_SCREEN_WIDTH,
                                            height: CGFloat(mContentHeight)))
            
            let containerView = UIView(frame: CGRect(x: self.mSpase10,
                                            y: 0,
                                            width: Int(kMAIN_SCREEN_WIDTH) - self.mSpase10 * 2,
                                            height: self.mContentHeight - self.mSpase10 * 2 - 60))
            containerView.layer.cornerRadius = CGFloat(self.mSpase10)
            containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.95)
            view.addSubview(containerView)
            
            for item in self.mItems {
                let itemView = UIButton(type: .custom)
                itemView.frame = CGRect(x: Int(header) + (self.mSpase20 + self.mItemWidth) * index,
                                        y: self.mSpase10,
                                        width: self.mItemWidth,
                                        height: self.mItemHeight)
                itemView.showsTouchWhenHighlighted = false
                
                itemView.setImage(UIImage(named: item), for: .normal)
                
                let titleLb = UILabel(frame: CGRect(x: 0,
                                                    y: 70,
                                                    width: self.mItemWidth,
                                                    height: self.mItemHeight - 70))
                titleLb.text = item
                titleLb.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                titleLb.textAlignment = .center
                titleLb.font = .systemFont(ofSize: 13)
                itemView.addSubview(titleLb)
                
                itemView.imageView?.layer.cornerRadius = 30
                itemView.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 30, right: 10)
                
                itemView.addTarget(self, action: #selector(itemAction(button:)), for: .touchUpInside)
                
                containerView.addSubview(itemView)
                index += 1
            }
            
            let cancelBtn = UIButton(type: .system)
            cancelBtn.frame = CGRect(x: self.mSpase10,
                                     y: self.mContentHeight - self.mSpase10 - 60,
                                     width: Int(kMAIN_SCREEN_WIDTH) - self.mSpase10 * 2,
                                     height: 60)
            cancelBtn.setTitle("Cancel", for: .normal)
            cancelBtn.titleLabel?.font = .systemFont(ofSize: 20)
            cancelBtn.setTitleColor(kTHEME_BUBBLE_COLOR, for: .normal)
            cancelBtn.layer.cornerRadius = CGFloat(self.mSpase10)
            cancelBtn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.95)
            
            cancelBtn.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
            
            view.addSubview(cancelBtn)
            
            return view
        }()
        
        return contentView
    }
    
    @objc private func itemAction(button: UIButton) {
        self.isHidden = !self.isHidden
        
        guard let delegate = self.mDelegate else {
            JWLog.i("Menu hava no delegate.")
            return
        }
        
        delegate.share(self, didSelectRowAt: button.tag)
    }
    
    @objc private func cancelAction() {
        self.isHidden = !self.isHidden
        
        guard let delegate = self.mDelegate else {
            JWLog.i("Menu hava no delegate.")
            return
        }
        
        delegate.didCancelShare?(self)
    }
    
    private override init() {
    }
}
