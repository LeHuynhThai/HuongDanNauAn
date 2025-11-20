//
//  RecipeCell.swift
//  HuongDanNauAn
//
//  Created by admin on 11/11/2025.
//

import UIKit

class RecipeCell: UICollectionViewCell {
    
    @IBOutlet weak var RecipeImageView: UIImageView!
    @IBOutlet weak var RecipeName: UILabel!
    @IBOutlet weak var RecipeTime: UILabel!
    @IBOutlet weak var RecipeDifficulty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellAppearance()
    }
    
    // Setup giao diện và styling cho cell
    private func setupCellAppearance() {
        // 1. Bo góc và shadow cho cell
        self.layer.cornerRadius = 12
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 6
        self.backgroundColor = .white
        
        // 2. Bo góc cho hình ảnh
        RecipeImageView.layer.cornerRadius = 8
        RecipeImageView.clipsToBounds = true
        RecipeImageView.contentMode = .scaleAspectFill
        
        // 3. Style cho tên món (bold, đậm hơn)
        RecipeName.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        RecipeName.textColor = .label
        RecipeName.numberOfLines = 2
        
        // 4. Style cho thời gian (nhỏ hơn, màu xám)
        RecipeTime.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        RecipeTime.textColor = .systemGray
        
        // 5. Style cho độ khó (badge nhỏ, màu nổi bật)
        RecipeDifficulty.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        RecipeDifficulty.textColor = .white
        RecipeDifficulty.layer.cornerRadius = 4
        RecipeDifficulty.clipsToBounds = true
        RecipeDifficulty.textAlignment = .center
    }
    
    // Gán dữ liệu recipe vào cell và set màu badge theo độ khó
    func configure(with recipe: Recipe) {
        
        // Gán tên món và thời gian nấu
        RecipeName.text = recipe.name
        RecipeTime.text = "\(recipe.cookTime ?? 0) phút"
        
        // Set màu badge theo độ khó
        switch recipe.difficulty {
        case .easy:
            RecipeDifficulty.text = "DỄ"
            RecipeDifficulty.backgroundColor = .systemGreen
        case .medium:
            RecipeDifficulty.text = "TB"
            RecipeDifficulty.backgroundColor = .systemOrange
        case .hard:
            RecipeDifficulty.text = "KHÓ"
            RecipeDifficulty.backgroundColor = .systemRed
        }
        
        // Load hình ảnh
        if let imageURL = recipe.imageURL {
            RecipeImageView.image = UIImage(named: imageURL)
        } else {
            RecipeImageView.image = UIImage(named: "chef")
        }
    }
}
