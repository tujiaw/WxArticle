//
//  KeySearchedViewController.swift
//  WxArticle
//
//  Created by tutujiaw on 15/11/29.
//  Copyright © 2015年 tujiaw. All rights reserved.
//


import UIKit

class KeySearchedViewController: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var x = ["111", "222", "333", "4444"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

extension KeySearchedViewController: UITableViewDelegate, UITableViewDataSource {
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return x.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "SEARCH_CELL_ID"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        cell?.textLabel?.text = x[indexPath.row]
        return cell!
    }
}

extension KeySearchedViewController: UISearchBarDelegate {
    internal func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.navigationItem.title = searchBar.text
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

