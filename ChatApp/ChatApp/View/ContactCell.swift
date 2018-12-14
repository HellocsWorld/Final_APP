//
//  ContactCell.swift
//  ChatApp
//
//  Created by Raul Serrano on 12/9/18.
//  Copyright © 2018 Raul Serrano. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {
    
    
    @IBOutlet weak var ContactName: UILabel!
    @IBOutlet weak var contactBackgroundView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contactImageView.layer.cornerRadius = self.contactImageView.frame.size.width/2
        self.contactImageView.clipsToBounds = true
        // Initialization code goes here
        
        
        
     }
    
}
