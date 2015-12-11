//
//  DetailViewController.swift
//  discreetBook
//
//  Created by Jena Grafton on 11/20/15.
//  Copyright © 2015 Bella Voce Productions. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    var coreDataStack: CoreDataStack!
    var editViewController: EditContactViewController?
    
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!

    @IBOutlet var workPhoneOutlet: UIButton!
    @IBAction func workPhoneButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(workPhoneOutlet.titleLabel!.text)")!)
    }
    
    @IBOutlet var homePhoneOutlet: UIButton!
    @IBAction func homePhoneButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(homePhoneOutlet.titleLabel!.text)")!)
    }
    
    @IBOutlet var mobilePhoneOutlet: UIButton!
    @IBAction func mobilePhoneButton(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(mobilePhoneOutlet.titleLabel!.text)")!)
    }
    
    @IBOutlet var workEmailLabel: UILabel!
    @IBOutlet var homeEmailLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var zipLabel: UILabel!
    
    


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
            if let workEmailLabel = self.workEmailLabel {
                workEmailLabel.text = detail.workEmail
            }
            if let homeEmailLabel = self.homeEmailLabel {
                homeEmailLabel.text = detail.homeEmail
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

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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





