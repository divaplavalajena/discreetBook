//
//  UIViewController+discreetBook.swift
//  discreetBook
//
//  Created by Jena Grafton on 3/3/19.
//  Copyright © 2019 Bella Voce Productions. All rights reserved.
//

import UIKit

extension UIViewController {

    func showAlert(title: String, message: String, style: UIAlertAction.Style = .default) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: style, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
}
