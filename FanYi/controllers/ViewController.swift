//
//  ViewController.swift
//  FanYi
//
//  Created by Jorn on 2019-02-21.
//  Copyright © 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

    private let kTAG_TOP_LEFT = 0x01
    private let kTAG_TOP_RIGHT = 0x02
    private let kTAG_FD_LEFT = 0x21
    private let kTAG_FD_RIGHT = 0x22
    private let kTAG_BOTTOM_LEFT = 0x31
    private let kTAG_BOTTOM_RIGHT = 0x32

    private var mTopLeftBtn: UIButton!
    private var mTopRghtBtn: UIButton!

    private var mInputTextFd: UITextField!
    private var mInputTextFdLeftBtn: UIButton!
    private var mInputTextFdRightBtn: UIButton!

    private var mCHBtn: UIButton!
    private var mEGBtn: UIButton!

    private var mHistoryTableView: UITableView!

    private let mMenuItems = ["Interpretation", "Invite", "Settings"]
    private var mMenu: Menu!
    
    private var mShare: Share!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)

        setupTopItems()
        setupBottomItems()
        setupTableView()
        setupMenuView()
        setupShareView()

        listenBtnsAction()
    }

    private func setupTopItems() {
        mTopLeftBtn = { () -> UIButton in
            let btn = UIButton(frame: .zero)
            btn.tag = kTAG_TOP_LEFT
            btn.setTitle("Profile", for: .normal)
            let item = UIBarButtonItem(customView: btn)
            self.navigationItem.leftBarButtonItem = item
            return btn
        }()

        mTopRghtBtn = { () -> UIButton in
            let btn = UIButton(frame: .zero)
            btn.tag = kTAG_TOP_RIGHT
            btn.setTitle("Menu", for: .normal)
            let item = UIBarButtonItem(customView: btn)
            self.navigationItem.rightBarButtonItem = item
            return btn
        }()

        mInputTextFd = { () -> UITextField in
            let textField = UITextField(frame: CGRect(x: 0, y: 0, width: kMAIN_SCREEN_WIDTH - (100 - 20), height: 30))
            textField.backgroundColor = kTHEME_CONTROL_COLOR
            textField.layer.cornerRadius = 5
            textField.delegate = self
            textField.returnKeyType = .done
            self.navigationItem.titleView = textField
            return textField
        }()

        mInputTextFdLeftBtn = { () -> UIButton in
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            btn.tag = kTAG_FD_LEFT
            btn.setTitle("CL", for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 12)
            btn.backgroundColor = kTHEME_CONTROL_COLOR
            btn.layer.cornerRadius = 5

            mInputTextFd.leftView = btn
            mInputTextFd.leftViewMode = .always

            return btn
        }()

        mInputTextFdRightBtn = { () -> UIButton in
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 0, y: 0, width: 25, height: 15)
            btn.tag = kTAG_FD_RIGHT
            btn.setImage(#imageLiteral(resourceName: "Camera.png"), for: .normal)
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
            btn.titleLabel?.font = .systemFont(ofSize: 12)
            btn.layer.cornerRadius = 5

            mInputTextFd.rightView = btn
            mInputTextFd.rightViewMode = .always

            return btn
        }()
    }

    private func setupTableView() {
        mHistoryTableView = {
            let view = UITableView(frame: CGRect(x: 0,
                    y: 64,
                    width: kMAIN_SCREEN_WIDTH,
                    height: kMAIN_SCREEN_HEIGHT - 64),
                    style: .plain)
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            view.isHidden = true

            view.delegate = self
            view.dataSource = self

            return view
        }()

        self.view.addSubview(mHistoryTableView)
    }

    private func setupBottomItems() {
        let containerView = { () -> UIView in
            let view = UIView(frame: CGRect(x: 0, y: kMAIN_SCREEN_HEIGHT - 70, width: kMAIN_SCREEN_WIDTH, height: 70))
            view.backgroundColor = kTHEME_BOCKGROUND_COLOR

            self.view.addSubview(view)
            return view
        }()


        let width = (kMAIN_SCREEN_WIDTH - 50 - 2) / 2

        mCHBtn = { () -> UIButton in
            let btn = UIButton(type: .system)
            btn.frame = CGRect(x: 25, y: 10, width: width, height: 40)
            btn.tag = kTAG_BOTTOM_LEFT
            btn.setTitle("按住说中文", for: .normal)
            btn.backgroundColor = kTHEME_CONTROL_COLOR

            containerView.addSubview(btn)

            return btn
        }()

        mEGBtn = { () -> UIButton in
            let btn = UIButton(type: .system)
            btn.frame = CGRect(x: kMAIN_SCREEN_WIDTH - 25 - width, y: 10, width: width, height: 40)
            btn.tag = kTAG_BOTTOM_RIGHT
            btn.setTitle("English", for: .normal)
            btn.backgroundColor = kTHEME_CONTROL_COLOR

            containerView.addSubview(btn)
            
            return btn
        }()
    }

    private func setupMenuView() {
        mMenu = {
            let menu = Menu.creat(withItems: mMenuItems,
                                  atPosition: CGPoint(x: kMAIN_SCREEN_WIDTH - CGFloat(5 + kMENU_ITEM_WIDTH),
                                                      y: 64 + 5))
            guard menu != nil else {
                JWLog.e("MenuView creat fail.")
                return nil
            }
            
            menu!.mDelegate = self
            menu!.isHidden = true
            
            UIApplication.shared.keyWindow?.addSubview(menu!.mWindow)
            return menu
        }()
    }
    
    private func setupShareView() {
        mShare = {
            let share = Share.create()
            
            share.mDelegate = self
            share.isHidden = true
            
            UIApplication.shared.keyWindow?.addSubview(share.mWindow)
            return share
        }()
    }

}

