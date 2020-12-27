//
//  ImageSelectorController.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 5/27/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "SelectPhotoCell"
private let headerIdentifier = "SelectPhotoHeader"

class ImageSelectorController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let currentUser: User
    var images = [UIImage]()
    var assets = [PHAsset]()
    var selectedImage: UIImage?
    var header: ImageSelectorHeader?
    weak var delegate: UploadPostControllerDelegate?
    
    // MARK: - Lifecycle
    
    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.register(ProfileCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(ImageSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        collectionView?.backgroundColor = .white
        
        configureNavigationButtons()
        fetchPhotos()
    }
    
    // MARK: - Actions
    
    @objc func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        let controller = UploadPostController()
        controller.selectedImage = header?.photoImageView.image
        controller.currentUser = currentUser
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureNavigationButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
    }
    
    func assetFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        options.fetchLimit = 45
        
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        
        return options
    }
    
    func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetFetchOptions())
        DispatchQueue.global(qos: .background).async {
            
            allPhotos.enumerateObjects({ (asset, count, stop) in
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    guard let image = image else { return }
                    self.images.append(image)
                    self.assets.append(asset)
                    
                    if self.selectedImage == nil {
                        self.selectedImage = image
                    }
                    
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async { self.collectionView?.reloadData() }
                    }
                })
            })
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ImageSelectorController {
   override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ImageSelectorHeader
        
        self.header = header
        
        if let selectedImage = self.selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil, resultHandler: { (image, info) in
                    header.photoImageView.image = image
                })
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCell
        cell.photoImageView = images[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ImageSelectorController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImage = images[indexPath.row]
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UICollectionViewFlowLayout

extension ImageSelectorController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
