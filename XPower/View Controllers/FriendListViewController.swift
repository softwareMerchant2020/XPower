//
//  FriendListViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/17/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class FriendListViewController: XpowerViewController {
    let client = XpowerDataClient()
    var friendList:FriendList?
    var friendRequests:FriendRequests?
    var isShowingList:Bool = true
    var loadingView:UIView = UIView()
    var noDataView:UIView = UIView()

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var friendListTableView: UITableView!
    @IBAction func listRequestCtrl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0)
        {
            isShowingList = true
            friendListTableView.reloadData()
        }
        else
        {
            isShowingList = false
            friendListTableView.reloadData()
        }
    }
  
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Friends"
        backgroundImage = "IMG_0653.jpg"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRequestClicked(_:)))
        loadingView = Utilities.setLoadingBackgroundFor(viewController: self)
        noDataView = Utilities.noDataView(viewController: self, emptyMsg: "No freind list found")

        loadFriendList()
        loadFriendRequestList()
    }
    @objc func addRequestClicked(_ sender: Any) {
       let alert = UIAlertController(title: APP_NAME, message: "Send Request", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Username"
        }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let sendAction = UIAlertAction(title: "Send", style: .default) { [unowned alert] _ in
           let receiverName = alert.textFields![0]
        DispatchQueue.main.async {
            if receiverName.text != nil
            {
                self.sendNewRequestNotification(receiverName: receiverName.text!)
            }
        }
        self.client.addFriendRequest(receiverName: receiverName.text ?? "") { (result) in
            self.showAlertWithMessage(message: result)
        }
       }

        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    func sendNewRequestNotification(receiverName:String) {
        let sender = PushNotificationSender()
        sender.sendPushNotification(to: receiverName, title: String(format:"New Request from %@", Utilities.currentUserName()), body: "")
    }
    func showAlertWithMessage(message:String) {
        DispatchQueue.main.async {
            let alert = Utilities.getAlertControllerwith(title: APP_NAME, message: message)
            self.present(alert, animated: true, completion: {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_ ) in
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    func loadFriendList() {
        client.getFriendList(completionHandler: { (friendList) in
            self.friendList = friendList
            self.loadTableView()
        })
       
    }
    func loadFriendRequestList()  {
        client.getFriendRequestList(completionHandler: { (friendReqs) in
                   self.friendRequests = friendReqs
                   self.loadTableView()
               })
    }
    func loadTableView() {
        DispatchQueue.main.async
        {
            self.loadingView.removeFromSuperview()
            self.friendListTableView.delegate = self
            self.friendListTableView.dataSource = self
            self.friendListTableView.tableHeaderView = self.headerView
            self.friendListTableView.register(UINib(nibName: "FriendRequestCell", bundle: .main), forCellReuseIdentifier: "FriendRequestCell")
            self.friendListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "FriendListCell")
            self.friendListTableView.rowHeight = 70
            self.friendListTableView.reloadData()
        }
    }

}
extension FriendListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        
        if isShowingList {
            count = self.friendList?.results.count ?? 0
        }
        else
        {
               count = self.friendRequests?.results?.count ?? 0
        }
        if (count==0) {
            tableView.backgroundView = noDataView
            tableView.separatorStyle = .none
        }
        else
        {
            tableView.backgroundView = nil
            noDataView.removeFromSuperview()
            tableView.separatorStyle = .singleLine
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isShowingList {
           let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath)
            cell.textLabel?.text = friendList?.results[indexPath.row].username
            cell.accessoryType = .disclosureIndicator
            cell.isUserInteractionEnabled = true
            return cell
        }
        else
        {
           let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestCell
            cell.viewController = self
            cell.setCellData(friendRequest: (friendRequests?.results?[indexPath.row])!)
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = true
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let receiverName = friendList?.results[indexPath.row].username
        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.receiverName = receiverName
        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    
}
