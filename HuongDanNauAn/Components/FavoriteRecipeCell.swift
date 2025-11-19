//
//  FavoriteTableViewCell.swift
//  HuongDanNauAn
//
//  Created by admin on 19/11/2025.
//

import UIKit

class FavoriteRecipeCell: UITableViewCell {

    @IBOutlet weak var RecipeName: UILabel!
    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var RecipeTime: UILabel!
    @IBOutlet weak var RecipyDifficulty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        RecipeName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        RecipeTime.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        RecipeTime.textColor = .gray
        RecipyDifficulty.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        RecipyDifficulty.textColor = .systemBlue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

