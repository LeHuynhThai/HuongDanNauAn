import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Mảng chứa danh sách tất cả món ăn từ database
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        // Thêm delegate cho searchBar để bắt sự kiện tìm kiếm
        searchBar.delegate = self
        loadRecipes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload lại data mỗi khi quay lại màn hình này (để cập nhật món mới/yêu thích)
        loadRecipes()
    }
    
    // Setup layout và appearance cho CollectionView
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
    
    // Setup thanh navigation bar với logo, title
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
        
        // 2. Setup Nút Profile (Lấy lại từ Main sang)
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profileButton.layer.cornerRadius = 20
        profileButton.clipsToBounds = true
        if let avatarImage = UIImage(named: "user_avatar") {
            profileButton.setImage(avatarImage, for: .normal)
            profileButton.imageView?.contentMode = .scaleAspectFill
        } else {
            profileButton.backgroundColor = .systemGray4 // Màu mặc định nếu không có ảnh
        }
        profileButton.layer.borderWidth = 0.5
        profileButton.layer.borderColor = UIColor.systemGray5.cgColor
        
        // Thêm action cho nút Profile nếu cần
        // profileButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
    }
    
    // Logic chuẩn bị chuyển màn hình Search (Lấy từ Main sang nhưng chỉnh lại cho hợp lý)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchResults",
           let destination = segue.destination as? SearchResultViewController,
           let searchText = sender as? String {
            // Truyền từ khóa tìm kiếm sang màn hình kết quả
            // destination.searchKeyword = searchText
            print("Đang tìm kiếm: \(searchText)")
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Số lượng item trong collection view = số lượng món ăn
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    // Tạo và cấu hình cell cho từng món ăn
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue cell với identifier "cell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
        
        // Lấy recipe tại vị trí indexPath
        let recipe = recipes[indexPath.row]
        
        // Gọi hàm configure để setup cell với dữ liệu recipe
        cell.configure(with: recipe)
        
        return cell
    }
    
    // Tính toán kích thước cho từng cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 12   // Padding 2 bên
        let spacing: CGFloat = 12   // Khoảng cách giữa 2 cột
        let totalSpacing = padding * 2 + spacing
        
        // Tính width: Chia đôi màn hình trừ đi spacing
        let width = (collectionView.frame.width - totalSpacing) / 2
        
        // Tính height: Hình ảnh vuông + chiều cao cho text
        let imageHeight = width     // Hình vuông (width = height)
        let textHeight: CGFloat = 44 + 24 + 20
        
        return CGSize(width: width, height: imageHeight + textHeight)
    }
}

// MARK: - SearchBar Delegate (Lấy lại từ Main)
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Ẩn bàn phím
        if let text = searchBar.text, !text.isEmpty {
            performSegue(withIdentifier: "showSearchResults", sender: text)
        }
    }
}
