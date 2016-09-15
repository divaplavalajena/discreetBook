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
    @IBAction func workPhoneButton(_ sender: AnyObject) {
        let sender = sender
        let workPhoneText = workPhoneOutlet.titleLabel?.text
        if workPhoneText != nil || workPhoneText != "" {
            showShareOptions(sender)
        }
    }
    
    @IBOutlet var homePhoneOutlet: UIButton!
    @IBAction func homePhoneButton(_ sender: AnyObject) {
        let sender = sender
        let homePhoneText = homePhoneOutlet.titleLabel?.text
        if homePhoneText != nil || homePhoneText != "" {
            showShareOptions(sender)
        }
    }
    
    @IBOutlet var mobilePhoneOutlet: UIButton!
    @IBAction func mobilePhoneButton(_ sender: AnyObject) {
        let sender = sender
        let mobilePhoneText = mobilePhoneOutlet.titleLabel?.text
        if mobilePhoneText != nil || mobilePhoneText != "" {
            showShareOptions(sender)
        }
    }
    
    @IBOutlet var workEmailOutlet: UIButton!
    @IBAction func workEmailButton(_ sender: AnyObject) {
        let sender = sender
        let mailComposeViewController = configuredMailComposeViewController(sender)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    @IBOutlet var homeEmailOutlet: UIButton!
    @IBAction func homeEmailButton(_ sender: AnyObject) {
        let sender = sender
        let mailComposeViewController = configuredMailComposeViewController(sender)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    

    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var zipLabel: UILabel!
    
    //Option of action on phone Buttons - phone call or text message based on User's AlertController Selection
    func showShareOptions(_ sender: AnyObject) {
        let sender = sender
        let actionSheet = UIAlertController(title: "", message: "Call or Text", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let phoneCallAction = UIAlertAction(title: "Phone Call", style: UIAlertActionStyle.default) { (action) -> Void in
            switch sender.tag {
            case 1:
                if let workPhoneText = self.workPhoneOutlet.titleLabel?.text{
                    if let url = URL(string: "tel:\(workPhoneText)") {
                        let application = UIApplication.shared
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
                    if let url = URL(string: "tel:\(homePhoneText)") {
                        let application = UIApplication.shared
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
                    if let url = URL(string: "tel:\(mobilePhoneText)") {
                        let application = UIApplication.shared
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
        
        
        let messageAction = UIAlertAction(title: "Text Message", style: UIAlertActionStyle.default) { (action) -> Void in
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(phoneCallAction)
        actionSheet.addAction(messageAction)
        actionSheet.addAction(cancelAction)
        
        //If iPad treat alert differently
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = actionSheet.popoverPresentationController {
                popoverController.sourceView = sender as? UIView
                popoverController.sourceRect = sender.bounds
            }
            self.present(actionSheet, animated: true, completion: nil)
        } else {
            present(actionSheet, animated: true, completion: nil)
        }
        
        
    }
    
    //sending text message
    func sendMessage(_ phoneNumber: String) {
        let phoneNumber = phoneNumber
        let messageVC = MFMessageComposeViewController()
        
        messageVC.body = "Enter a message";
        messageVC.recipients = ["\(phoneNumber)"] //Optionally add some telephone numbers
        messageVC.messageComposeDelegate = self;
        
        self.present(messageVC, animated: true, completion: nil)
    }

    //compose view controller for text message
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
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
        controller.dismiss(animated: true, completion: nil)
    }
    
    //methods to compose emails on view
    func configuredMailComposeViewController(_ sender: AnyObject) -> MFMailComposeViewController {
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
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.alert)
        //(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        sendMailErrorAlert.addAction(cancelAction)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
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
                workPhoneOutlet.setTitle(detail.workPhone, for: UIControlState())
            }
            if let homePhoneOutlet = self.homePhoneOutlet {
                homePhoneOutlet.setTitle(detail.homePhone, for: UIControlState())
            }
            if let mobilePhoneOutlet = self.mobilePhoneOutlet {
                mobilePhoneOutlet.setTitle(detail.mobilePhone, for: UIControlState())
            }
            if let workEmailOutlet = self.workEmailOutlet {
                workEmailOutlet.setTitle(detail.workEmail, for: UIControlState())
            }
            if let homeEmailOutlet = self.homeEmailOutlet {
                homeEmailOutlet.setTitle(detail.homeEmail, for: UIControlState())
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
            
            var keywords = fullName.components(separatedBy: " ")
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
            activity.isEligibleForHandoff = false
            activity.isEligibleForSearch = true
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
            case .disabled:
                activity.isEligibleForSearch = false
            case .viewedRecords:
                activity.isEligibleForSearch = true
                activity.contentAttributeSet?.relatedUniqueIdentifier = nil
            case .allRecords:
                activity.isEligibleForSearch = true
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
        
        detailScrollView.backgroundColor = UIColor.gray
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        detailScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        detailScrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.configureView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editContact" {
            let object = detailItem
                let controller = segue.destination as! EditContactViewController
                controller.coreDataStack = coreDataStack
                controller.editItem = object
            }
    
    }


}





