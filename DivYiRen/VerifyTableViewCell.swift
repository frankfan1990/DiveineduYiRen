//
//  VerifyTableViewCell.swift
//  DivYiRen
//
//  Created by frankfan on 16/5/4.
//  Copyright © 2016年 frankfan. All rights reserved.
//

import UIKit

//验证界面列表-cell
protocol VerifyTableViewButtonClickedDelegate {
    
    func buttonClicked(title:String,andIndexPath:NSIndexPath)
}

class VerifyTableViewCell: UITableViewCell {

    var delegate:VerifyTableViewButtonClickedDelegate?
    private var _tableView:UITableView?
    var tableViewRef:UITableView?{
        
        set{
            
            _tableView = newValue
        }
        get{
            
            return _tableView
        }
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let refuseButton = UIButton(type: .Custom)
        refuseButton.setTitle("拒绝", forState: .Normal)
        refuseButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        refuseButton.backgroundColor = UIColor.redColor()
        refuseButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        refuseButton.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(refuseButton)
        refuseButton.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.contentView.snp_top).offset(5)
            make.right.equalTo(self.contentView.snp_right).offset(-120)
            make.size.equalTo(CGSizeMake(100, 40))
        }
        
        /**********/
        
        let acceptButton = UIButton(type: .Custom)
        acceptButton.setTitle("接受", forState: .Normal)
        acceptButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        acceptButton.backgroundColor = UIColor.greenColor()
        acceptButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        acceptButton.addTarget(self, action: #selector(buttonClicked(_:)), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(acceptButton)
        acceptButton.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.contentView.snp_top).offset(5)
            make.right.equalTo(self.contentView.snp_right).offset(-5)
            make.size.equalTo(CGSizeMake(100, 40))
        }

        
        
    }
    
    
    //MARK: - 拒绝或接受的回调方法
    func buttonClicked(sender:UIButton){
    
        var title:String = ""
        if(sender.currentTitle! == "接受"){//接受
        
            title = "接受"
            
        }else{//拒绝
        
            title = "拒绝"
        }
        
        let tpoint = sender.convertPoint(CGPointZero, toView: self.tableViewRef)
        let indexPath = self.tableViewRef?.indexPathForRowAtPoint(tpoint)
        
        self.delegate?.buttonClicked(title, andIndexPath: indexPath!)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
