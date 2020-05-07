//
//  HomeViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/8/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class HomeViewController: XpowerViewController {
    let client:XpowerDataClient = XpowerDataClient()
    var progresspoints:ProgressPoints?
    @IBOutlet weak var homeCollectionView: UICollectionView!
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets =  UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)

    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var dailyPointsLabel: UILabel!
    var loadingView:UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.backgroundImage = "IMG_0268.jpg"
        loadData()
        
    }
    func loadData() {
       loadingView = Utilities.setLoadingBackgroundFor(viewController: self)
        client.getUserProgress { (points) in
            self.progresspoints = points
            self.loadCollectionView()
        }
        client.getUserDailyPoints { (dailyPts) in
            DispatchQueue.main.async {
            self.dailyPointsLabel.text = String(format: "Daily Points :%d", dailyPts)
            }
        }
        client.getTotalSchoolPoints { (schoolPts) in
            DispatchQueue.main.async {
                self.totalPointsLabel.text = String(format: "Total School Points: %d", schoolPts)
            }
        }
    }
    func loadCollectionView() {
        DispatchQueue.main.async {
            self.homeCollectionView.delegate = self
            self.homeCollectionView.dataSource = self
            self.homeCollectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "HomeViewCell")
            self.loadingView.removeFromSuperview()
        }
        
    }
}
extension HomeViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
          .dequeueReusableCell(withReuseIdentifier: "HomeViewCell", for: indexPath) as! HomeCollectionViewCell
        cell.setCellData(monthPoint: (progresspoints?.allMonths?[indexPath.row])!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      //2
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = homeCollectionView.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      return CGSize(width: widthPerItem, height: widthPerItem+15)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}