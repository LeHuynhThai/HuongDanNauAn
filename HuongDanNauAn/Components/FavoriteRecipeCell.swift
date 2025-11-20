//
//  FavoriteTableViewCell.swift
//  HuongDanNauAn
//
//  Created by admin on 19/11/2025.
//

import UIKit

// Protocol để gửi sự kiện xóa
protocol FavoriteRecipeCellDelegate: AnyObject {
    func didTapFavoriteButton(cell: FavoriteRecipeCell)
}

class FavoriteRecipeCell: UITableViewCell {

    @IBOutlet weak var RecipeName: UILabel!
    @IBOutlet weak var RecipeImage: UIImageView!
    @IBOutlet weak var RecipeTime: UILabel!
    @IBOutlet weak var RecipyDifficulty: UILabel!
    @IBOutlet weak var favoriteButton: UIImageView!
    
    weak var delegate: FavoriteRecipeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        RecipeName.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        RecipeTime.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        RecipeTime.textColor = .gray
        RecipyDifficulty.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        RecipyDifficulty.textColor = .systemBlue
        setupFavoriteButton()
    }
    
    // Setup UIImageView thành button
    private func setupFavoriteButton() {
        // Set hình trái tim đỏ
        favoriteButton.image = UIImage(systemName: "heart.fill")
        favoriteButton.tintColor = .systemRed
        favoriteButton.contentMode = .scaleAspectFit
        
        // Enable user interaction
        favoriteButton.isUserInteractionEnabled = true
        
        // Thêm tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoriteButtonTapped))
        favoriteButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func favoriteButtonTapped() {
        // Animation khi tap
        UIView.animate(withDuration: 0.2, animations: {
            self.favoriteButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.2) {
                self.favoriteButton.transform = .identity
            }
        }
        
        // Gửi sự kiện về ViewController
        delegate?.didTapFavoriteButton(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

