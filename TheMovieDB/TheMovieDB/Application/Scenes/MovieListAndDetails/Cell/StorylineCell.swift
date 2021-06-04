//
//  StorylineCell.swift
//  TheMovieDB
//
//  Created by DS on 17/05/21.
//

import UIKit

class StorylineCell: UITableViewCell {
    
    @IBOutlet weak var lblStoryLine: UILabel!
    
    var storyLine: String? {
        didSet {
            lblStoryLine.text = storyLine ?? ""
            lblStoryLine.setLineHeight(lineHeight: 5)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
