//
//  EditContactViewController.swift
//  discreetBook
//
//  Created by Jena Grafton on 12/9/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import UIKit
import CoreData

class EditContactViewController: UIViewController, UITextFieldDelegate {
    
    var coreDataStack: CoreDataStack!
    
    var editContact: Contact?
    
    @IBOutlet var editScrollView: UIScrollView!
    
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var workPhone: UITextField!
    @IBOutlet var homePhone: UITextField!
    @IBOutlet var mobilePhone: UITextField!
    @IBOutlet var workEmail: UITextField!
    @IBOutlet var homeEmail: UITextField!
    @IBOutlet var address: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var zip: UITextField!
    
    @IBAction func cancelEditButton(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveEditButton(sender: AnyObject) {
     
        if let contactItem = self.editContact {
            
            if let firstName = self.firstName.text {
                contactItem.firstName = firstName
            }
        
            if let lastName = self.lastName.text {
                contactItem.lastName = lastName
                
            }
        
        
            if let workPhone = workPhone.text {
                contactItem.workPhone = workPhone
            }
        
        
            if let homePhone = homePhone.text {
                contactItem.homePhone = homePhone
            }
        
        
            if let mobilePhone = mobilePhone.text {
                contactItem.mobilePhone = mobilePhone
            }
        
        
            if let workEmail = workEmail.text {
                contactItem.workEmail = workEmail
            }
        
        
            if let homeEmail = homeEmail.text {
                contactItem.homeEmail = homeEmail
            }
        
        
            if let address = address.text {
                contactItem.address = address
            }
        
            if let city = city.text {
                contactItem.city = city
            }
        
            if let state = state.text {
                contactItem.state = state
            }
        
            if let zip = zip.text {
                contactItem.zip = zip
            }

            coreDataStack.saveMainContext()
        }
      
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        editScrollView.backgroundColor = UIColor.grayColor()
        
        editScrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        editScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        //Brings up keyboard
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.workPhone.delegate = self
        self.homePhone.delegate = self
        self.mobilePhone.delegate = self
        self.workEmail.delegate = self
        self.homeEmail.delegate = self
        self.address.delegate = self
        self.city.delegate = self
        self.state.delegate = self
        self.zip.delegate = self

        self.configureView()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        adjustInsetForKeyboardShow(true, notification: notification)
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        var userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        var contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 40, right: 0)
        let adjustmentHeight = (CGRectGetHeight(keyboardFrame)) * (show ? 1 : -1)
        
        if show == false {
            contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        editScrollView.contentInset = contentInsets
        editScrollView.scrollIndicatorInsets.bottom = adjustmentHeight
        editScrollView.scrollIndicatorInsets.top = adjustmentHeight
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        workPhone.resignFirstResponder()
        homePhone.resignFirstResponder()
        mobilePhone.resignFirstResponder()
        workEmail.resignFirstResponder()
        homeEmail.resignFirstResponder()
        address.resignFirstResponder()
        city.resignFirstResponder()
        state.resignFirstResponder()
        zip.resignFirstResponder()
        
        return true
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var editItem: Contact? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let contactItem = self.editItem {
            
            if let firstName = self.firstName {
                firstName.text = contactItem.firstName
            }
            if let lastName = self.lastName {
                lastName.text = contactItem.lastName
            }
            if let workPhone = self.workPhone {
                workPhone.text = contactItem.workPhone
            }
            if let homePhone = self.homePhone {
                homePhone.text = contactItem.homePhone
            }
            if let mobilePhone = self.mobilePhone {
                mobilePhone.text = contactItem.mobilePhone
            }
            if let workEmail = self.workEmail {
                workEmail.text = contactItem.workEmail
            }
            if let homeEmail = self.homeEmail {
                homeEmail.text = contactItem.homeEmail
            }
            if let address = self.address {
                address.text = contactItem.address
            }
            if let city = self.city {
                city.text = contactItem.city
            }
            if let state = self.state {
                state.text = contactItem.state
            }
            if let zip = self.zip {
                zip.text = contactItem.zip
            }
            
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
