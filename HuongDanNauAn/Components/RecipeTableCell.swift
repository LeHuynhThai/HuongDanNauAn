//
//  RecipeTableCell.swift
//  HuongDanNauAn
//
//  Created by admin on 19/11/2025.
//

import UIKit

class RecipeTableCell: UITableViewCell {
    
    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var RecipeName: UILabel!
    @IBOutlet weak var RecipeTime: UILabel!
    @IBOutlet weak var recipeDifficulty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        RecipeImage.layer.cornerRadius = 8
        RecipeImage.clipsToBounds = true
        RecipeImage.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    // MARK: - Configure cell với dữ liệu Recipe
    func configure(with recipe: Recipe) {
        RecipeName.text = recipe.name
        RecipeTime.text = "\(recipe.cookTime ?? 0) phút"
        recipeDifficulty.text = recipe.difficulty.rawValue
        
        // Nếu recipe có ảnh local hoặc URL
        if let imageName = recipe.imageURL {
            RecipeImage.image = UIImage(named: imageName)
        } else {
            RecipeImage.image = UIImage(systemName: "pho_bo") // placeholder
        }
    }
}
