//
//  UIViewUtil.swift
//  NIBM Events
//
//  Created by Pradeep Sanjaya on 2/28/20.
//  Copyright © 2020 Pradeep Sanjaya. All rights reserved.
//

import UIKit

class UIViewUtil {
    static func setUnsetError(of control: UIView, forValidStatus status: Bool) {
        if (status == false) {
            control.layer.borderColor = UIColor.red.cgColor//UIColor(named: "Red")?.cgColor
        } else {
            control.layer.borderColor = UIColor(named: "DarkBlue")?.cgColor
        }
    }

}
