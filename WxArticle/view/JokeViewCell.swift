//
//  JokeViewCell.swift
//  WxArticle
//
//  Created by tutujiaw on 16/1/17.
//  Copyright © 2016年 tujiaw. All rights reserved.
//

import UIKit
import SnapKit

class JokeViewCell : UITableViewCell {
    
    static let ID = "JOKE_VIEW_CELL_ID"
    
    let titleLabel = UILabel()
    let ctLabel = UILabel()
    let contentLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(titleLabel)
        self.addSubview(ctLabel)
        self.addSubview(contentLabel)
        
        titleLabel.textColor = UIColor.redColor()
        titleLabel.snp_makeConstraints{(make)->Void in
            make.top.equalTo(self.snp_top).offset(0)
            make.height.equalTo(20)
            make.left.equalTo(self.snp_left).offset(5)
            make.right.equalTo(ctLabel.snp_left).offset(-5)
        }
        
        ctLabel.textColor = UIColor.blueColor()
        ctLabel.snp_makeConstraints{(make)->Void in
            make.top.equalTo(self.snp_top).offset(0)
            make.height.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp_right).offset(5)
            make.width.equalTo(0)
            make.right.equalTo(self.snp_right).offset(-5)
        }
        
        contentLabel.snp_makeConstraints{(make)->Void in
            make.top.equalTo(titleLabel.snp_bottom).offset(5)
            make.bottom.equalTo(self.snp_bottom).offset(-5)
            make.centerX.equalTo(self.snp_centerX)
            make.width.equalTo(self).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
