import Foundation

class Recipe {
    // Thuộc tính
    let recipeId: Int64
    let userId: Int64
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let createdAt: Date
    let cookTime: Int?
    let difficulty: Difficulty
    var imageURL: String?

    // Enum độ khó
    enum Difficulty: String, CaseIterable {
        case easy = "Dễ"
        case medium = "Trung bình"
        case hard = "Khó"
    }
    
    // Computed property để định dạng ngày tạo
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: createdAt)
    }
    
    // Hàm khởi tạo
    init(recipeId: Int64 = 0,
         userId: Int64 = 0,
         name: String = "",
         ingredients: [String] = [],
         instructions: [String] = [],
         createdAt: Date = Date(),
         cookTime: Int? = nil,
         difficulty: Difficulty = .medium,
         imageURL: String? = nil) {
        self.recipeId = recipeId
        self.userId = userId
        self.name = name
        self.ingredients = ingredients
        self.instructions = instructions
        self.createdAt = createdAt
        self.cookTime = cookTime
        self.difficulty = difficulty
        self.imageURL = imageURL
    }
}

