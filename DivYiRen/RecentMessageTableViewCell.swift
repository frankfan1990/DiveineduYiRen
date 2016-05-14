//
//  RecentMessageTableViewCell.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/27.
//  Copyright © 2016年 frankfan. All rights reserved.
//

//MARK: 最近聊天记录列表-cell
import UIKit

class RecentMessageTableViewCell: UITableViewCell {

    
    var senderLabel:UILabel
    var contentLabel:UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    
        senderLabel = UILabel()
        senderLabel.font = UIFont.boldSystemFontOfSize(14)
        senderLabel.textColor = UIColor.blackColor()
        senderLabel.adjustsFontSizeToFitWidth = true

        
        contentLabel = UILabel()
        contentLabel.font = UIFont.systemFontOfSize(14)
        contentLabel.textColor = UIColor.grayColor()
        contentLabel.lineBreakMode = .ByWordWrapping
        contentLabel.backgroundColor = UIColor.blueColor()
    
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
        self.contentView.addSubview(senderLabel)
        senderLabel.snp_makeConstraints { (make) in
            
            make.left.equalTo(20)
            make.height.equalTo(20)
            make.top.equalTo(5)
        }
        
        self.contentView.addSubview(contentLabel)
        contentLabel.snp_makeConstraints { (make) in
            
            make.left.equalTo(senderLabel.snp_left)
            make.top.equalTo(senderLabel.snp_bottom).offset(5)
            make.bottom.equalTo(self.snp_bottom).offset(-10)

            make.right.greaterThanOrEqualTo(self.contentView.snp_left).offset(100)
            make.right.lessThanOrEqualTo(self.contentView.snp_right).offset(-50)
        }
        contentLabel.layer.cornerRadius = 10
        contentLabel.layer.masksToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
