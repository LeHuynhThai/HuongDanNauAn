import Foundation
import SQLite

// Extension mở rộng cho DatabaseManager
extension DatabaseManager {

    // MARK: - Add Favorite
    func addFavoriteRecipe(userId: Int64, recipeId: Int64) -> Bool {
        do {
            // ✅ SỬA LỖI 1: Lấy ngày hiện tại dạng STRING (thay vì Date)
            let dateString = getCurrentDateString()
            
            let insert = favoriteRecipes.insert(
                self.favoriteUserId <- userId,
                self.favoriteRecipeId <- recipeId,
                self.favoriteCreatedAt <- dateString // <-- Truyền String vào đây
            )
            try db?.run(insert)
            return true
        } catch {
            print("❌ Lỗi thêm favorite recipe: \(error)")
            return false
        }
    }

    // MARK: - Get Favorites by User
    func getFavoritesByUser(_ userId: Int64) -> [FavoriteRecipe] {
        var list: [FavoriteRecipe] = []
        do {
            for row in try db!.prepare(favoriteRecipes.filter(self.favoriteUserId == userId)) {
                
                // ✅ SỬA LỖI 2: Chuyển đổi từ String (DB) sang Date (Model)
                let dateValue = parseDate(dateString: row[favoriteCreatedAt])
                
                let favorite = FavoriteRecipe(
                    favoriteId: row[favoriteId],
                    userId: row[favoriteUserId],
                    recipeId: row[favoriteRecipeId],
                    createdAt: dateValue // <-- Gán Date đã convert vào đây
                )
                list.append(favorite)
            }
        } catch {
            print("❌ Lỗi lấy favorite recipes: \(error)")
        }
        return list
    }

    // MARK: - Check if Favorite Exists
    func isFavoriteExist(userId: Int64, recipeId: Int64) -> Bool {
        do {
            let query = favoriteRecipes.filter(favoriteUserId == userId && favoriteRecipeId == recipeId)
            // Sửa lại cách đếm cho an toàn hơn
            return try db!.scalar(query.count) > 0
        } catch {
            print("❌ Lỗi kiểm tra favorite: \(error)")
            return false
        }
    }

    // MARK: - Remove Favorite
    func removeFavoriteRecipe(userId: Int64, recipeId: Int64) -> Bool {
        do {
            let favoriteToDelete = favoriteRecipes.filter(favoriteUserId == userId && favoriteRecipeId == recipeId)
            try db?.run(favoriteToDelete.delete())
            return true
        } catch {
            print("❌ Lỗi xóa favorite recipe: \(error)")
            return false
        }
    }

    // MARK: - Print All Favorites
    func printAllFavorites() {
        do {
            if let rows = try db?.prepare(favoriteRecipes) {
                print("===== Danh sách favorite recipes =====")
                for row in rows {
                    print("ID: \(row[favoriteId]), User: \(row[favoriteUserId]), Recipe: \(row[favoriteRecipeId]), Time: \(row[favoriteCreatedAt])")
                }
                print("===== Kết thúc danh sách =====")
            }
        } catch {
            print("❌ Lỗi lấy favorite recipes: \(error)")
        }
    }
}
