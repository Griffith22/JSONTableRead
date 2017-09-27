//
//  ViewController.swift
//  JSONDemo
//
//  Created by TheAppGuruz-New-6 on 31/07/14.
//  Copyright (c) 2014 TheAppGuruz-New-6. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate
{
    let yourJsonFormat: String = "JSONFile" // set text JSONFile : json data from file
                                            // set text JSONUrl : json data from web url
    
    var arrDict :NSMutableArray=[]
    
    @IBOutlet weak var tvJSON: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if yourJsonFormat == "JSONFile" {
            jsonParsingFromFile()
        } else {
            jsonParsingFromURL()
        }
    }
    
    func jsonParsingFromURL () {
        let url = URL(string: "http://theappguruz.in//Apps/iOS/Temp/json.php")
        let request = URLRequest(url: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) {(response, data, error) in
            self.startParsing(data!)
        }
    }
    
    func jsonParsingFromFile()
    {
        let path: NSString = Bundle.main.path(forResource: "days", ofType: "json")! as NSString
        let data : Data = try! Data(contentsOf: URL(fileURLWithPath: path as String), options: NSData.ReadingOptions.dataReadingMapped)
        
        self.startParsing(data)
    }
    
    func startParsing(_ data :Data)
    {
        let dict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        
        for i in 0  ..< (dict.value(forKey: "someArray") as! NSArray).count
        {
            arrDict.add((dict.value(forKey: "someArray") as! NSArray) .object(at: i))
        }
//        for i in 0  ..< (dict.value(forKey: "avengers2") as! NSArray).count
//        {
//            arrDict.add((dict.value(forKey: "avengers2") as! NSArray) .object(at: i))
//        }
//        for i in 0  ..< (dict.value(forKey: "avengers3") as! NSArray).count
//        {
//            arrDict.add((dict.value(forKey: "avengers3") as! NSArray) .object(at: i))
//        }
        tvJSON .reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return arrDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : TableViewCell! = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let strEventName : NSString=(arrDict[indexPath.row] as AnyObject).value(forKey: "EventName") as! NSString
        let strDateTime : NSString=(arrDict[indexPath.row] as AnyObject).value(forKey: "DateTime") as! NSString
        let strDescription : NSString=(arrDict[indexPath.row] as AnyObject).value(forKey: "Description") as! NSString
        let strLinks : NSString=(arrDict[indexPath.row] as AnyObject).value(forKey: "links") as! NSString
        let strLatitude : NSString=(arrDict[indexPath.row] as AnyObject).value(forKey: "latitude") as! NSString
        let strLongitude : NSString=(arrDict[indexPath.row] as AnyObject).value(forKey: "longitude") as! NSString
        
        cell.lblTitle.text=strEventName as String
        cell.lbDetails.text="Description: " + "\n" + (strDescription as String) + "Date and Time: " + (strDateTime as String) + "\n" + "links: " + (strLinks as String) + "\n" + "Latitude: " + (strLatitude as String) + "\n" + "Longitude: " + (strLongitude as String)
        return cell as TableViewCell
    }
}
