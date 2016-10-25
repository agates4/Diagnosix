//
//  DiagnosisController.swift
//  Diagnosix
//
//  Created by Aron Gates on 10/22/16.
//  Copyright © 2016 Aron Gates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DiagnosisController: UIViewController {
    @IBOutlet weak var statisticsButton: UIButton!
    @IBOutlet weak var bug: UIImageView!
    var sickID : Int!
    var swiftyJsonVar : JSON!
    @IBOutlet weak var titleLabel: UILabel!
    var token = "token"
    
    @IBOutlet weak var nameName: UILabel!
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var descriptionBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headers: HTTPHeaders = [
            "Authorization": "Bearer agates10@kent.edu:4Gy54wodlr8+r0HksBaxmg==",
        ]
        Alamofire.request("https://sandbox-authservice.priaid.ch/login", method: .post, headers: headers).responseJSON {
            response in
            if(response.result.value != nil)
            {
                let tokenResult = JSON(response.result.value!)
                self.token =  tokenResult["Token"].description
                Alamofire.request("https://sandbox-healthservice.priaid.ch/issues/\(self.sickID!.description)/info?token=\(self.token)&language=en-gb&format=json").responseJSON { (responseData) -> Void in
                    if((responseData.result.value) != nil) {
                        self.swiftyJsonVar = JSON(responseData.result.value!)
                        self.titleLabel.text = "Summary"
                        self.nameName.text = self.swiftyJsonVar["Name"].description
                        self.profName.text = self.swiftyJsonVar["ProfName"].description
                        self.descriptionBox.text = self.swiftyJsonVar["DescriptionShort"].description
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var button0: UIButton!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBAction func changeTab(sender: UIButton)
    {
        let senderLabel = sender.accessibilityLabel as String!
        if (senderLabel == "TLDR")
        {
            self.descriptionBox.text = self.swiftyJsonVar["DescriptionShort"].description
            self.titleLabel.text = "Summary"
        }
        else if (senderLabel == "Symptoms")
        {
            self.descriptionBox.text = self.swiftyJsonVar["PossibleSymptoms"].description
            self.titleLabel.text = "Symptoms"
        }
        else if (senderLabel == "Description")
        {
            self.descriptionBox.text = self.swiftyJsonVar["Description"].description
            self.titleLabel.text = "Description"
        }
        else if (senderLabel == "Treatment")
        {
            self.descriptionBox.text = self.swiftyJsonVar["TreatmentDescription"].description
            self.titleLabel.text = "Treatment"
        }
        else if (senderLabel == "MedicalConditions")
        {
            self.descriptionBox.text = self.swiftyJsonVar["MedicalCondition"].description
            self.titleLabel.text = "Conditions"
        }
    }
    
    var track : Bool = false
    @IBOutlet weak var graphImage: UIImageView!
    @IBOutlet weak var youtube1: UIWebView!
    var trackInt : Int = 0
    @IBAction func goToStats(sender: UIButton)
    {
        track = !track
        if(trackInt == 0)
        {
            let myURL3 : NSURL = NSURL(string: "https://www.youtube.com/embed/CIvA71cQJmQ")!
            let myURLRequest3 : NSURLRequest = NSURLRequest(url: myURL3 as URL)
            self.youtube1.loadRequest(myURLRequest3 as URLRequest)
            trackInt += 1
        }
        if(!track)
        {
            let bugImage : UIImage = UIImage(named : "bacteria.png")!
            bug.image = bugImage
            let buttonImage : UIImage = UIImage(named : "graphButton.png")!
            sender.setImage(buttonImage, for: .normal)
            button0.isHidden = false
            button1.isHidden = false
            button2.isHidden = false
            button3.isHidden = false
            button4.isHidden = false
            descriptionBox.isHidden = false
            titleLabel.isHidden = false
            nameName.frame.origin.x = 33
            profName.frame.origin.x = 97
            graphImage.isHidden = true
            youtube1.isHidden = true
        }
        else
        {
            let bugImage : UIImage = UIImage(named : "virus.png")!
            bug.image = bugImage
            let buttonImage : UIImage = UIImage(named : "bookbutton.png")!
            sender.setImage(buttonImage, for: .normal)
            button0.isHidden = true
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            button4.isHidden = true
            descriptionBox.isHidden = true
            titleLabel.isHidden = true
            nameName.frame.origin.x = -12
            profName.frame.origin.x = 52
            graphImage.isHidden = false
            youtube1.isHidden = false
        }
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
