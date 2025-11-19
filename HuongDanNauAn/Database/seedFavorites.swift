import Foundation

extension DatabaseManager {
    func seedFavorites() {
        let favorites: [(userId: Int64, recipeId: Int64)] = [
            // User 1 thích món Việt và Nhật
            (1, 1),   // Phở Bò
            (1, 2),   // Bún Chả
            (1, 14),  // Sushi Cá Hồi
            (1, 15),  // Ramen
            
            // User 2 thích món Việt và Mỹ
            (2, 3),   // Gỏi Cuốn
            (2, 4),   // Cơm Tấm
            (2, 8),   // Beef Burger
            (2, 11),  // Caesar Salad
            
            // User 3 thích món Việt và Mỹ
            (3, 5),   // Bánh Xèo
            (3, 6),   // Bò Kho
            (3, 9),   // BBQ Ribs
            (3, 10),  // Mac and Cheese
            
            // User 4 thích món Việt, Mỹ và Nhật
            (4, 7),   // Canh Chua Cá
            (4, 8),   // Beef Burger
            (4, 16),  // Tempura Tôm
            (4, 20),  // Miso Soup
            
            // User 5 thích món Mỹ và Nhật
            (5, 9),   // BBQ Ribs
            (5, 10),  // Mac and Cheese
            (5, 15),  // Ramen
            (5, 19),  // Teriyaki Chicken
            
            // User 6 thích món Mỹ và Việt
            (6, 11),  // Caesar Salad
            (6, 12),  // Chicken Wings
            (6, 1),   // Phở Bò
            (6, 5),   // Bánh Xèo
            
            // User 7 thích món Mỹ, Nhật
            (7, 13),  // Apple Pie
            (7, 14),  // Sushi Cá Hồi
            (7, 17),  // Takoyaki
            
            // User 8 thích món Nhật và Việt
            (8, 15),  // Ramen
            (8, 16),  // Tempura Tôm
            (8, 2),   // Bún Chả
            (8, 6),   // Bò Kho
            
            // User 9 thích món Nhật và Mỹ
            (9, 17),  // Takoyaki
            (9, 19),  // Teriyaki Chicken
            (9, 9),   // BBQ Ribs
            (9, 12),  // Chicken Wings
            
            // User 10 thích món Nhật và Việt
            (10, 20), // Miso Soup
            (10, 14), // Sushi Cá Hồi
            (10, 1),  // Phở Bò
            (10, 3)   // Gỏi Cuốn
        ]
        
        print("===== Bắt đầu seed favorites =====")
        for favorite in favorites {
            let success = addFavoriteRecipe(
                userId: favorite.userId,
                recipeId: favorite.recipeId
            )
            if success {
                print("Đã thêm: User \(favorite.userId) -> Recipe \(favorite.recipeId)")
            } else {
                print("Không thêm được: User \(favorite.userId) -> Recipe \(favorite.recipeId)")
            }
        }
        print("===== Kết thúc seed favorites =====")
    }
}
