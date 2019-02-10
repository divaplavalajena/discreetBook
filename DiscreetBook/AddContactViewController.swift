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
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func saveButton(_ sender: Any) {
        saveContact()
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func saveContact() {
        //Code to save new contact
        if let entity = NSEntityDescription.entity(forEntityName: "Contact", in: coreDataStack.managedObjectContext) {
            let newContact = Contact(entity: entity, insertInto: coreDataStack.managedObjectContext)
            
            if let firstName = self.firstName {
                newContact.firstName = firstName.text
            }
            if let lastName = self.lastName {
                newContact.lastName = lastName.text
                if var lastInitial = lastName.text {
                    lastInitial = lastInitial.substring(to: lastInitial.characters.index(lastInitial.startIndex, offsetBy: 1))
                    newContact.lastInitial = lastInitial
                    print("This is the last name initial saved to the record")
                    print(lastInitial)
                }
                
            }else {
                if var firstInitial = firstName.text {
                    firstInitial = firstInitial.substring(to: firstInitial.characters.index(firstInitial.startIndex, offsetBy: 1))
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
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //sendButton.enabled = true
        
        if textField == workPhone || textField == homePhone || textField == mobilePhone {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let components = newString.components(separatedBy: CharacterSet.decimalDigits.inverted)
            
            let decimalString : String = components.joined(separator: "")
            let length = decimalString.characters.count
            let decimalStr = decimalString as NSString
            let hasLeadingOne = length > 0 && decimalStr.character(at: 0) == (1 as unichar)
            
            if length == 0 || (length > 10 && !hasLeadingOne) || length > 11
            {
                let newLength = (textField.text! as NSString).length + (string as NSString).length - range.length as Int
                
                return (newLength > 10) ? false : true
            }
            var index = 0 as Int
            let formattedString = NSMutableString()
            
            if hasLeadingOne
            {
                formattedString.append("1 ")
                index += 1
            }
            if (length - index) > 3
            {
                let areaCode = decimalStr.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("(%@)", areaCode)
                index += 3
            }
            if length - index > 3
            {
                let prefix = decimalStr.substring(with: NSMakeRange(index, 3))
                formattedString.appendFormat("%@-", prefix)
                index += 3
            }
            
            let remainder = decimalStr.substring(from: index)
            formattedString.append(remainder)
            textField.text = formattedString as String
            return false
        } else {
            return true
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        contactScrollView.backgroundColor = UIColor.gray
        
        contactScrollView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        contactScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddContactViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//    }
    
    func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)

    }
    
    func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        var userInfo = (notification as NSNotification).userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        var contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + 40, right: 0)
        let adjustmentHeight = (keyboardFrame.height) * (show ? 1 : -1)
        
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


