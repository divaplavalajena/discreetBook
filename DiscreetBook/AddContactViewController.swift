//
//  AddContactViewController.swift
//  DiscreetBook
//
//  Created by Jena Grafton on 11/20/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController, UITextFieldDelegate {
    
    //var contentView: UIView!
    //var scrollView: UIScrollView!
    
    @IBOutlet var contactScrollView: UIScrollView!
    
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
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        //Code to save new contact from old version - NEED TO UPDATE TO Core Data version
//        let newContact = Contact(firstName: firstNameField.text!, lastName: lastNameField.text!, workPhone: workPhoneField.text!, homePhone: homePhoneField.text!, mobilePhone: mobilePhoneField.text!, workEmail: workEmailField.text!, homeEmail: homeEmailField.text!, address: addressField.text!, city: cityField.text!, state: stateField.text!, zip: zipField.text!)
//        ContactStore.sharedInstance.add(newContact)
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contactScrollView.backgroundColor = UIColor.grayColor()
        
        //scrollView = UIScrollView(frame: view.bounds)
        //scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        //scrollView.backgroundColor = UIColor.grayColor()
        //scrollView.contentSize = contentView.bounds.size
        
        //scrollView.addSubview(contentView)
        //view.addSubview(scrollView)
        
        contactScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contactScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
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
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
    
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
        
        contactScrollView.contentInset = contentInsets
        contactScrollView.scrollIndicatorInsets.bottom = adjustmentHeight
        contactScrollView.scrollIndicatorInsets.top = adjustmentHeight
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

