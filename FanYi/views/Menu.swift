//
//  Menu.swift
//  FanYi
//
//  Created by Jorn on 2019/2/23.
//  Copyright © 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import UIKit

protocol MenuDelegate: class {
    func menu(_ menu: Menu, didSelectRowAt index: Int);
}

let kMENU_ITEM_HEIGHT = 50
let kMENU_ITEM_WIDTH = 180

class Menu: NSObject {
    private var mItems: [String]?
    
    var mDelegate: MenuDelegate?
    var mView: UIView!
    
    var isHidden: Bool = false {
        didSet {
            mView?.isHidden = isHidden
        }
    }
    
    
    static func creat(withItems items: [String], atPosition pos: CGPoint) -> Menu? {
        if items.count == 0 {
            JWLog.e("invalible param.")
            return nil
        }
        
        let menu = Menu()
        menu.mItems = items
        
        menu.mView = { () -> UITableView in
            let view = UITableView(frame: CGRect(x: pos.x,
                                                 y: pos.y,
                                                 width: CGFloat(kMENU_ITEM_WIDTH),
                                                 height: CGFloat(kMENU_ITEM_HEIGHT * items.count)),
                                   style: .plain)
            view.bounces = false
            view.showsVerticalScrollIndicator = false
            view.showsHorizontalScrollIndicator = false
            
            view.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            view.layer.cornerRadius = 10
            view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2518981074)
            
            view.delegate = menu
            view.dataSource = menu
            
            return view
        }()
        
        return menu
    }
    
    private override init() {
        super.init()
    }
}

extension Menu: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(kMENU_ITEM_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = self.mDelegate else {
            JWLog.i("Menu hava no delegate.")
            return
        }
        
        delegate.menu(self, didSelectRowAt: indexPath.row)
    }
}

extension Menu: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "MenuCell")
            cell?.selectionStyle = .none
            cell?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2493948063)
        }
        
        cell!.textLabel?.text = self.mItems?[indexPath.row]
        return cell!
    }
}
