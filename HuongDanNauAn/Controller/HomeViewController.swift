import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Biến chứa dữ liệu
    var recipes: [Recipe] = []
    
    // MARK: - LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        
        // Thêm delegate cho searchBar để bắt sự kiện tìm kiếm
        searchBar.delegate = self
        
        // Tải dữ liệu lần đầu
        loadRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload lại data mỗi khi quay lại màn hình này (để cập nhật món mới/yêu thích)
        loadRecipes()
    }
    
    // MARK: - SETUP UI
    func setupCollectionView() {
        CollectionView.delegate = self
        CollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        
        CollectionView.collectionViewLayout = layout
        CollectionView.backgroundColor = .systemGroupedBackground
    }
    
    func loadRecipes() {
        // Load dữ liệu thật từ Database
        recipes = DatabaseManager.shared.getAllRecipes()
        CollectionView.reloadData()
        print("Đã load \(recipes.count) recipes")
    }
    
    func setupNavigationBar() {
        // 1. Setup Logo và Title
        let leftStackView = UIStackView()
        leftStackView.axis = .horizontal
        leftStackView.spacing = 8
        leftStackView.alignment = .center
        
        let logoImageView = UIImageView(image: UIImage(named: "chef"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = "CookEase"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .label
        
        leftStackView.addArrangedSubview(logoImageView)
        leftStackView.addArrangedSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            logoImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        let leftBarButton = UIBarButtonItem(customView: leftStackView)
        navigationItem.leftBarButtonItem = leftBarButton
        
        // 2. Setup Nút Profile
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true
        if let avatarImage = UIImage(named: "user_avatar") {
            profileButton.setImage(avatarImage, for: .normal)
            profileButton.imageView?.contentMode = .scaleAspectFill
        } else {
            profileButton.backgroundColor = .systemGray4
        }
        profileButton.layer.borderWidth = 0.5
        profileButton.layer.borderColor = UIColor.systemGray5.cgColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
    
    // Logic chuẩn bị chuyển màn hình Search
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResults",
           let destination = segue.destination as? SearchResultViewController,
           let searchText = sender as? String {
            // destination.searchKeyword = searchText
            print("Đang tìm kiếm: \(searchText)")
        }
    }
}

// MARK: - UICOLLECTIONVIEW DELEGATE & DATASOURCE
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Số lượng món ăn
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    // Hiển thị dữ liệu lên từng ô (Cell)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Lưu ý: "cell" là identifier trong Storyboard
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        
        // Gán dữ liệu thật vào cell
        // (Đảm bảo tên biến RecipeName, RecipeTime... khớp với file RecipeCell.swift của bạn)
        cell.RecipeName.text = recipe.name
        cell.RecipeTime.text = "\(recipe.cookTime ?? 0) phút"
        cell.RecipeDifficulty.text = recipe.difficulty.rawValue.uppercased()
                
        // Load hình ảnh
        if let imageURL = recipe.imageURL, !imageURL.isEmpty {
            cell.RecipeImageView.image = UIImage(named: imageURL) ?? UIImage(named: "pho_bo")
        } else {
            cell.RecipeImageView.image = UIImage(named: "pho_bo") // Hình mặc định
        }
        return cell
    }
    
    // Cấu hình kích thước ô
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 12
        let spacing: CGFloat = 12
        let totalSpacing = padding * 2 + spacing
        
        let width = (collectionView.frame.width - totalSpacing) / 2
        let imageHeight = width
        let textHeight: CGFloat = 44 + 24 + 20
        
        return CGSize(width: width, height: imageHeight + textHeight)
    }
    
    // SỰ KIỆN BẤM VÀO MÓN ĂN (CODE MỚI THÊM)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. Lấy món ăn vừa bấm
        let selectedRecipe = recipes[indexPath.row]
        print("👉 Đã chọn món: \(selectedRecipe.name) (ID: \(selectedRecipe.recipeId))")
        
        // 2. Gọi màn hình Detail
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Lưu ý: "RecipeDetailViewController" phải trùng khớp với Storyboard ID bạn đã đặt
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController {
            
            // 3. Truyền ID sang màn hình Detail
            detailVC.recipeId = selectedRecipe.recipeId
            
            // 4. Chuyển màn hình
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("❌ Lỗi: Không tìm thấy màn hình Detail với ID 'RecipeDetailViewController'")
        }
    }
}

// MARK: - SEARCH BAR DELEGATE
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Ẩn bàn phím
        if let text = searchBar.text, !text.isEmpty {
            performSegue(withIdentifier: "showSearchResults", sender: text)
        }
    }
}
