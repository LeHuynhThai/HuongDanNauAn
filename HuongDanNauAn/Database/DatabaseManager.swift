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
    let createdAt = Expression<Date>("created_at")
    let updatedAt = Expression<Date>("update_at")

    // Recipes table
    let recipes = Table("recipes")
    let recipeId = Expression<Int64>("recipe_id")
    let recipeUserId = Expression<Int64>("user_id")
    let recipeName = Expression<String>("recipe_name")
    let recipeIngredients = Expression<String>("recipe_ingredients")
    let recipeInstructions = Expression<String>("recipe_instructions")
    let recipeCreatedAt = Expression<Date>("created_at")
    let recipeCookTime = Expression<Int?>("recipe_time")
    let recipeDifficulty = Expression<String>("recipe_difficulty")
    let recipeImageURL = Expression<String?>("recipe_image")

    // FavoriteRecipes table
    let favoriteRecipes = Table("favorite_recipes")
    let favoriteId = Expression<Int64>("favorite_id")
    let favoriteUserId = Expression<Int64>("user_id")
    let favoriteRecipeId = Expression<Int64>("recipe_id")
    let favoriteCreatedAt = Expression<Date>("created_at")

    // MARK: - Init
    private init() {
        do {
            let fileUrl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("AppDatabase.sqlite3")

            db = try Connection(fileUrl.path)
            createTables()

            print("Database lưu ở: \(fileUrl.path)")
        } catch {
            print("Không tạo được database: \(error)")
        }
    }

    // MARK: - Create Tables
    func createTables() {
        do {
            // Users table
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(userId, primaryKey: .autoincrement)
                t.column(userName)
                t.column(emailAddress, unique: true, collate: .nocase)
                t.column(password)
                t.column(userImage)
                t.column(createdAt, defaultValue: Date())
                t.column(updatedAt, defaultValue: Date())
            })

            // Recipes table
            try db?.run(recipes.create(ifNotExists: true) { t in
                t.column(recipeId, primaryKey: .autoincrement)
                t.column(recipeUserId)
                t.column(recipeName)
                t.column(recipeIngredients)
                t.column(recipeInstructions)
                t.column(recipeCreatedAt, defaultValue: Date())
                t.column(recipeCookTime)
                t.column(recipeDifficulty)
                t.column(recipeImageURL)
                t.foreignKey(recipeUserId, references: users, userId, delete: .cascade)
            })

            // FavoriteRecipes table
            try db?.run(favoriteRecipes.create(ifNotExists: true) { t in
                t.column(favoriteId, primaryKey: .autoincrement)
                t.column(favoriteUserId)
                t.column(favoriteRecipeId)
                t.column(favoriteCreatedAt, defaultValue: Date())
                t.foreignKey(favoriteUserId, references: users, userId, delete: .cascade)
                t.foreignKey(favoriteRecipeId, references: recipes, recipeId, delete: .cascade)
            })

        } catch {
            print("Không tạo được table: \(error)")
        }
    }
}

