//
//  DetailMessageTableViewCell.swift
//  DivYiRen
//
//  Created by frankfan on 16/3/27.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit


class DetailMessageTableViewCell: UITableViewCell {

    let contentLabel = UILabel()
    let v = UIView()
    
    private var  _isLeftMode:Bool = false
    
    var isLeftMode:Bool{
    
        set{
            
            _isLeftMode = newValue
            if(_isLeftMode == true){
                
                contentLabel.snp_remakeConstraints(closure: { (make) in
                    
                    make.top.equalTo(self.contentView.snp_top).offset(20)
                    make.left.equalTo(self.contentView.snp_left).offset(20)
                    make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
                    make.right.greaterThanOrEqualTo(self.contentView.snp_left).offset(30)
                    make.right.lessThanOrEqualTo(self.contentView.snp_right).offset(-150)
                    

                })
                
                
                v.snp_remakeConstraints(closure: { (make) in
                    
                    make.top.equalTo(self.contentView.snp_top).offset(10)
                    make.left.equalTo(self.contentView.snp_left).offset(10)
                    make.bottom.equalTo(self.contentView.snp_bottom).offset(-10)
                    make.right.equalTo(contentLabel.snp_right).offset(10)

                })
                v.backgroundColor = UIColor.grayColor()
                
            }else{
            
                contentLabel.snp_remakeConstraints { (make) in
                    
                    make.top.equalTo(self.contentView.snp_top).offset(20)
                    make.right.equalTo(self.contentView.snp_right).offset(-20)
                    make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
                    make.left.greaterThanOrEqualTo(self.contentView.snp_left).offset(150)
                    make.left.lessThanOrEqualTo(self.contentView.snp_right).offset(-30)
                    
                    
                    
                }
                
                v.snp_remakeConstraints { (make) in
                    
                    make.top.equalTo(self.contentView.snp_top).offset(10)
                    make.right.equalTo(self.contentView.snp_right).offset(-10)
                    make.bottom.equalTo(self.contentView.snp_bottom).offset(-10)
                    make.left.equalTo(contentLabel.snp_left).offset(-10)
                }

                v.backgroundColor = UIColor.blueColor()
            }
            
            
        }
        
        get{
            
            return _isLeftMode
        }
        
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        
        
        contentLabel.backgroundColor = UIColor.clearColor()
        contentLabel.lineBreakMode = .ByWordWrapping
        contentLabel.font = UIFont.systemFontOfSize(14)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.whiteColor()
        
        
        v.backgroundColor = UIColor.blueColor()
        v.layer.cornerRadius = 15
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(v)
        self.contentView.addSubview(contentLabel)
        self.isLeftMode = false
        
        contentLabel.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.contentView.snp_top).offset(20)
            make.right.equalTo(self.contentView.snp_right).offset(-20)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-20)
            make.left.greaterThanOrEqualTo(self.contentView.snp_left).offset(150)
            make.left.lessThanOrEqualTo(self.contentView.snp_right).offset(-30)
            
            
            
        }
        
        v.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.contentView.snp_top).offset(10)
            make.right.equalTo(self.contentView.snp_right).offset(-10)
                make.bottom.equalTo(self.contentView.snp_bottom).offset(-10)
            make.left.equalTo(contentLabel.snp_left).offset(-10)
        }
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
