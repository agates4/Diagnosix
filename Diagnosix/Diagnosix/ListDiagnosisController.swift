//
//  ListDiagnosisController.swift
//  Diagnosix
//
//  Created by Aron Gates on 10/22/16.
//  Copyright © 2016 Aron Gates. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListDiagnosisController: UIViewController {
    
    @IBOutlet weak var header: UIImageView!
    let mainColor = UIColor(red:0.26, green:0.52, blue:0.96, alpha:1.0)
    let secondaryColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.0)
    let darkColor = UIColor(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0, alpha: 1)
    let lightColor = UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1)
    @IBOutlet var tblJSON: UITableView!
    var arrRes = [[String:AnyObject]]() //Array of dictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //header.backgroundColor = mainColor
        self.view.backgroundColor = secondaryColor
        
        Alamofire.request("https://f5036f6d.ngrok.io/speech_get", method: .get).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let resData = swiftyJsonVar.arrayObject {
                    self.arrRes = resData as! [[String:AnyObject]]
                }
                if self.arrRes.count > 0 {
                    self.tblJSON.reloadData()
                }
            }
        }
    }
    
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "jsonCell")!
        var dict = arrRes[(indexPath as NSIndexPath).row]
        let textInt : Int = (dict["ID"] as? Int!)!
        cell.textLabel?.text = dict["Name"] as? String
        cell.detailTextLabel?.text = "\(textInt)"
        let rect = CGRect(origin: CGPoint(x: 200,y :12), size: CGSize(width: 160, height: 14))
        let label = UILabel(frame: rect)
        label.font.withSize(12)
        let dateStr : String = (dict["Date"] as? String)!
        
        label.text = dateStr
        label.tag = indexPath.row
        cell.contentView.addSubview(label)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRes.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedCell(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.tblJSON)
        if let indexPath = self.tblJSON.indexPathForRow(at: location)
        {
            if let cell = self.tblJSON.cellForRow(at: indexPath)
            {
                if(cell.detailTextLabel?.text != nil)
                {
                    let ID : Int = Int((cell.detailTextLabel?.text)!)!
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as! DiagnosisController
                    let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    controller.modalTransitionStyle = modalStyle
                    controller.sickID = ID
                    self.present(controller, animated: true, completion: nil)
                }
            }
        }
    }
}

