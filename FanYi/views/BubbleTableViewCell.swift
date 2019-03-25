//
//  BubbleTableViewCell.swift
//  FanYi
//
//  Created by Jorn on 2019/3/20.
//  Copyright © 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import UIKit

class BubbleTableViewCell: UITableViewCell {
    private var mBubbleView: UIView!
    private var mWordLb: UILabel!
    private var mTranslationLb: UILabel!
    private var mDetailBtn: UIButton!
    private var mPlayBtn: UIButton!
    
    private var mModel: TranslationModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mBubbleView = UIView(frame: .zero)
        self.addSubview(mBubbleView)
        
        mWordLb = UILabel(frame: .zero)
        mTranslationLb = UILabel(frame: .zero)
    }
    
    public func setModel(model: TranslationModel) {
        if mModel != model {
            mModel = model
            
            
            
        }
    }
    
    override func layoutSubviews() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
