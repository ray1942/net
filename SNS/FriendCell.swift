//
//  FriendCell.swift
//  SNS
//
//  Created by 千锋 on 16/9/18.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var groupLabel: UILabel!
    
    func configModel(model:Friend){
        
        let str = String(format: "http://10.0.8.8/sns/my/headimage.php?uid=%@", model.uid!)
        userImageView.kf_setImageWithURL(NSURL(string: str)!)
//        userImageView.layer.cornerRadius = 25
//        userImageView.clipsToBounds = true
        nameLabel.text = model.username
        groupLabel.text = model.group
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
