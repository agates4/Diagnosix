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
    let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImtAbWdhdGVzLm1lIiwicm9sZSI6IlVzZXIiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiI4MTkiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ZlcnNpb24iOiIyMDAiLCJodHRwOi8vZXhhbXBsZS5vcmcvY2xhaW1zL2xpbWl0IjoiOTk5OTk5OTk5IiwiaHR0cDovL2V4YW1wbGUub3JnL2NsYWltcy9tZW1iZXJzaGlwIjoiUHJlbWl1bSIsImh0dHA6Ly9leGFtcGxlLm9yZy9jbGFpbXMvbGFuZ3VhZ2UiOiJlbi1nYiIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvZXhwaXJhdGlvbiI6IjIwOTktMTItMzEiLCJodHRwOi8vZXhhbXBsZS5vcmcvY2xhaW1zL21lbWJlcnNoaXBzdGFydCI6IjIwMTYtMTAtMjIiLCJpc3MiOiJodHRwczovL3NhbmRib3gtYXV0aHNlcnZpY2UucHJpYWlkLmNoIiwiYXVkIjoiaHR0cHM6Ly9oZWFsdGhzZXJ2aWNlLnByaWFpZC5jaCIsImV4cCI6MTQ3NzIzODUxNCwibmJmIjoxNDc3MjMxMzE0fQ.K1yxmdwbhoQRvSd4evoe2eVa-ubHstQLBthkcVPQ96U"
    
    @IBOutlet weak var nameName: UILabel!
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var descriptionBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphImage.isHidden = true
        youtube1.isHidden = true
        Alamofire.request("https://sandbox-healthservice.priaid.ch/issues/\(sickID!.description)/info?token=\(token)&language=en-gb&format=json").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                self.swiftyJsonVar = JSON(responseData.result.value!)
                self.nameName.text = self.swiftyJsonVar["Name"].description
                self.profName.text = self.swiftyJsonVar["ProfName"].description
                print(self.nameName.text)
                print(self.profName.text)
                self.descriptionBox.text = self.swiftyJsonVar["DescriptionShort"].description
                //self.descriptionBox.text = self.swiftyJsonVar["PossibleSymptoms"].description
                //self.descriptionBox.text = self.swiftyJsonVar["Description"].description
                //self.descriptionBox.text = self.swiftyJsonVar["TreatmentDescription"].description
                //self.descriptionBox.text = self.swiftyJsonVar["MedicalCondition"].description
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
