//
//  IGHomeViewController.swift
//  ImageGallery
//
//  Created by RITIKA VERMA on 03/02/20.
//  Copyright © 2020 RITIKA VERMA. All rights reserved.
//

import UIKit
import SDWebImage
import ReachabilitySwift
import Haneke


class IGHomeViewController: UIViewController, IGImageViewModelProtocol {
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    fileprivate let model = IGImageViewModel()
    var currentPage = 1
    var activityIndicatorView: UIActivityIndicatorView!
    var networkgone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        setupNibs()
        self.title = "Home"
        let layout = imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(refreshView), name: Notification.Name("network_available"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAlert), name: Notification.Name("network_not_available"), object: nil)
    }
    
    
    @objc func refreshView() {
        let alert = UIAlertController(title: "You are online", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { (_) in
            self.model.imageSet.removeAll()
            self.currentPage = 1
            self.model.currentPage = self.currentPage
            Shared.dataCache.removeAll()
            self.model.loadImages(pageNo: self.currentPage)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func showAlert() {
        let alert = UIAlertController(title: IGConstants.ErrorStrings.noInternetConnection, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if currentPage == 1 {
            activityIndicatorView = UIActivityIndicatorView(style: .large)
            imageCollectionView.backgroundView = activityIndicatorView
            if IGApiService.isReachable() {
                activityIndicatorView.startAnimating()
            }
        }
        model.loadImages(pageNo: currentPage)
    }
    
    func setupNibs() {
        let imageCell = UINib(nibName: IGConstants.Nibs.IGImageCollectionViewCell, bundle: nil)
        imageCollectionView.register(imageCell, forCellWithReuseIdentifier: IGConstants.Nibs.IGImageCollectionViewCell)
        let loaderCell = UINib(nibName: IGConstants.Nibs.IGLoadingSpinnerCollectionViewCell, bundle: nil)
        imageCollectionView.register(loaderCell, forCellWithReuseIdentifier: IGConstants.Nibs.IGLoadingSpinnerCollectionViewCell)
        let headerCell = UINib(nibName: "IGImageHeaderCollectionViewCell", bundle: nil)
        imageCollectionView.register(headerCell, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "IGImageHeaderCollectionViewCell")
    }
    
    //MARK:- View Modal Protocol
    
    func didUpdateImages() {
        activityIndicatorView.stopAnimating()
        imageCollectionView.reloadData()
    }
    
    func didSendError(error: String) {
        let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension IGHomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.imageSet.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == (model.imageSet.count) {
            return 1
        }
        else {
            return model.imageSet[section].images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == (model.imageSet.count) {
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: IGConstants.Nibs.IGLoadingSpinnerCollectionViewCell, for: indexPath) as! IGLoadingSpinnerCollectionViewCell
            if model.startLoading {
                cell.activitySpinner.startAnimating()
            }
            else {
                cell.activitySpinner.stopAnimating()
            }
            return cell
        }
        else {
            let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: IGConstants.Nibs.IGImageCollectionViewCell, for: indexPath) as! IGImageCollectionViewCell
            cell.imagecell.sd_setImage(with: URL(string: model.imageSet[indexPath.section].images[indexPath.row].url_s), placeholderImage: UIImage(named: "placeholder"))
            if indexPath.section == (model.imageSet.count - 1) {
                if indexPath.row == (model.imageSet[indexPath.section].images.count - 1) {
                    currentPage = currentPage + 1
                    model.loadImages(pageNo: currentPage)
                }
            }
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == (model.imageSet.count) {
            return UICollectionReusableView()
        }
        else {
            if kind == UICollectionView.elementKindSectionHeader {
                let headerView = imageCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "IGImageHeaderCollectionViewCell", for: indexPath) as! IGImageHeaderCollectionViewCell
                headerView.headerLabel.text = "Page " + String(model.imageSet[indexPath.section].pageNo)
                return headerView
            }
            else {
                return UICollectionReusableView()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == (model.imageSet.count) {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 45)
    }
}


extension IGHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == (model.imageSet.count) {
            let width = collectionView.bounds.width
            return CGSize(width: width, height: 75)
        }
        else {
            let width = collectionView.bounds.width/2.0
            return CGSize(width: width - 15, height: width - 15)
        }
    }
}
