import Foundation
import SQLite

extension DatabaseManager {

    // MARK: - Add Recipe
    func addRecipe(name: String,
                   ingredients: [String],
                   instructions: [String],
                   userId: Int64,
                   cookTime: Int? = nil,
                   difficulty: Recipe.Difficulty = .medium,
                   imageURL: String? = nil) -> Bool {
        do {
            // Encode ingredients & instructions as JSON
            let ingredientsData = try JSONEncoder().encode(ingredients)
            let instructionsData = try JSONEncoder().encode(instructions)
            let ingredientsString = String(data: ingredientsData, encoding: .utf8) ?? "[]"
            let instructionsString = String(data: instructionsData, encoding: .utf8) ?? "[]"

            let insert = recipes.insert(
                self.recipeName <- name,
                self.recipeIngredients <- ingredientsString,
                self.recipeInstructions <- instructionsString,
                self.recipeUserId <- userId,
                self.recipeCookTime <- cookTime,
                self.recipeDifficulty <- difficulty.rawValue,
                self.recipeImageURL <- imageURL,
                self.recipeCreatedAt <- Date()
            )
            try db?.run(insert)
            return true
        } catch {
            print("Lỗi thêm recipe: \(error)")
            return false
        }
    }

    // MARK: - Get Recipes by User
    func getRecipesByUser(_ userId: Int64) -> [Recipe] {
        var recipesList: [Recipe] = []
        do {
            for row in try db!.prepare(recipes.filter(self.recipeUserId == userId)) {
                let ingredients = decodeStringArray(row[self.recipeIngredients])
                let instructions = decodeStringArray(row[self.recipeInstructions])
                let difficulty = Recipe.Difficulty(rawValue: row[self.recipeDifficulty]) ?? .medium

                let recipeObj = Recipe(
                    recipeId: row[recipeId],
                    userId: row[recipeUserId],
                    name: row[recipeName],
                    ingredients: ingredients,
                    instructions: instructions,
                    createdAt: row[recipeCreatedAt],
                    cookTime: row[recipeCookTime],
                    difficulty: difficulty,
                    imageURL: row[recipeImageURL]
                )
                recipesList.append(recipeObj)
            }
        } catch {
            print("Lỗi lấy recipes: \(error)")
        }
        return recipesList
    }

    // MARK: - Get All Recipes
    func getAllRecipes() -> [Recipe] {
        var recipesList: [Recipe] = []
        do {
            for row in try db!.prepare(recipes) {
                let ingredients = decodeStringArray(row[self.recipeIngredients])
                let instructions = decodeStringArray(row[self.recipeInstructions])
                let difficulty = Recipe.Difficulty(rawValue: row[self.recipeDifficulty]) ?? .medium

                let recipeObj = Recipe(
                    recipeId: row[recipeId],
                    userId: row[recipeUserId],
                    name: row[recipeName],
                    ingredients: ingredients,
                    instructions: instructions,
                    createdAt: row[recipeCreatedAt],
                    cookTime: row[recipeCookTime],
                    difficulty: difficulty,
                    imageURL: row[recipeImageURL]
                )
                recipesList.append(recipeObj)
            }
        } catch {
            print("Lỗi lấy all recipes: \(error)")
        }
        return recipesList
    }

    // MARK: - Update Recipe
    func updateRecipe(id: Int64,
                      name: String,
                      ingredients: [String],
                      instructions: [String],
                      cookTime: Int? = nil,
                      difficulty: Recipe.Difficulty = .medium,
                      imageURL: String? = nil) -> Bool {
        do {
            let recipeToUpdate = recipes.filter(recipeId == id)
            let ingredientsData = try JSONEncoder().encode(ingredients)
            let instructionsData = try JSONEncoder().encode(instructions)
            let ingredientsString = String(data: ingredientsData, encoding: .utf8) ?? "[]"
            let instructionsString = String(data: instructionsData, encoding: .utf8) ?? "[]"

            try db?.run(recipeToUpdate.update(
                recipeName <- name,
                recipeIngredients <- ingredientsString,
                recipeInstructions <- instructionsString,
                recipeCookTime <- cookTime,
                recipeDifficulty <- difficulty.rawValue,
                recipeImageURL <- imageURL
            ))
            return true
        } catch {
            print("Lỗi cập nhật recipe: \(error)")
            return false
        }
    }

    // MARK: - Delete Recipe
    func deleteRecipe(id: Int64) -> Bool {
        do {
            let recipeToDelete = recipes.filter(recipeId == id)
            try db?.run(recipeToDelete.delete())
            return true
        } catch {
            print("Lỗi xóa recipe: \(error)")
            return false
        }
    }

    // MARK: - Print All Recipes
    func printAllRecipes() {
        do {
            if let rows = try db?.prepare(recipes) {
                print("===== Danh sách công thức =====")
                for row in rows {
                    let ingredients = decodeStringArray(row[recipeIngredients])
                    let instructions = decodeStringArray(row[recipeInstructions])
                    print("ID: \(row[recipeId]), Name: \(row[recipeName]), User ID: \(row[recipeUserId]), Created: \(row[recipeCreatedAt])")
                    print("  Ingredients: \(ingredients)")
                    print("  Instructions: \(instructions)")
                    print("  CookTime: \(String(describing: row[recipeCookTime])), Difficulty: \(row[recipeDifficulty]), Image: \(String(describing: row[recipeImageURL]))")
                    print("---")
                }
                print("===== Kết thúc danh sách =====")
            }
        } catch {
            print("Lỗi lấy recipes: \(error)")
        }
    }

    // MARK: - Helper: Decode JSON string to [String]
    private func decodeStringArray(_ jsonString: String) -> [String] {
        guard let data = jsonString.data(using: .utf8) else { return [] }
        do {
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("Lỗi decode JSON: \(error)")
            return []
        }
    }

    // MARK: - Database Path
    func getDatabasePath() -> String? {
        do {
            let fileUrl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("AppDatabase.sqlite3")
            return fileUrl.path
        } catch {
            print("Lỗi lấy database path: \(error)")
            return nil
        }
    }
}
