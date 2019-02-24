//
//  ProfileViewController.swift
//  FanYi
//
//  Created by Jorn on 2019/2/23.
//  Copyright © 2019 Jorn Wu(jornwucn@gmail.com). All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: 300, height: 50))
        label.text = "This is profile view."

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
