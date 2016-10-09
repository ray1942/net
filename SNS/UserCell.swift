//
//  UserCell.swift
//  SNS
//
//  Created by 千锋 on 16/9/19.
//  Copyright © 2016年 Ray. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var friendLabel: UILabel!
    
    func configModel(model:User){
        let imageUrl = "http://10.0.8.8/sns/"+model.headimage!
        let url = NSURL(string: imageUrl)
        userImageView.kf_setImageWithURL(url!)
        nameLabel.text = model.username
        friendLabel.text = "共有\(model.friendnum)个好友"
        
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
