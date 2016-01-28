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
        //Maybe open or intialize a managed Object context - like save button on add contact page
     
        if let editItem = self.editItem {
        
            if let firstName = self.firstName {
                editItem.firstName = firstName.text
            }
            if let lastName = self.lastName {
                editItem.lastName = lastName.text
            }
            if let workPhone = self.workPhone {
                editItem.workPhone = workPhone.text
            }
            if let homePhone = self.homePhone {
                editItem.homePhone = homePhone.text
            }
            if let mobilePhone = self.mobilePhone {
                editItem.mobilePhone = mobilePhone.text
            }
            if let workEmail = self.workEmail {
                editItem.workEmail = workEmail.text
            }
            if let homeEmail = self.homeEmail {
                editItem.homeEmail = homeEmail.text
            }
            if let address = self.address {
                editItem.address = address.text
            }
            if let city = self.city {
                editItem.city = city.text
            }
            if let state = self.state {
                editItem.state = state.text
            }
            if let zip = self.zip {
                editItem.zip = zip.text
            }
        }

        coreDataStack.saveMainContext()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //sendButton.enabled = true
        
        if textField == workPhone || textField == homePhone || textField == mobilePhone {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            
            let decimalString : String = components.joinWithSeparator("")
            let length = decimalString.characters.count
            let decimalStr = decimalString as NSString
            let hasLeadingOne = length > 0 && decimalStr.characterAtIndex(0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.appendString("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalStr.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalStr.substringWithRange(NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalStr.substringFromIndex(index)
            formattedString.appendString(remainder)
            textField.text = formattedString as String
            return false
        } else {
            return true
        }
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
        firstName.delegate = self
        lastName.delegate = self
        workPhone.delegate = self
        homePhone.delegate = self
        mobilePhone.delegate = self
        workEmail.delegate = self
        homeEmail.delegate = self
        address.delegate = self
        city.delegate = self
        state.delegate = self
        zip.delegate = self

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
        
        textField.resignFirstResponder()
        
        /*
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
        */
        
        return true
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var editItem: Contact?
        /*
        didSet {
            // Update the view.
            self.configureView()
        }
        */
    
    
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
