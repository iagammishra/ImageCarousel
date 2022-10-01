//
//  AMUtility.swift
//  Carousel
//
//  Created by Agam Mishra on 01/10/22.
//

import UIKit
open class AMUtility {
    open class func showAlert(title: String, message: String, controller: UIViewController) {
        let alertview = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: UIAlertController.Style.alert)
        alertview.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            print("Ok")
        }))
        controller.present(alertview, animated: true, completion: nil)
    }
}
