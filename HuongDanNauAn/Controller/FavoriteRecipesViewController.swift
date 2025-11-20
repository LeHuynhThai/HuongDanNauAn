import UIKit

class FavoriteRecipesViewController: UIViewController, FavoriteRecipeCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Mảng chứa danh sách favorite recipes
    var favoriteRecipes: [Recipe] = []
    
    // ID của user hiện tại
    var currentUserId: Int64 {
        return Session.currentUserId ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        loadFavoriteRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload mỗi khi quay lại màn hình này
        loadFavoriteRecipes()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // Load danh sách favorite recipes của user
    func loadFavoriteRecipes() {
        
        // Nếu chưa login -> không load
        guard currentUserId != 0 else {
            print("Chưa đăng nhập — không thể load favorite")
            favoriteRecipes = []
            tableView.reloadData()
            updateEmptyState()
            return
        }
    
        // Bước 1: Lấy danh sách favorite của user
        let favorites = DatabaseManager.shared.getFavoritesByUser(currentUserId)
        
        // Bước 2: Lấy chi tiết recipe từ recipeId
        favoriteRecipes = []
        let allRecipes = DatabaseManager.shared.getAllRecipes()
        
        for favorite in favorites {
            // Tìm recipe có id tương ứng
            if let recipe = allRecipes.first(where: { $0.recipeId == favorite.recipeId }) {
                favoriteRecipes.append(recipe)
            }
        }
        
        tableView.reloadData()
        updateEmptyState()
        print("Đã load \(favoriteRecipes.count) favorite recipes")
    }
    
    // Xử lý khi nhấn nút trái tim
    func didTapFavoriteButton(cell: FavoriteRecipeCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let recipe = favoriteRecipes[indexPath.row]
        
        // Hiển thị alert xác nhận
        let alert = UIAlertController(
            title: "Xóa khỏi yêu thích",
            message: "Bạn có chắc muốn xóa \"\(recipe.name)\" khỏi danh sách yêu thích?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        alert.addAction(UIAlertAction(title: "Xóa", style: .destructive) { _ in
            self.removeFavorite(at: indexPath)
        })
        
        present(alert, animated: true)
    }
    
    private func removeFavorite(at indexPath: IndexPath) {
        let recipe = favoriteRecipes[indexPath.row]
        
        let success = DatabaseManager.shared.removeFavoriteRecipe(
            userId: currentUserId,
            recipeId: recipe.recipeId
        )
        
        if success {
            favoriteRecipes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateEmptyState()
            print("Đã xóa \(recipe.name) khỏi favorite")
        }
    }
    
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        // StackView
        let leftStackView = UIStackView()
        leftStackView.axis = .horizontal
        leftStackView.spacing = 8
        leftStackView.alignment = .center
        
        // Logo
        let logoImageView = UIImageView(image: UIImage(named: "chef"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "CookEase"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .label
        
        leftStackView.addArrangedSubview(logoImageView)
        leftStackView.addArrangedSubview(titleLabel)
        
        // Constraints cho logo
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            logoImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        let leftBarButton = UIBarButtonItem(customView: leftStackView)
        navigationItem.leftBarButtonItem = leftBarButton
    }
}

extension FavoriteRecipesViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Số lượng row = số lượng favorite recipes
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    // Hiển thị dữ liệu lên từng cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteRecipeCell
        
        let recipe = favoriteRecipes[indexPath.row]
        
        // Gán dữ liệu vào cell
        cell.RecipeName.text = recipe.name
        cell.RecipeTime.text = "\(recipe.cookTime ?? 0) phút"
        cell.RecipyDifficulty.text = recipe.difficulty.rawValue.uppercased()
        
        // Load hình ảnh
        if let imageURL = recipe.imageURL {
            cell.RecipeImage.image = UIImage(named: imageURL)
        } else {
            cell.RecipeImage.image = UIImage(named: "chef")
        }
        
        // Bo góc cho hình ảnh
        cell.RecipeImage.layer.cornerRadius = 8
        cell.RecipeImage.clipsToBounds = true
        cell.delegate = self
        return cell
    }
    
    // Chiều cao của mỗi row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Khi tap vào cell -> Chuyển sang màn hình chi tiết recipe
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let recipe = favoriteRecipes[indexPath.row]
        print("Đã chọn: \(recipe.name)")
        
        // TODO: Navigate sang màn hình chi tiết recipe
        // let detailVC = RecipeDetailViewController()
        // detailVC.recipe = recipe
        // navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Empty State Logic
    func updateEmptyState() {
        if favoriteRecipes.isEmpty {
            // 1. Tạo View chứa thông báo
            let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.height))
            
            // 2. Tạo hình ảnh (Icon)
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "heart.slash") // Dùng icon hệ thống hoặc "chef" của bạn
            imageView.tintColor = .systemGray3
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            // 3. Tạo Label (Chữ thông báo)
            let messageLabel = UILabel()
            messageLabel.text = "Bạn chưa có công thức yêu thích nào"
            messageLabel.textColor = .secondaryLabel
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            
            // 4. Thêm vào View và set AutoLayout
            emptyView.addSubview(imageView)
            emptyView.addSubview(messageLabel)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20),
                imageView.widthAnchor.constraint(equalToConstant: 60),
                imageView.heightAnchor.constraint(equalToConstant: 60),
                
                messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
                messageLabel.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 20),
                messageLabel.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: -20)
            ])
            
            // 5. Gán vào backgroundView của tableView
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none // Ẩn các dòng kẻ ngăn cách cell
        } else {
            // Nếu có dữ liệu thì xóa background view đi
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
    }
}
