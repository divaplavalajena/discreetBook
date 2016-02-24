//
//  DetailViewController.swift
//  discreetBook
//
//  Created by Jena Grafton on 11/20/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
import CoreSpotlight
import MobileCoreServices


class DetailViewController: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    var coreDataStack: CoreDataStack!
    var editViewController: EditContactViewController?
    
    @IBOutlet var detailScrollView: UIScrollView!
    
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!

    @IBOutlet var workPhoneOutlet: UIButton!
    @IBAction func workPhoneButton(sender: AnyObject) {
        let sender = sender
        let workPhoneText = workPhoneOutlet.titleLabel?.text
        if workPhoneText != nil || workPhoneText != "" {
            showShareOptions(sender)
        }
    }
    
    @IBOutlet var homePhoneOutlet: UIButton!
    @IBAction func homePhoneButton(sender: AnyObject) {
        let sender = sender
        let homePhoneText = homePhoneOutlet.titleLabel?.text
        if homePhoneText != nil || homePhoneText != "" {
            showShareOptions(sender)
        }
    }
    
    @IBOutlet var mobilePhoneOutlet: UIButton!
    @IBAction func mobilePhoneButton(sender: AnyObject) {
        let sender = sender
        let mobilePhoneText = mobilePhoneOutlet.titleLabel?.text
        if mobilePhoneText != nil || mobilePhoneText != "" {
            showShareOptions(sender)
        }
    }
    
    @IBOutlet var workEmailOutlet: UIButton!
    @IBAction func workEmailButton(sender: AnyObject) {
        let sender = sender
        let mailComposeViewController = configuredMailComposeViewController(sender)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBOutlet var homeEmailOutlet: UIButton!
    @IBAction func homeEmailButton(sender: AnyObject) {
        let sender = sender
        let mailComposeViewController = configuredMailComposeViewController(sender)
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var zipLabel: UILabel!
    
    //Option of action on phone Buttons - phone call or text message based on User's AlertController Selection
    func showShareOptions(sender: AnyObject) {
        let sender = sender
        let actionSheet = UIAlertController(title: "", message: "Call or Text", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let phoneCallAction = UIAlertAction(title: "Phone Call", style: UIAlertActionStyle.Default) { (action) -> Void in
            switch sender.tag {
            case 1:
                if let workPhoneText = self.workPhoneOutlet.titleLabel?.text{
                    if let url = NSURL(string: "tel:\(workPhoneText)") {
                        let application = UIApplication.sharedApplication()
                        if application.canOpenURL(url) {
                            application.openURL(url)
                        }
                        else{
                            print("Phone call failed")
                        }
                    }
                }
            case 2:
                if let homePhoneText = self.homePhoneOutlet.titleLabel?.text {
                    if let url = NSURL(string: "tel:\(homePhoneText)") {
                        let application = UIApplication.sharedApplication()
                        if application.canOpenURL(url) {
                            application.openURL(url)
                        }
                        else{
                            print("Phone call failed")
                        }
                    }

                }
            case 3:
                if let mobilePhoneText = self.mobilePhoneOutlet.titleLabel?.text {
                    if let url = NSURL(string: "tel:\(mobilePhoneText)") {
                        let application = UIApplication.sharedApplication()
                        if application.canOpenURL(url) {
                            application.openURL(url)
                        }
                        else{
                            print("Phone call failed")
                        }
                    }
                }
            default:
                break;
            }
        }
        
        
        let messageAction = UIAlertAction(title: "Text Message", style: UIAlertActionStyle.Default) { (action) -> Void in
            var phoneNumber: String
            switch sender.tag {
            case 1:
                if let workPhoneText = self.workPhoneOutlet.titleLabel?.text {
                    phoneNumber = workPhoneText
                    self.sendMessage(phoneNumber)
                }
            case 2:
                if let homePhoneText = self.homePhoneOutlet.titleLabel?.text {
                    phoneNumber = homePhoneText
                    self.sendMessage(phoneNumber)
                }
            case 3:
                if let mobilePhoneText = self.mobilePhoneOutlet.titleLabel?.text {
                    phoneNumber = mobilePhoneText
                    self.sendMessage(phoneNumber)
                }
            default:
                break;
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        actionSheet.addAction(phoneCallAction)
        actionSheet.addAction(messageAction)
        actionSheet.addAction(cancelAction)
        
        //If iPad treat alert differently
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = sender as? UIView
                popoverController.sourceRect = sender.bounds
            }
            self.presentViewController(actionSheet, animated: true, completion: nil)
        } else {
            presentViewController(actionSheet, animated: true, completion: nil)
        }
        
        
    }
    
    //sending text message
    func sendMessage(phoneNumber: String) {
        let phoneNumber = phoneNumber
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        messageVC.recipients = ["\(phoneNumber)"] //Optionally add some telephone numbers
        messageVC.messageComposeDelegate = self;
        
        self.presentViewController(messageVC, animated: true, completion: nil)
    }

    //compose view controller for text message
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        /*switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
        */
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //methods to compose emails on view
    func configuredMailComposeViewController(sender: AnyObject) -> MFMailComposeViewController {
        let sender = sender
        var emailAddress: String
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        switch sender.tag {
        case 1:
            if let workEmailText = self.workEmailOutlet.titleLabel?.text {
                emailAddress = workEmailText
                mailComposerVC.setToRecipients(["\(emailAddress)"])
            }
        case 2:
            if let homeEmailText = self.homeEmailOutlet.titleLabel?.text {
                emailAddress = homeEmailText
                mailComposerVC.setToRecipients(["\(emailAddress)"])
            }
        default:
            break;
        }

        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        //(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        sendMailErrorAlert.addAction(cancelAction)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //variable and method to compose and configure main view
    var detailItem: Contact? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            
            if let firstNameLabel = self.firstNameLabel {
                firstNameLabel.text = detail.firstName
            }
            if let lastNameLabel = self.lastNameLabel {
                lastNameLabel.text = detail.lastName
            }
            if let workPhoneOutlet = self.workPhoneOutlet {
                workPhoneOutlet.setTitle(detail.workPhone, forState: UIControlState.Normal)
            }
            if let homePhoneOutlet = self.homePhoneOutlet {
                homePhoneOutlet.setTitle(detail.homePhone, forState: UIControlState.Normal)
            }
            if let mobilePhoneOutlet = self.mobilePhoneOutlet {
                mobilePhoneOutlet.setTitle(detail.mobilePhone, forState: UIControlState.Normal)
            }
            if let workEmailOutlet = self.workEmailOutlet {
                workEmailOutlet.setTitle(detail.workEmail, forState: UIControlState.Normal)
            }
            if let homeEmailOutlet = self.homeEmailOutlet {
                homeEmailOutlet.setTitle(detail.homeEmail, forState: UIControlState.Normal)
            }
            if let addressLabel = self.addressLabel {
                addressLabel.text = detail.address
            }
            if let cityLabel = self.cityLabel {
                cityLabel.text = detail.city
            }
            if let stateLabel = self.stateLabel {
                stateLabel.text = detail.state
            }
            if let zipLabel = self.zipLabel {
                zipLabel.text = detail.zip
            }
            
            var firstName = ""
            if detail.firstName != nil {
                firstName = "\(detail.firstName!)"
            }
            var lastName = ""
            if detail.lastName != nil {
                lastName = "\(detail.lastName!)"
            }
            var workPhone = ""
            if detail.workPhone != nil {
                workPhone = "\(detail.workPhone!)"
            }
            var homePhone = ""
            if detail.homePhone != nil {
                homePhone = "\(detail.homePhone!)"
            }
            var mobilePhone = ""
            if detail.mobilePhone != nil {
                mobilePhone = "\(detail.mobilePhone!)"
            }
            var workEmail = ""
            if detail.workEmail != nil {
                workEmail = "\(detail.workEmail!)"
            }
            var homeEmail = ""
            if detail.homeEmail != nil {
                homeEmail = "\(detail.homeEmail!)"
            }
            
            let activity = NSUserActivity(activityType: "com.bellavoceproductions.discreet-Book.name")
            activity.userInfo = ["firstName": firstName, "lastName": lastName, "workPhone": workPhone, "homePhone": homePhone, "mobilePhone": mobilePhone, "workEmail": workEmail, "homeEmail": homeEmail]
            
            if detail.firstName != nil && detail.lastName != nil {
                activity.title = "\(detail.firstName!) \(detail.lastName!)"
            } else if detail.firstName != nil {
                activity.title = "\(detail.firstName!)"
            } else if detail.lastName != nil {
                activity.title = "\(detail.lastName!)"
            }
            
            var fullName = ""
            if detail.firstName != nil && detail.lastName != nil {
                fullName = "\(detail.firstName!) \(detail.lastName!)"
            }
            
            var keywords = fullName.componentsSeparatedByString(" ")
            if detail.homePhone != nil {
                keywords.append(detail.homePhone!)
            }
            if detail.workPhone != nil {
                keywords.append(detail.workPhone!)
            }
            if detail.mobilePhone != nil {
                keywords.append(detail.mobilePhone!)
            }
            if detail.homeEmail != nil {
                keywords.append(detail.homeEmail!)
            }
            if detail.workEmail != nil {
                keywords.append(detail.workEmail!)
            }

            activity.keywords = Set(keywords)
            activity.eligibleForHandoff = false
            activity.eligibleForSearch = true
            //activity.eligibleForPublicIndexing = true
            //activity.expirationDate = NSDate()
            
            
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeContact as String)
            // Set the title - first name + last name
            attributeSet.title = fullName
            
            attributeSet.supportsPhoneCall = true
            // Set the phone numnber to mobilePhone, homePhone, and workPhone
            attributeSet.phoneNumbers = ["\(detail.mobilePhone)", "\(detail.homePhone)", "\(detail.workPhone)"]
            
            
            //Set the email address to workEmail and homeEmail
            attributeSet.emailAddresses = ["\(detail.workEmail)", "\(detail.homeEmail)"]
            
            attributeSet.relatedUniqueIdentifier = detail.firstName
            
            switch Setting.searchIndexingPreference {
            case .Disabled:
                activity.eligibleForSearch = false
            case .ViewedRecords:
                activity.eligibleForSearch = true
                activity.contentAttributeSet?.relatedUniqueIdentifier = nil
            case .AllRecords:
                activity.eligibleForSearch = true
            }
            
            userActivity = activity
            activity.becomeCurrent()
            
        }
    }

    
    /*
    override func updateUserActivityState(activity: NSUserActivity) {
        activity.addUserInfoEntriesFromDictionary(employee.userActivityUserInfo)
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        detailScrollView.backgroundColor = UIColor.grayColor()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        detailScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        detailScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.configureView()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editContact" {
            let object = detailItem
                let controller = segue.destinationViewController as! EditContactViewController
                controller.coreDataStack = coreDataStack
                controller.editItem = object
            }
    
    }


}





