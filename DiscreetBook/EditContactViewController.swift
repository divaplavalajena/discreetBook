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
    
    //var editContact: Contact?
    
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
                //editContact?.setValue("\(firstName.text)", forKey: "firstName")
            }
            if let lastName = self.lastName {
                editItem.lastName = lastName.text
                //editContact?.setValue("\(lastName.text)", forKey: "lastName")
            }
            if let workPhone = self.workPhone {
                editItem.workPhone = workPhone.text
                //editContact?.setValue("\(workPhone.text)", forKey: "workPhone")
            }
            if let homePhone = self.homePhone {
                editItem.homePhone = homePhone.text
                //editContact?.setValue("\(homePhone.text)", forKey: "homePhone")
            }
            if let mobilePhone = self.mobilePhone {
                editItem.mobilePhone = mobilePhone.text
                //editContact?.setValue("\(mobilePhone.text)", forKey: "mobilePhone")
            }
            if let workEmail = self.workEmail {
                editItem.workEmail = workEmail.text
                //editContact?.setValue("\(workEmail.text)", forKey: "workEmail")
            }
            if let homeEmail = self.homeEmail {
                editItem.homeEmail = homeEmail.text
                //editContact?.setValue("\(homeEmail.text)", forKey: "homeEmail")
            }
            if let address = self.address {
                editItem.address = address.text
                //editContact?.setValue("\(address.text)", forKey: "address")
            }
            if let city = self.city {
                editItem.city = city.text
                //editContact?.setValue("\(city.text)", forKey: "city")
            }
            if let state = self.state {
                editItem.state = state.text
                //editContact?.setValue("\(state.text)", forKey: "state")
            }
            if let zip = self.zip {
                editItem.zip = zip.text
                //editContact?.setValue("\(zip.text)", forKey: "zip")
            }
        }

        coreDataStack.saveMainContext()
        
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
