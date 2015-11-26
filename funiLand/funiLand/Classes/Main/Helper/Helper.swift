//
//  Helper.swift
//  Pre-ownedHouse
//
//  Created by Allen on 15/11/4.
//  Copyright © 2015年 Allen. All rights reserved.
//

import Foundation

class Helper {
    static let sharedInstance = Helper()
    
    private init() {}
    
    static func getViewControllerFromStoryboard(storyboardName: String, storyboardID: String) -> UIViewController? {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(storyboardID)
        return viewController
    }
    
    static func setExtraCellLineHidden(tableView:UITableView){
        let view = UIView();
        view.backgroundColor = UIColor.clearColor();
        tableView.tableFooterView = view;
    }
    
}