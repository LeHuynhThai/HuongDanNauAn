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
            //11
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
             10, 15, .easy, "miso-soup"),
            
// **
            ("Bánh Mì Pate",
             ["Bánh mì", "Pate", "Dưa leo", "Cà rốt ngâm", "Ngò", "Chả lụa"],
             ["Bánh mì cắt đôi", "Quét pate", "Cho chả lụa và rau củ", "Rắc ngò lên trên", "Ăn kèm nước mắm chua ngọt"],
             1, 15, .easy, "banh_mi_pate"),
            
            ("Chả Cá Lã Vọng",
             ["Cá lăng hoặc cá hồi", "Thì là", "Nghệ", "Bột nghệ", "Bún tươi", "Đậu phộng", "Mắm tôm"],
             ["Ướp cá với nghệ và gia vị", "Rán cá vàng", "Xào thì là", "Bày cá lên bún, rắc đậu phộng", "Chấm với mắm tôm"],
             1, 60, .hard, "cha_ca_la_vong"),
            
            ("Bún Riêu Cua",
             ["Cua đồng", "Cà chua", "Đậu hũ", "Bún tươi", "Hành lá", "Ngò gai", "Gia vị"],
             ["Xay cua lấy nước", "Nấu nước dùng với cà chua", "Cho đậu hũ vào", "Trụng bún", "Chan nước riêu vào tô", "Thêm rau thơm"],
             2, 45, .medium, "bun_rieu_cua"),
            
            ("Bánh Cuốn",
             ["Bột gạo", "Thịt băm", "Nấm mèo", "Hành phi", "Rau mùi", "Nước mắm chua ngọt"],
             ["Trộn bột gạo làm bột bánh", "Hấp bánh mỏng", "Nhồi thịt nấm vào bánh", "Rắc hành phi", "Ăn kèm nước mắm chua ngọt"],
             2, 40, .medium, "banh_cuon"),
            
            ("Bánh Chưng",
             ["Gạo nếp", "Đậu xanh", "Thịt mỡ", "Lá dong", "Gia vị"],
             ["Ngâm gạo nếp và đậu xanh", "Gói bánh với lá dong", "Luộc bánh 6-8 tiếng", "Để nguội và thưởng thức"],
             3, 480, .hard, "banh_chung"),
            
            ("Nem Rán",
             ["Thịt lợn xay", "Bún khô", "Nấm mèo", "Rau thơm", "Bánh tráng", "Trứng", "Dầu ăn"],
             ["Trộn nhân với bún và nấm", "Cuốn nem vào bánh tráng", "Chiên vàng", "Dùng kèm nước mắm chua ngọt"],
             3, 60, .medium, "nem_ran"),
            
            ("Canh Bún",
             ["Bún tươi", "Thịt bò", "Cà chua", "Rau cải xanh", "Gia vị"],
             ["Nấu nước dùng với thịt bò và cà chua", "Cho bún vào tô", "Chan nước dùng nóng", "Thêm rau cải"],
             4, 35, .easy, "canh_bun"),
            
            ("Bánh Bao",
             ["Bột mì", "Thịt heo băm", "Trứng cút", "Nấm", "Gia vị"],
             ["Nhồi bột và ủ", "Trộn nhân với thịt, trứng và nấm", "Gói nhân vào bột", "Hấp 20 phút"],
             4, 50, .medium, "banh_bao"),
            
            ("Xôi Gấc",
             ["Gạo nếp", "Gấc chín", "Đường", "Dừa nạo"],
             ["Ngâm gạo nếp", "Trộn gấc vào gạo", "Hấp 30 phút", "Rắc dừa nạo và đường"],
             5, 60, .easy, "xoi_gac"),
            
            ("Bún Thang",
             ["Gà luộc", "Trứng", "Giò lụa", "Bún tươi", "Hành hoa", "Rau thơm"],
             ["Nấu nước dùng gà", "Thái trứng, giò lụa", "Trụng bún", "Xếp các nguyên liệu vào tô", "Chan nước dùng"],
             5, 90, .hard, "bun_thang"),
            
            ("Chè Ba Màu",
             ["Đậu đỏ", "Đậu xanh", "Nước cốt dừa", "Thạch", "Đường"],
             ["Luộc đậu", "Chuẩn bị thạch", "Xếp các lớp màu", "Rưới nước cốt dừa", "Thưởng thức"],
             6, 30, .easy, "che_ba_mau"),
            
            ("Bánh Tét",
             ["Gạo nếp", "Đậu xanh", "Thịt mỡ", "Lá chuối", "Gia vị"],
             ["Ngâm gạo nếp", "Gói nhân với lá chuối", "Luộc bánh 6-8 tiếng", "Thưởng thức"],
             6, 480, .hard, "banh_tet"),
            
            ("Bánh Khọt",
             ["Bột gạo", "Tôm", "Dừa nạo", "Hành lá", "Dầu ăn", "Rau sống"],
             ["Trộn bột và dừa", "Đổ bột vào khuôn nhỏ", "Cho tôm lên trên", "Chiên vàng", "Ăn kèm rau sống"],
             7, 35, .medium, "banh_khot"),
            
            ("Bún Mắm",
             ["Bún tươi", "Mắm cá linh", "Thịt heo", "Tôm", "Rau sống"],
             ["Nấu nước dùng mắm", "Luộc thịt và tôm", "Trụng bún", "Chan nước dùng vào tô", "Thêm rau sống"],
             7, 50, .medium, "bun_mam"),
            
            ("Cá Kho Tộ",
             ["Cá trắm hoặc cá lóc", "Nước mắm", "Đường", "Tiêu", "Hành tím"],
             ["Ướp cá với gia vị", "Kho cá trong nồi đất đến cạn nước", "Rắc tiêu và hành phi"],
             1, 60, .medium, "ca_kho_to"),
            
            ("Gà Luộc",
             ["Gà nguyên con", "Muối", "Gừng", "Hành"],
             ["Làm sạch gà", "Luộc gà chín vừa", "Thái và ăn kèm nước mắm gừng"],
             2, 40, .easy, "ga_luoc"),
            
            ("Lẩu Thái Việt Nam",
             ["Tôm", "Mực", "Cá", "Nấm", "Rau sống", "Gia vị lẩu"],
             ["Nấu nước lẩu chua cay", "Thêm hải sản và nấm", "Dọn ra ăn kèm rau sống và bún"],
             3, 60, .medium, "lau_thai_vn"),
            
            ("Bánh Đúc Nóng",
             ["Bột gạo", "Nước", "Thịt băm", "Nước mắm", "Hành phi"],
             ["Hòa bột với nước", "Đun đến đặc", "Cho thịt băm lên trên", "Rắc hành phi", "Ăn nóng"],
             4, 30, .easy, "banh_duc_nong"),
            
            ("Cháo Gà",
             ["Gạo", "Gà", "Hành lá", "Gừng", "Tiêu"],
             ["Ninh gạo và gà thành cháo", "Thêm gia vị vừa ăn", "Rắc hành lá và gừng thái chỉ"],
             5, 45, .easy, "chao_ga"),
            
            ("Bánh Xèo Miền Trung",
             ["Bột bánh xèo", "Tôm", "Thịt heo", "Giá đỗ", "Hành lá", "Dầu ăn"],
             ["Trộn bột", "Đổ bột lên chảo", "Cho nhân tôm thịt", "Gấp bánh", "Ăn kèm rau sống"],
             6, 40, .medium, "banh_xeo_mt_trung"),
            
            ("Bún Bò Huế",
             ["Bún tươi", "Thịt bò", "Chân giò", "Sả", "Gia vị Huế", "Hành lá"],
             ["Nấu nước dùng bò với sả", "Thái thịt bò", "Trụng bún", "Chan nước dùng vào tô", "Rắc hành lá"],
             7, 90, .hard, "bun_bo_hue"),
            
            ("Chả Huế",
             ["Thịt heo", "Bánh tráng", "Gia vị Huế", "Rau sống"],
             ["Trộn thịt với gia vị", "Cuốn vào bánh tráng", "Chiên vàng", "Ăn kèm rau sống"],
             1, 50, .medium, "cha_hue"),
            
            ("Xôi Xéo",
             ["Gạo nếp", "Đậu xanh", "Hành phi", "Dầu mỡ"],
             ["Ngâm gạo nếp", "Hấp chín", "Rắc đậu xanh và hành phi", "Rưới dầu mỡ"],
             2, 40, .easy, "xoi_xeo"),
            
            ("Canh Cá Nấu Dưa",
             ["Cá lóc", "Dưa cải chua", "Cà chua", "Hành lá", "Gia vị"],
             ["Nấu nước dùng với dưa cải", "Cho cá vào", "Nêm nếm vừa ăn", "Rắc hành lá"],
             3, 35, .medium, "canh_ca_dua"),
            
            ("Bánh Gối",
             ["Bột mỳ", "Thịt băm", "Nấm", "Trứng", "Gia vị"],
             ["Nhồi bột", "Cuốn nhân vào bột", "Chiên vàng", "Ăn kèm nước chấm"],
             4, 45, .medium, "banh_goi"),
            
            ("Chè Khoai Môn",
             ["Khoai môn", "Đậu xanh", "Nước cốt dừa", "Đường"],
             ["Luộc khoai và đậu", "Trộn đường và nước cốt dừa", "Thưởng thức nóng hoặc lạnh"],
             5, 30, .easy, "che_khoai_mon"),
            ("Pizza Margherita",
                 ["Bột mì", "Nước", "Men nở", "Cà chua", "Phô mai mozzarella", "Rau húng"],
                 ["Nhồi bột và ủ 1 tiếng", "Trải bột lên khay", "Phết sốt cà chua", "Rắc phô mai và rau húng", "Nướng 220°C 15 phút"],
                 8, 45, .medium, "pizza_margherita"),
                
                ("Spaghetti Carbonara",
                 ["Spaghetti", "Trứng", "Phô mai parmesan", "Bacon", "Tiêu", "Muối"],
                 ["Luộc mì al dente", "Chiên bacon", "Trộn trứng và phô mai", "Trộn mì với hỗn hợp trứng-bacon", "Rắc tiêu"],
                 8, 30, .medium, "spaghetti_carbonara"),
                
                ("Cánh Gà Nướng Mật Ong",
                 ["1kg cánh gà", "Mật ong", "Tỏi", "Ớt bột", "Tiêu", "Muối"],
                 ["Ướp cánh gà với gia vị", "Nướng 180°C 30 phút", "Phết mật ong và nướng thêm 10 phút"],
                 9, 40, .easy, "canh_ga_nuong_mat_ong"),
                
                ("Tacos Thịt Bò",
                 ["Bánh taco", "Thịt bò xay", "Xà lách", "Cà chua", "Phô mai", "Sốt salsa"],
                 ["Nấu thịt bò với gia vị", "Xếp nhân vào bánh taco", "Thêm rau và phô mai", "Rưới sốt salsa"],
                 9, 25, .easy, "tacos_thit_bo"),
                
                ("Pancakes",
                 ["Bột mì", "Sữa", "Trứng", "Đường", "Bơ", "Maple syrup"],
                 ["Trộn bột, sữa, trứng", "Đổ bột lên chảo nóng", "Chiên vàng 2 mặt", "Ăn kèm bơ và syrup"],
                 10, 20, .easy, "pancakes"),
                
                ("Cà Ri Gà",
                 ["500g thịt gà", "Khoai tây", "Cà rốt", "Hành tây", "Sữa dừa", "Bột cà ri", "Gia vị"],
                 ["Phi hành, thêm bột cà ri", "Cho thịt gà và rau củ", "Đổ sữa dừa và ninh 30 phút"],
                 1, 50, .medium, "ca_ri_ga"),
                
                ("Gà Xào Sả Ớt",
                 ["500g đùi gà", "Sả", "Ớt", "Tỏi", "Hành tây", "Dầu ăn", "Gia vị"],
                 ["Phi tỏi, sả và ớt", "Xào gà đến chín", "Thêm hành tây", "Nêm gia vị vừa ăn"],
                 2, 35, .easy, "ga_xao_sa_ot"),
                
                ("Bánh Flan",
                 ["Sữa tươi", "Trứng", "Đường", "Vanilla"],
                 ["Nấu caramel từ đường", "Trộn trứng với sữa và vanilla", "Đổ vào khuôn caramel", "Hấp 30 phút"],
                 3, 50, .medium, "banh_flan"),
                
                ("Takikomi Gohan",
                 ["Gạo Nhật", "Cà rốt", "Nấm", "Gà", "Dashi", "Nước tương", "Mirin"],
                 ["Vo gạo, thái nguyên liệu", "Cho tất cả vào nồi cơm", "Nấu chín", "Trộn đều trước khi ăn"],
                 10, 50, .medium, "takikomi_gohan"),
                
                ("Okonomiyaki",
                 ["Bột mì", "Trứng", "Bắp cải", "Thịt hoặc hải sản", "Sốt okonomiyaki", "Mayonnaise"],
                 ["Trộn bột, trứng, bắp cải", "Đổ lên chảo", "Cho nhân thịt/hải sản", "Chiên vàng hai mặt", "Phết sốt và mayonnaise"],
                 10, 40, .medium, "okonomiyaki"),
                
                ("Gỏi Đu Đủ Thái",
                 ["Đu đủ xanh", "Cà rốt", "Tôm khô", "Đậu phộng", "Ớt", "Nước mắm", "Chanh", "Tỏi"],
                 ["Bào đu đủ và cà rốt", "Trộn với tôm khô, đậu phộng", "Pha nước mắm chua cay", "Trộn đều và ăn ngay"],
                 4, 20, .easy, "goi_du_du_thai"),
                
                ("Bánh Mì Xíu Mại",
                 ["Bánh mì", "Thịt xay", "Hành tây", "Trứng", "Nước sốt"],
                 ["Nặn thịt thành xíu mại", "Nấu sốt", "Nướng xíu mại trong lò", "Kẹp bánh mì với xíu mại và sốt"],
                 5, 40, .medium, "banh_mi_xiu_mai"),
                
                ("Lẩu Hải Sản",
                 ["Tôm", "Mực", "Cá", "Rau củ", "Nước dùng lẩu", "Gia vị"],
                 ["Chuẩn bị nước lẩu", "Cho hải sản và rau củ vào nồi", "Đun sôi và thưởng thức nóng"],
                 6, 60, .hard, "lau_hai_san")
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
