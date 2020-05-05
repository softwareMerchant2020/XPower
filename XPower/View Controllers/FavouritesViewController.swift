//
//  FavouritesViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/13/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
//struct Tasks {
//    let taskName:String
//    
//}
class FavouritesViewController: UIViewController {
 var client:XpowerDataClient?
    @IBOutlet weak var favouriteDeedsTableview: UITableView!
    var favTaskList:TaskList?
    var noDataView:UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        noDataView = Utilities.noDataView(viewController: self, emptyMsg: "No FavouriteDeeds")
    }
    func loadData() {
        client = XpowerDataClient()
                      client?.getFavouriteDeeds(completionHandler: { (taskList) in
                          self.favTaskList = taskList
                          self.loadTableView()
                      })
    }
    
    func loadTableView() {
        DispatchQueue.main.async
        {
            self.favouriteDeedsTableview.delegate = self
            self.favouriteDeedsTableview.dataSource = self
            self.favouriteDeedsTableview.register(UINib(nibName: "PointsTableViewCell", bundle: .main), forCellReuseIdentifier: "PointsTableViewCell")
            self.favouriteDeedsTableview.rowHeight = 80
            self.favouriteDeedsTableview.reloadData()
        }
    }
}

extension FavouritesViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       let cnt = favTaskList?.tasksList?.count ?? 0
        if cnt==0
        {
            tableView.backgroundView = noDataView
            tableView.separatorStyle = .none
        }
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableViewCell", for: indexPath) as! PointsTableViewCell
        
        cell.setFavouriteTask(task: (favTaskList?.tasksList?[indexPath.row])!)
        return cell
    }
    
    
}
