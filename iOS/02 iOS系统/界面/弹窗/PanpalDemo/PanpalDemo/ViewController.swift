//
//  ViewController.swift
//  PanpalDemo
//
//  Created by coderiding on 2020/11/28.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    lazy var button:UIButton = {
        let btn = UIButton()
        btn.setTitle("点我", for: .normal)
        btn.backgroundColor = UIColor.red
        btn.addTarget(nil, action: #selector(clickBtn), for: .touchDown)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.height.equalTo(100)
            make.width.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    @objc func clickBtn() {
        let storyboard = UIStoryboard(name: "TVC2", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TVC2")
        
        presentPanModal(vc)
    }


}

