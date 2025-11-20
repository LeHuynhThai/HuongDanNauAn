import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    var db: Connection?

    // MARK: - Tables & Columns

    // Users table
    let users = Table("users")
    let userId = Expression<Int64>("user_id")
    let userName = Expression<String>("user_name")
    let emailAddress = Expression<String>("email_address")
    let password = Expression<String>("password")
    let userImage = Expression<String?>("user_image")
    // Lưu ý: DB của bạn lưu ngày là String
    let createdAt = Expression<String>("created_at")
    let updatedAt = Expression<String>("update_at")

    // Recipes table
    let recipes = Table("recipes")
    let recipeId = Expression<Int64>("recipe_id")
    let recipeUserId = Expression<Int64>("user_id")
    let recipeName = Expression<String>("recipe_name")
    let recipeIngredients = Expression<String>("recipe_ingredients")
    let recipeInstructions = Expression<String>("recipe_instructions")
    // Sửa thành String để khớp với DB
    let recipeCreatedAt = Expression<String>("created_at")
    let recipeCookTime = Expression<Int?>("recipe_time")
    let recipeDifficulty = Expression<String>("recipe_difficulty")
    let recipeImageURL = Expression<String?>("recipe_image")

    // FavoriteRecipes table
    let favoriteRecipes = Table("favorite_recipes")
    let favoriteId = Expression<Int64>("favorite_id")
    let favoriteUserId = Expression<Int64>("user_id")
    let favoriteRecipeId = Expression<Int64>("recipe_id")
    // Sửa thành String
    let favoriteCreatedAt = Expression<String>("created_at")

    // MARK: - Init
    private init() {
        do {
            let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsFolder.appendingPathComponent("AppDatabase.sqlite3")
            
            // Copy file từ Bundle nếu chưa có
            if !FileManager.default.fileExists(atPath: destinationUrl.path) {
                if let bundlePath = Bundle.main.path(forResource: "AppDatabase", ofType: "sqlite3") {
                    try FileManager.default.copyItem(atPath: bundlePath, toPath: destinationUrl.path)
                    print("✅ Đã copy Database thành công!")
                }
            }
            
            db = try Connection(destinationUrl.path)
            createTables()
            print("Database path: \(destinationUrl.path)")
        } catch {
            print("❌ Lỗi khởi tạo DB: \(error)")
        }
    }
    
    // MARK: - Create Tables (Sửa lỗi defaultValue Date)
    func createTables() {
        do {
            // Users
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(userId, primaryKey: .autoincrement)
                t.column(userName)
                t.column(emailAddress, unique: true, collate: .nocase)
                t.column(password)
                t.column(userImage)
                t.column(createdAt) // Bỏ defaultValue Date()
                t.column(updatedAt) // Bỏ defaultValue Date()
            })

            // Recipes
            try db?.run(recipes.create(ifNotExists: true) { t in
                t.column(recipeId, primaryKey: .autoincrement)
                t.column(recipeUserId)
                t.column(recipeName)
                t.column(recipeIngredients)
                t.column(recipeInstructions)
                t.column(recipeCreatedAt) // SỬA LỖI Ở ĐÂY: Không để Date() nữa
                t.column(recipeCookTime)
                t.column(recipeDifficulty)
                t.column(recipeImageURL)
                t.foreignKey(recipeUserId, references: users, userId, delete: .cascade)
            })

            // Favorites
            try db?.run(favoriteRecipes.create(ifNotExists: true) { t in
                t.column(favoriteId, primaryKey: .autoincrement)
                t.column(favoriteUserId)
                t.column(favoriteRecipeId)
                t.column(favoriteCreatedAt) // SỬA LỖI Ở ĐÂY
                t.foreignKey(favoriteUserId, references: users, userId, delete: .cascade)
                t.foreignKey(favoriteRecipeId, references: recipes, recipeId, delete: .cascade)
            })

        } catch {
            print("⚠️ Lỗi tạo bảng: \(error)")
        }
    }

    // MARK: - FAVORITE FEATURES
    func isRecipeFavorite(userId: Int64, recipeId: Int64) -> Bool {
        guard let db = db else { return false }
        do {
            let query = favoriteRecipes.filter(favoriteUserId == userId && favoriteRecipeId == recipeId)
            return try db.scalar(query.count) > 0
        } catch {
            return false
        }
    }

    func addFavorite(userId: Int64, recipeId: Int64) -> Bool {
        guard let db = db else { return false }
        do {
            // Chuyển Date hiện tại sang String để lưu
            let dateString = getCurrentDateString()
            
            let insert = favoriteRecipes.insert(
                favoriteUserId <- userId,
                favoriteRecipeId <- recipeId,
                favoriteCreatedAt <- dateString // Lưu String
            )
            try db.run(insert)
            return true
        } catch {
            print("Lỗi add favorite: \(error)")
            return false
        }
    }

    func removeFavorite(userId: Int64, recipeId: Int64) -> Bool {
        guard let db = db else { return false }
        do {
            let item = favoriteRecipes.filter(favoriteUserId == userId && favoriteRecipeId == recipeId)
            try db.run(item.delete())
            return true
        } catch {
            return false
        }
    }
    
    // MARK: - GET DATA
    func getRecipe(byID id: Int64) -> Recipe? {
        guard let db = db else { return nil }
        
        do {
            let query = recipes.filter(recipeId == id)
            
            if let row = try db.pluck(query) {
                // 1. Parse JSON String -> Array
                let ingredientsArray = parseStringToArray(jsonString: row[recipeIngredients])
                let instructionsArray = parseStringToArray(jsonString: row[recipeInstructions])
                
                // 2. Parse String -> Date (SỬA LỖI 2 & 3)
                let date = parseDate(dateString: row[recipeCreatedAt])
                
                // 3. Enum
                let difficultyEnum = Recipe.Difficulty(rawValue: row[recipeDifficulty]) ?? .medium
                
                // 4. Init Model
                return Recipe(
                    recipeId: row[recipeId],
                    userId: row[recipeUserId],
                    name: row[recipeName],
                    ingredients: ingredientsArray,
                    instructions: instructionsArray,
                    createdAt: date, // Đã chuyển thành Date
                    cookTime: row[recipeCookTime],
                    difficulty: difficultyEnum,
                    imageURL: row[recipeImageURL]
                )
            }
        } catch {
            print("❌ Lỗi getRecipe: \(error)")
        }
        return nil
    }
    
    // MARK: - HELPER FUNCTIONS
    
    func parseStringToArray(jsonString: String) -> [String] {
        guard let data = jsonString.data(using: .utf8) else { return [] }
        do {
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            let cleaned = jsonString
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")
                .replacingOccurrences(of: "\"", with: "")
            return cleaned.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
    }
    
    func parseDate(dateString: String) -> Date {
        let formatter = DateFormatter()
        // Định dạng khớp với DB của bạn: "2025-11-19T16:29:21.322"
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter.date(from: dateString) ?? Date()
    }
    
    func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter.string(from: Date())
    }
}
