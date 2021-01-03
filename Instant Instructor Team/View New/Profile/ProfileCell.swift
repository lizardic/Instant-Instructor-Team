//
//  ProfileCell.swift
//  InstagramFirestoreTutorial
//
//  Created by Stephen Dowless on 6/26/20.
//  Copyright © 2020 Stephan Dowless. All rights reserved.
//

import UIKit

/** This class defines a single cell (image) on the profile page.
 */

class ProfileCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    var photoImageView: UIImage? {
        didSet { postImageView.image = photoImageView }
    }
    
    /** postImageView() defines a UIImageView, which is a static image that completely fills the cell.
     */
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    /** init() intializes the cell with the image from postImageView()
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        postImageView.sd_setImage(with: viewModel.imageUrl)
    }
}
