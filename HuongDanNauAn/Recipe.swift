//
//  Recipe.swift
//  HuongDanNauAn
//
//  Created by admin on 17/11/2025.
//

import Foundation

struct Recipe {
    let recipe_id: String
    var user_id: String
    var recipe_name: String
    var recipe_description: String
    var recipe_time: Int
    var recipe_level: String
    var recipe_ingredients: [String]
    var recipe_instructions: [String]
    var recipe_image: String?
}
