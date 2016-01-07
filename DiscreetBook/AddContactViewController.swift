//
//  AddContactViewController.swift
//  discreetBook
//
//  Created by Jena Grafton on 11/20/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import UIKit
import CoreData

class AddContactViewController: UIViewController, UITextFieldDelegate {
    
    var coreDataStack: CoreDataStack!
    
    var newContact: Contact?
    
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

        //Code to save new contact
        if let entity = NSEntityDescription.entityForName("Contact", inManagedObjectContext: coreDataStack.managedObjectContext) {
            let newContact = Contact(entity: entity, insertIntoManagedObjectContext: coreDataStack.managedObjectContext)
            
            if let firstName = self.firstName {
                newContact.firstName = firstName.text
            }
            if let lastName = self.lastName {
                newContact.lastName = lastName.text
                if var lastInitial = lastName.text {
                    lastInitial = lastInitial.substringToIndex(lastInitial.startIndex.advancedBy(1))
                    newContact.lastInitial = lastInitial
                    print("This is the last name initial saved to the record")
                    print(lastInitial)
                }
                
            }else {
                if var firstInitial = firstName.text {
                    firstInitial = firstInitial.substringToIndex(firstInitial.startIndex.advancedBy(1))
                    newContact.lastInitial = firstInitial
                    print("This is the first name initial saved to the record")
                    print(firstInitial)
                }
            }

            
            if let workPhone = self.workPhone {
                newContact.workPhone = workPhone.text
            }
            if let homePhone = self.homePhone {
                newContact.homePhone = homePhone.text
            }
            if let mobilePhone = self.mobilePhone {
                newContact.mobilePhone = mobilePhone.text
            }
            if let workEmail = self.workEmail {
                newContact.workEmail = workEmail.text
            }
            if let homeEmail = self.homeEmail {
                newContact.homeEmail = homeEmail.text
            }
            if let address = self.address {
                newContact.address = address.text
            }
            if let city = self.city {
                newContact.city = city.text
            }
            if let state = self.state {
                newContact.state = state.text
            }
            if let zip = self.zip {
                newContact.zip = zip.text
            }
        }
        
        coreDataStack.saveMainContext()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //sendButton.enabled = true
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
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contactScrollView.backgroundColor = UIColor.grayColor()
        
        contactScrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
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


