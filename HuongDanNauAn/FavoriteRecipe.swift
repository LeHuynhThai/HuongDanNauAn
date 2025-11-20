import Foundation

class FavoriteRecipe {
    // Thuộc tính
    let favoriteId: Int64
    let userId: Int64
    let recipeId: Int64
    let createdAt: Date

    // Computed property tiện lợi để định dạng ngày tạo
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: createdAt)
    }

    // Hàm khởi tạo
    init(favoriteId: Int64 = 0,
         userId: Int64 = 0,
         recipeId: Int64 = 0,
         createdAt: Date = Date()) {
        self.favoriteId = favoriteId
        self.userId = userId
        self.recipeId = recipeId
        self.createdAt = createdAt
    }
}

