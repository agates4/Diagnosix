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
    var sickID : Int!
    var swiftyJsonVar : JSON!
    let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImtAbWdhdGVzLm1lIiwicm9sZSI6IlVzZXIiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9zaWQiOiI4MTkiLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3ZlcnNpb24iOiIyMDAiLCJodHRwOi8vZXhhbXBsZS5vcmcvY2xhaW1zL2xpbWl0IjoiOTk5OTk5OTk5IiwiaHR0cDovL2V4YW1wbGUub3JnL2NsYWltcy9tZW1iZXJzaGlwIjoiUHJlbWl1bSIsImh0dHA6Ly9leGFtcGxlLm9yZy9jbGFpbXMvbGFuZ3VhZ2UiOiJlbi1nYiIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvZXhwaXJhdGlvbiI6IjIwOTktMTItMzEiLCJodHRwOi8vZXhhbXBsZS5vcmcvY2xhaW1zL21lbWJlcnNoaXBzdGFydCI6IjIwMTYtMTAtMjIiLCJpc3MiOiJodHRwczovL3NhbmRib3gtYXV0aHNlcnZpY2UucHJpYWlkLmNoIiwiYXVkIjoiaHR0cHM6Ly9oZWFsdGhzZXJ2aWNlLnByaWFpZC5jaCIsImV4cCI6MTQ3NzIxMjEwMSwibmJmIjoxNDc3MjA0OTAxfQ.XZuo9C5uvauGYCK9qOB2iVScW578yhu93yH9rIj8waw"
    
    @IBOutlet weak var nameName: UILabel!
    @IBOutlet weak var profName: UILabel!
    @IBOutlet weak var descriptionBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://sandbox-healthservice.priaid.ch/issues/\(sickID!.description)/info?token=\(token)&language=en-gb&format=json").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                self.swiftyJsonVar = JSON(responseData.result.value!)
                self.nameName.text = self.swiftyJsonVar["Name"].description
                self.profName.text = self.swiftyJsonVar["ProfName"].description
                self.descriptionBox.text = self.swiftyJsonVar["DescriptionShort"].description
                //self.descriptionBox.text = self.swiftyJsonVar["PossibleSymptoms"].description
                //self.descriptionBox.text = self.swiftyJsonVar["Description"].description
                //self.descriptionBox.text = self.swiftyJsonVar["TreatmentDescription"].description
                //self.descriptionBox.text = self.swiftyJsonVar["MedicalCondition"].description
            }
        }
    }
    
    @IBAction func changeTab(sender: UIButton)
    {
        let senderLabel = sender.accessibilityLabel as String!
        if (senderLabel == "TLDR")
        {
            self.descriptionBox.text = self.swiftyJsonVar["DescriptionShort"].description
        }
        else if (senderLabel == "Symptoms")
        {
            self.descriptionBox.text = self.swiftyJsonVar["PossibleSymptoms"].description
        }
        else if (senderLabel == "Description")
        {
            self.descriptionBox.text = self.swiftyJsonVar["Description"].description
        }
        else if (senderLabel == "Treatment")
        {
            self.descriptionBox.text = self.swiftyJsonVar["TreatmentDescription"].description
        }
        else if (senderLabel == "MedicalConditions")
        {
            self.descriptionBox.text = self.swiftyJsonVar["MedicalCondition"].description
        }
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
