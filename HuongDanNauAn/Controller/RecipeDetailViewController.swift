//
//  RecipeDetailViewController.swift
//  HuongDanNauAn
//
//  Created by admin on 14/11/2025.
//

import UIKit

class RecipeDetailViewController: UIViewController {

    // MARK: - 1. KẾT NỐI GIAO DIỆN (IBOutlets)
    // Bạn cần mở Storyboard và kéo thả kết nối vào các dòng này
    // Đổi từ UIButton -> UIBarButtonItem
    
    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    @IBOutlet weak var btnShare: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    @IBOutlet weak var btnDone: UIButton!
    
    // MARK: - 2. BIẾN DỮ LIỆU
    var recipeId: Int64 = 2         // ID mặc định là 1 (để test). Sau này từ Home truyền sang.
    var currentUserId: Int64 = 1    // ID user giả định
    var isFavorite: Bool = false    // Trạng thái tim hiện tại

    // MARK: - 3. VÒNG ĐỜI (Life Cycle)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Setup giao diện Nav Bar (Code cũ của bạn)
        setupNavigationBar()
        
        // 2. Setup giao diện các phần tử khác
        setupUI()
        
        // 3. Tải dữ liệu từ Database
        loadData()
        
        // 4. Kiểm tra trạng thái tim
        checkFavoriteStatus()
    }
    
    // MARK: - 4. SETUP GIAO DIỆN
        func setupNavigationBar() {
            // 1. Ẩn nút Back mặc định
            navigationItem.hidesBackButton = true
            
            // 2. TẠO NÚT BACK MỚI (Hình vuông mũi tên)
            let backButton = UIButton(type: .system)
            // Dùng icon hình vuông như bạn muốn
            backButton.setImage(UIImage(systemName: "arrow.backward.square"), for: .normal)
            // Hoặc dùng "chevron.left" nếu muốn mũi tên đơn giản
            
            backButton.setTitle("", for: .normal) // Không cần chữ
            
            // QUAN TRỌNG: Nối dây bằng code (vì nút này tự tạo, không có trong Storyboard)
            backButton.addTarget(self, action: #selector(didTapBack(_:)), for: .touchUpInside)
            
            let leftBackItem = UIBarButtonItem(customView: backButton)
            
            // 3. TẠO LOGO VÀ TÊN (Code cũ của bạn)
            let logoImageView = UIImageView(image: UIImage(named: "chef"))
            logoImageView.contentMode = .scaleAspectFit
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let titleLabel = UILabel()
            titleLabel.text = " CookEase"
            titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            titleLabel.textColor = .label
            
            // Gom Logo và Tên vào 1 nhóm
            let leftStackView = UIStackView(arrangedSubviews: [logoImageView, titleLabel])
            leftStackView.axis = .horizontal
            leftStackView.spacing = 8
            leftStackView.alignment = .center
            
            // Ràng buộc kích thước logo
            NSLayoutConstraint.activate([
                logoImageView.widthAnchor.constraint(equalToConstant: 32),
                logoImageView.heightAnchor.constraint(equalToConstant: 32)
            ])
            
            let leftLogoItem = UIBarButtonItem(customView: leftStackView)
            
            // 4. HIỆN CẢ 2 LÊN MÀN HÌNH (Nút Back trước, Logo sau)
            navigationItem.leftBarButtonItems = [leftBackItem, leftLogoItem]
        }
    
    func setupUI() {
        // Làm đẹp ảnh
        if let imgView = recipeImageView {
            imgView.layer.cornerRadius = 15
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFill
        }
        
        // Không cho người dùng sửa nội dung text view
        ingredientsTextView?.isEditable = false
        instructionsTextView?.isEditable = false
    }

    // MARK: - 5. TẢI DỮ LIỆU TỪ DB
    func loadData() {
        print("🔄 Đang tải dữ liệu cho Recipe ID: \(recipeId)")
        
        // Gọi DatabaseManager (Hàm chúng ta đã viết ở bước trước)
        if let recipe = DatabaseManager.shared.getRecipe(byID: recipeId) {
            nameLabel.text = recipe.name
            
            // Set Title màn hình (nếu cần)
            // self.title = recipe.name
            
            // Thời gian & Độ khó
            if let timeLabel = timeLabel {
                timeLabel.text = (recipe.cookTime != nil) ? "\(recipe.cookTime!) phút" : "-- phút"
            }
            
            if let diffLabel = difficultyLabel {
                diffLabel.text = recipe.difficulty.rawValue
            }
            
            // Ảnh
            if let imgView = recipeImageView, let imgName = recipe.imageURL, !imgName.isEmpty {
                imgView.image = UIImage(named: imgName) ?? UIImage(systemName: "photo")
            }
            
            // Nguyên liệu (Gạch đầu dòng)
            if let ingTextView = ingredientsTextView {
                let ingredientsText = recipe.ingredients
                    .map { "• " + $0 }
                    .joined(separator: "\n")
                ingTextView.text = ingredientsText
            }
            
            // Hướng dẫn (Đánh số bước)
            if let insTextView = instructionsTextView {
                let instructionsText = recipe.instructions.enumerated().map { (index, step) in
                    return "Bước \(index + 1):\n\(step)"
                }.joined(separator: "\n\n")
                insTextView.text = instructionsText
            }
            
            print("✅ Đã tải xong: \(recipe.name)")
            
        } else {
            print("❌ Không tìm thấy dữ liệu món ăn ID: \(recipeId)")
        }
    }
    
    // MARK: - 6. XỬ LÝ YÊU THÍCH
    func checkFavoriteStatus() {
        isFavorite = DatabaseManager.shared.isRecipeFavorite(userId: currentUserId, recipeId: recipeId)
        updateFavoriteButtonIcon()
    }
    
    func updateFavoriteButtonIcon() {
            guard let btn = btnFavorite else { return }
            
            let iconName = isFavorite ? "heart.fill" : "heart"
            // UIBarButtonItem không có tintColor cho từng trạng thái như Button,
            // nó lấy màu chung. Nếu muốn đổi màu đỏ, ta phải đổi tintColor của nút.
            
            btn.image = UIImage(systemName: iconName)
            btn.tintColor = isFavorite ? .red : .systemBlue // Hoặc màu mặc định bạn muốn
        }

    // MARK: - 7. CÁC SỰ KIỆN BẤM NÚT (IBActions)
    // Nhớ nối các hàm này vào nút bấm trong Storyboard (Touch Up Inside)
    
    @objc @IBAction func didTapBack(_ sender: Any) {
        // Quay lại màn hình trước
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        if isFavorite {
            // Đang thích -> Bấm để bỏ thích
            if DatabaseManager.shared.removeFavorite(userId: currentUserId, recipeId: recipeId) {
                isFavorite = false
            }
        } else {
            // Chưa thích -> Bấm để thích
            if DatabaseManager.shared.addFavorite(userId: currentUserId, recipeId: recipeId) {
                isFavorite = true
            }
        }
        updateFavoriteButtonIcon()
    }
    
    @IBAction func didTapShare(_ sender: Any) {
        let text = "Xem công thức món ngon này trên CookEase nhé!"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    // MARK: - SỰ KIỆN BẤM NÚT HOÀN THÀNH
        @IBAction func didTapComplete(_ sender: Any) {
            // Cách 1: Hiển thị thông báo chúc mừng trước khi quay về (Tùy chọn - Cho chuyên nghiệp)
            let alert = UIAlertController(title: "Tuyệt vời! 🎉", message: "Bạn đã hoàn thành món ăn này.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Về trang chủ", style: .default, handler: { _ in
                // Sau khi bấm OK thì mới quay về
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true)
            
            // Cách 2: Quay về luôn (Nhanh gọn)
            // navigationController?.popViewController(animated: true)
        }
}
