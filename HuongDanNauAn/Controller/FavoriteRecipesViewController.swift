import UIKit

class FavoriteRecipesViewController: UIViewController, FavoriteRecipeCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Mảng chứa danh sách favorite recipes
    var favoriteRecipes: [Recipe] = []
    
    // ID của user hiện tại (tạm thời hardcode, sau này lấy từ UserDefaults hoặc Session)
    var currentUserId: Int64 = 1
    
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
}
