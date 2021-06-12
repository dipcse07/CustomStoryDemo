//
//  StoryCollectionnViewCell.swift
//  CustomStory
//
//  Created by MD SAZID HASAN DIP on 11/6/21.

import UIKit

class StoryCollectionnViewCell: UICollectionViewCell {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var storyImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width/2
        avatarImageView.layer.borderColor = UIColor.systemBlue.cgColor
        avatarImageView.layer.borderWidth = 3
        
        storyImageView.layer.cornerRadius = 8
    }

}
