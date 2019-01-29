//
//  BaseViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/23.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, NoDataProtocol {
    
    var noDataImageView: UIImageView = UIImageView()
    
    var statusBarStyle: UIStatusBarStyle = .lightContent {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    //MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupViews()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    //    shouldAutorotateToInterfaceOrientation
    
    
    
    func setupViews() {
        //默认白色背景
        view.backgroundColor = .white
    }
    
    func backButtonClicked() {
        if let _ = presentingViewController {
            dismiss(animated: true, completion: nil)
        }else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}


//MARK: - NoDataProtocol
extension BaseViewController {
    
    
    func showNoDataImage() {
        noDataImageView.image = UIImage(named: "")
        for (_, subView) in view.subviews.enumerated() where subView is UITableView {
            noDataImageView.frame = CGRect(x: 0, y: 0, width: subView.frame.width, height: subView.frame.height)
            subView.addSubview(noDataImageView)
        }
    }
    
    func removeNoDataImage() {
        noDataImageView.removeFromSuperview()
    }
    
    
}

//MARK: - NetworkLoadingProtocol
extension BaseViewController: NetworkLoadingProtocol {
    
    func showLoadingAnimation() {
        
    }
    
    func stopLoadingAnimation() {
        
    }
    
}
