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
        recipeDifficulty.textColor = .systemBlue
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // Setup giao diện và styling cho cell
    private func setupCellAppearance() {
        // 1. Style cho hình ảnh
        RecipeImage.layer.cornerRadius = 12          // Bo góc tròn hơn
        RecipeImage.clipsToBounds = true
        RecipeImage.contentMode = .scaleAspectFill
        RecipeImage.layer.borderWidth = 0.5          // Thêm viền mỏng
        RecipeImage.layer.borderColor = UIColor.systemGray5.cgColor
        
        // 2. Style cho tên món (bold, đậm)
        RecipeName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        RecipeName.textColor = .label
        RecipeName.numberOfLines = 2                 // Cho phép 2 dòng nếu tên dài
        
        // 3. Style cho thời gian (nhỏ hơn, màu xám)
        RecipeTime.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        RecipeTime.textColor = .systemGray
        
        // 4. Style cho độ khó (badge với màu nổi bật)
        recipeDifficulty.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        recipeDifficulty.textColor = .white
        recipeDifficulty.layer.cornerRadius = 6
        recipeDifficulty.clipsToBounds = true
        recipeDifficulty.textAlignment = .center
        
        // 5. Style cho cell
        self.selectionStyle = .none                  // Tắt selection style mặc định
        self.backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12          // Bo góc cho cell
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08       // Shadow nhẹ
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        // 6. Thêm padding cho cell
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
    }
    
    // MARK: - Configure cell với dữ liệu Recipe
    func configure(with recipe: Recipe) {
        RecipeName.text = recipe.name
        RecipeTime.text = "⏱ \(recipe.cookTime ?? 0) phút"
        recipeDifficulty.text = recipe.difficulty.rawValue.uppercased()
        
        // Nếu recipe có ảnh local hoặc URL
        if let imageName = recipe.imageURL {
            RecipeImage.image = UIImage(named: imageName)
        } else {
            RecipeImage.image = UIImage(named: "pho_bo") // placeholder
        }
    }
}
