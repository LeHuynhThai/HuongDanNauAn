import Foundation

extension DatabaseManager {
    func seedRecipes() {
        let recipes: [(name: String, ingredients: [String], instructions: [String], userId: Int64, cookTime: Int, difficulty: Recipe.Difficulty, imageURL: String?)] = [
            // Món Việt Nam (User 1-7)
            ("Phở Bò",
             ["500g thịt bò", "300g bánh phở", "2 củ hành tây", "Gừng 50g", "Hành lá", "Ngò gai", "Hạt tiêu", "Nước mắm", "Đường phèn", "Hồi, quế"],
             ["Ninh xương bò 3 tiếng với hành, gừng nướng", "Thái thịt bò mỏng", "Trụng bánh phở", "Xếp bánh phở, thịt bò vào tô", "Chan nước dùng sôi", "Thêm hành lá, ngò gai, hạt tiêu"],
             1, 180, .hard, "pho_bo"),
            
            ("Bún Chả Hà Nội",
             ["500g thịt ba chỉ", "300g bún tươi", "Nước mắm", "Đường", "Tỏi", "Ớt", "Rau sống", "Dưa leo"],
             ["Ướp thịt với nước mắm, tỏi băm", "Nướng thịt trên than hồng", "Pha nước chấm chua ngọt", "Bày bún, rau sống, dưa leo", "Chấm với nước mắm pha"],
             1, 45, .medium, "bun_cha_hn"),
            
            ("Gỏi Cuốn Tôm Thịt",
             ["200g tôm", "200g thịt ba chỉ", "Bánh tráng", "Bún tươi", "Rau xà lách", "Húng quế", "Nước chấm"],
             ["Luộc tôm và thịt", "Thái tôm dọc, thái thịt mỏng", "Trụng bún", "Cuốn bánh tráng với tôm, thịt, bún, rau", "Chấm với nước mắm"],
             2, 30, .easy, "goi_cuon_tom_thit"),
            
            ("Cơm Tấm Sườn Nướng",
             ["300g sườn heo", "Cơm tấm", "Trứng ốp la", "Dưa leo", "Cà chua", "Nước mắm", "Đường", "Tỏi"],
             ["Ướp sườn với nước mắm, đường, tỏi băm", "Nướng sườn đến vàng đều", "Chiên trứng ốp la", "Bày cơm tấm, sườn, trứng", "Rưới nước mắm pha"],
             2, 40, .easy, "com_tam_suon"),
            
            ("Bánh Xèo Miền Tây",
             ["Bột bánh xèo", "Tôm", "Thịt heo", "Giá đỗ", "Hành lá", "Dầu ăn", "Nước dừa", "Nghệ"],
             ["Trộn bột với nước dừa và nghệ", "Xào tôm, thịt", "Đổ bột mỏng lên chảo nóng", "Cho tôm, thịt, giá đỗ", "Gấp đôi bánh", "Ăn kèm rau sống"],
             3, 35, .medium, "banh_xeo_mt"),
            
            ("Bò Kho",
             ["700g thịt bò", "3 củ cà rốt", "Sả", "Ớt", "Hành tây", "Tỏi", "Gia vị bò kho", "Dầu ăn"],
             ["Thái bò hạt lựu, ướp gia vị", "Phi tỏi, ớt, sả băm", "Xào bò săn lại", "Thêm nước, cà rốt thái múi cau", "Ninh nhỏ lửa 90 phút", "Ăn kèm bánh mì hoặc bún"],
             3, 120, .medium, "bo_kho"),
            
            ("Canh Chua Cá",
             ["500g cá bông lau", "Dứa", "Cà chua", "Đậu bắp", "Me", "Đường", "Nước mắm", "Ngò om"],
             ["Rửa cá, cắt khúc", "Nấu nước me với đường", "Cho dứa, cà chua, đậu bắp", "Thả cá vào", "Nêm nếm vừa ăn", "Cho ngò om vào tắt bếp"],
             4, 30, .easy, "canh_chua_ca"),
            
            // Món Mỹ (User 4-7)
            ("Beef Burger",
             ["300g thịt bò xay", "Bánh burger", "Phô mai", "Salad", "Cà chua", "Hành tây", "Dưa chuột muối", "Sốt mayonnaise"],
             ["Nặn thịt bò thành patty dày 2cm", "Nướng patty 4 phút mỗi mặt", "Đặt phô mai lên patty khi gần chín", "Nướng bánh burger", "Xếp salad, thịt, rau vào bánh", "Phủ sốt mayonnaise"],
             4, 25, .easy, "beef-burger"),
            
            ("BBQ Ribs",
             ["1kg sườn heo", "Sốt BBQ", "Mật ong", "Tỏi", "Ớt bột", "Muối", "Tiêu"],
             ["Ướp sườn với gia vị 2 tiếng", "Nướng lò 160°C trong 2 tiếng", "Phết sốt BBQ lên sườn", "Nướng tiếp 30 phút", "Phết mật ong lên", "Nướng thêm 10 phút"],
             5, 180, .hard, "bbq-ribs"),
            
            ("Mac and Cheese",
             ["400g macaroni", "300g phô mai cheddar", "2 cốc sữa tươi", "50g bơ", "Bột mì", "Muối", "Tiêu", "Breadcrumbs"],
             ["Luộc macaroni theo hướng dẫn", "Làm sốt bơ sữa với bột mì", "Cho phô mai vào sốt", "Trộn macaroni với sốt phô mai", "Rắc breadcrumbs lên trên", "Nướng lò 180°C trong 20 phút"],
             5, 40, .medium, "mac and cheesse"),
            
            ("Caesar Salad",
             ["Xà lách romaine", "100g phô mai parmesan", "Bánh mì nướng", "Sốt Caesar", "Tỏi", "Cá cơm", "Dầu ô liu"],
             ["Rửa và xé xà lách", "Nướng bánh mì thành croutons", "Làm sốt Caesar từ cá cơm, tỏi, dầu ô liu", "Trộn xà lách với sốt", "Rắc phô mai parmesan", "Thêm croutons lên trên"],
             6, 20, .easy, "Caesar-Salad"),
            
            ("Chicken Wings",
             ["1kg cánh gà", "Sốt Buffalo", "Bơ", "Tỏi", "Ớt bột cayenne", "Muối", "Tiêu"],
             ["Ướp cánh gà với muối tiêu", "Chiên giòn cánh gà", "Làm sốt từ bơ, tỏi, ớt cayenne", "Trộn cánh gà với sốt Buffalo", "Phục vụ với sốt ranch", "Ăn kèm cần tây"],
             6, 45, .easy, "chicken-wings"),
            
            ("Apple Pie",
             ["5 trái táo", "Bột mì", "Bơ", "Đường", "Quế bột", "Chanh", "Trứng"],
             ["Làm bột bánh từ bột mì và bơ", "Thái táo múi cau", "Trộn táo với đường, quế", "Lót bột vào khuôn", "Cho nhân táo vào", "Nướng 180°C trong 45 phút"],
             7, 90, .hard, "Apple-Pie"),
            
            // Món Nhật (User 7-10)
            ("Sushi Cá Hồi",
             ["300g cá hồi tươi", "Cơm sushi", "Giấm gạo", "Đường", "Muối", "Wasabi", "Nước tương", "Gừng ngâm"],
             ["Nấu cơm và trộn giấm sushi", "Thái cá hồi mỏng", "Nắm cơm thành viên nhỏ", "Đặt cá hồi lên cơm", "Ăn kèm wasabi và nước tương", "Phục vụ với gừng ngâm"],
             7, 40, .medium, "sushi-cahoi"),
            
            ("Ramen",
             ["Mì ramen", "400g thịt heo", "Trứng", "Nấm", "Hành lá", "Nước dùng xương", "Tương đậu nành", "Miso"],
             ["Ninh nước dùng từ xương heo", "Luộc mì ramen", "Luộc trứng lòng đào", "Xào thịt heo với miso", "Bày mì, thịt, trứng vào tô", "Chan nước dùng nóng"],
             8, 120, .hard, "ramen"),
            
            ("Tempura Tôm",
             ["300g tôm", "Bột tempura", "Nước lạnh", "Dầu chiên", "Nước chấm tentsuyu", "Củ cải trắng"],
             ["Làm bột tempura với nước lạnh", "Làm sạch tôm", "Nhúng tôm vào bột", "Chiên giòn trong dầu 180°C", "Vớt ra để ráo dầu", "Chấm với nước tentsuyu"],
             8, 25, .medium, "tempura-tom"),
            
            ("Takoyaki",
             ["200g bạch tuộc", "Bột takoyaki", "Trứng", "Nước dashi", "Hành lá", "Gừng ngâm", "Sốt takoyaki", "Rong biển"],
             ["Trộn bột với trứng và nước dashi", "Cắt bạch tuộc nhỏ", "Đổ bột vào khuôn takoyaki", "Cho bạch tuộc vào giữa", "Lật đều để tròn", "Phủ sốt và rong biển"],
             9, 30, .medium, "takoyaki"),
            
            ("Teriyaki Chicken",
             ["500g đùi gà", "Sốt teriyaki", "Tương đậu nành", "Mirin", "Sake", "Đường", "Gừng", "Tỏi"],
             ["Ướp gà với gừng, tỏi", "Làm sốt teriyaki từ tương, mirin, sake", "Chiên gà đến vàng", "Thêm sốt teriyaki vào chảo", "Kho gà trong sốt", "Rắc mè lên trên"],
             9, 35, .easy, "chicken-teriyaki"),
            
            ("Miso Soup",
             ["Nước dashi", "Miso đỏ", "Đậu phụ", "Rong biển wakame", "Hành lá"],
             ["Đun sôi nước dashi", "Cắt đậu phụ hạt lựu", "Ngâm rong biển", "Hòa tan miso vào nước dashi", "Cho đậu phụ và rong biển vào", "Rắc hành lá lên trên"],
             10, 15, .easy, "miso-soup")
        ]
        
        print("===== Bắt đầu seed recipes =====")
        for recipe in recipes {
            let success = addRecipe(
                name: recipe.name,
                ingredients: recipe.ingredients,
                instructions: recipe.instructions,
                userId: recipe.userId,
                cookTime: recipe.cookTime,
                difficulty: recipe.difficulty,
                imageURL: recipe.imageURL
            )
            
            if success {
                print("Đã thêm: \(recipe.name) - User \(recipe.userId)")
            } else {
                print("Không thêm được: \(recipe.name)")
            }
        }
        print("===== Kết thúc seed recipes =====")
    }
}
