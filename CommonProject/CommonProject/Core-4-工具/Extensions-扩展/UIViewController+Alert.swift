//
//  UIViewController+Alert.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/24.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation
import UIKit
import Rswift
//import Result
import MBProgressHUD
import SafariServices

enum ConfirmationError: LocalizedError {
    case cancel
}

extension UIViewController {
    func displayError(error: Error) {
        let alertController = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func confirm(
        title: String? = .none,
        message: String? = .none,
        okTitle: String = "OK",
        okStyle: UIAlertAction.Style = .default,
        completion: @escaping (Void, Error) -> Void
        ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.addAction(UIAlertAction(title: okTitle, style: okStyle, handler: { _ in
            //            completion(.success(()))
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { _ in
            //            completion(.failure(ConfirmationError.cancel))
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayLoading(
        text: String = String(format: NSLocalizedString("loading.dots", value: "Loading %@", comment: ""), "..."),
        animated: Bool = true, applicationIgnoreAllEvent: Bool = true
        ) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: animated)
        hud.label.text = text
        if applicationIgnoreAllEvent {
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    
    
    func hideLoading(animated: Bool = true) {
        MBProgressHUD.hide(for: view, animated: animated)
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func openURL(_ url: URL) {
        let controller = SFSafariViewController(url: url)
        controller.preferredBarTintColor = .blue
        controller.modalPresentationStyle = .pageSheet
        present(controller, animated: true, completion: nil)
    }
    
    func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    func showShareActivity(from sender: UIView, with items: [Any], completion: (() -> Swift.Void)? = nil) {
        let activityViewController = UIActivityViewController.make(items: items)
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = sender.centerRect
        present(activityViewController, animated: true, completion: completion)
    }
}
