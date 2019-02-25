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
    
    weak var mDelegate: MenuDelegate?
    var mWindow: UIButton!
    
    var isHidden: Bool = false {
        didSet {
            mWindow.isHidden = isHidden
        }
    }
    
    
    static func creat(withItems items: [String], atPosition pos: CGPoint) -> Menu? {
        if items.count == 0 {
            JWLog.e("invalible param.")
            return nil
        }
        
        let menu = Menu()
        menu.mItems = items
        
        let menuView = { () -> UITableView in
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
            view.backgroundColor = kTHEME_CONTROL_COLOR
            
            view.delegate = menu
            view.dataSource = menu

            view.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
            
            return view
        }()
        
        menu.mWindow = { () -> UIButton in
           let window = UIButton(frame: CGRect(x: 0,
                                               y: 0,
                                               width: kMAIN_SCREEN_WIDTH,
                                               height: kMAIN_SCREEN_HEIGHT))
            window.addTarget(menu, action: #selector(onClickWindow), for: .touchUpInside)
            window.addSubview(menuView)
            return window
        }()
        
        return menu
    }

    @objc private func onClickWindow() {
        self.isHidden = !self.isHidden
    }
    
    private override init() {
    }
}

extension Menu: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(kMENU_ITEM_HEIGHT)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isHidden = !self.isHidden
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
        cell!.selectionStyle = .none
        cell!.backgroundColor = kTHEME_CONTROL_COLOR
        cell!.textLabel?.text = self.mItems?[indexPath.row]

        return cell!
    }
}