extension ViewController {

    private func listenBtnsAction() {
        mTopLeftBtn.addTarget(self, action: #selector(btnActin(button:)), for: .touchUpInside)
        mTopRghtBtn.addTarget(self, action: #selector(btnActin(button:)), for: .touchUpInside)
        mInputTextFdLeftBtn.addTarget(self, action: #selector(btnActin(button:)), for: .touchUpInside)
        mInputTextFdRightBtn.addTarget(self, action: #selector(btnActin(button:)), for: .touchUpInside)
        mCHBtn.addTarget(self, action: #selector(btnActin(button:)), for: .touchUpInside)
        mEGBtn.addTarget(self, action: #selector(btnActin(button:)), for: .touchUpInside)
    }

    @objc func btnActin(button: UIButton) {
        switch button.tag {
        case kTAG_TOP_LEFT: intoProfileView()
        case kTAG_TOP_RIGHT: showMenuView()
        case kTAG_FD_LEFT:print(button.tag)
        case kTAG_FD_RIGHT:print(button.tag)
        case kTAG_BOTTOM_LEFT:print(button.tag)
        case kTAG_BOTTOM_RIGHT:print(button.tag)
        default: return
        }
    }

    private func intoProfileView() {
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    private func intoTargetLanguageView() {
        let tlVC = TargetLanguageViewController()
        self.navigationController?.pushViewController(tlVC, animated: false)
    }

    private func showMenuView() {
        guard self.mMenu != nil else {
            JWLog.i("The menu have not been created.")
            return
        }

        self.mMenu.isHidden = false
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        ///
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        ///
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: "HistoryTableCell")
    }
}

extension ViewController: MenuDelegate {
    func menu(_ menu: Menu, didSelectRowAt index: Int) {
        switch index {
        case 0: intoInterpretationView()
        case 1: showShareView()
        case 2: intoSettingsView()
        default:
            return
        }
    }
    
    private func intoInterpretationView() {
        
    }
    
    private func showShareView() {
//        let alertVC = ShareViewController()
//        self.present(alertVC, animated: false, completion: nil)
        self.mShare.isHidden = false
    }
    
    private func intoSettingsView() {
        let setVC = SettingsViewController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
}

extension ViewController: ShareDelegate {
    func share(_ share: Share, didSelectRowAt index: Int) {
        ///
    }
}
