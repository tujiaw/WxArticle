//
//  CategoryViewController.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/28.
//  Copyright © 2015年 tujiaw. All rights reserved.
//

import UIKit
import Alamofire

class CategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        if Data.sharedManager.category.typeList.count == 0 {
            let request = CategoryRequest()
            Alamofire.request(.GET, request.url).responseJSON {
                response in
                if response.result.isSuccess {
                    if let value = response.result.value {
                        Data.sharedManager.category.setData(value)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.sharedManager.category.typeList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "CATEGORY_CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier("cellId")
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        if Data.sharedManager.category.typeList.count > indexPath.row {
            cell?.textLabel?.text = Data.sharedManager.category.typeList[indexPath.row].name
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("select index:\(indexPath.row)")
        if Data.sharedManager.category.typeList.count > indexPath.row {
            tabBarController?.selectedIndex = 0
            if let controllers = tabBarController?.viewControllers {
                for controller in controllers {
                    if let navController = controller as? UINavigationController {
                        for controller in navController.viewControllers {
                            if let viewController = controller as? ViewController {
                                let id = Data.sharedManager.category.typeList[indexPath.row].id
                                viewController.requestNewType(id)
                            }
                        }
                    }
                }
            }
        }
    }
}