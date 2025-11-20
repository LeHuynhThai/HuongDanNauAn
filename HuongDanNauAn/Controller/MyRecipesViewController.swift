import UIKit

class MyRecipesViewController: UIViewController {

    @IBOutlet weak var CollectionView: UICollectionView!
    // MARK: - UI Elements
    let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Công thức của tôi"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .systemGroupedBackground
        return cv
    }()
    
    let floatingButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.35, green: 0.78, blue: 0.35, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.3
        button.layer.cornerRadius = 30
        button.clipsToBounds = false
        return button
    }()

    var recipes: [Recipe] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        overrideUserInterfaceStyle = .light

        setupNavigationBar()
        setupHeaderLabel()
        setupCollectionView()
        setupFloatingButton()
        loadRecipes()
        
        NotificationCenter.default.addObserver(self,
                                             selector: #selector(reloadRecipes),
                                             name: NSNotification.Name("DidAddNewRecipe"),
                                             object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecipes()
    }
    
    @objc func reloadRecipes() {
        loadRecipes()
    }

    // MARK: - Setup UI Methods
    func setupNavigationBar() {
        let leftStackView = UIStackView()
        leftStackView.axis = .horizontal
        leftStackView.spacing = 8
        leftStackView.alignment = .center
        leftStackView.translatesAutoresizingMaskIntoConstraints = false

        let logoImageView = UIImageView(image: UIImage(named: "chef"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            logoImageView.heightAnchor.constraint(equalToConstant: 32)
        ])

        let titleLabel = UILabel()
        titleLabel.text = "CookEase"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textColor = .label

        leftStackView.addArrangedSubview(logoImageView)
        leftStackView.addArrangedSubview(titleLabel)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftStackView)
    }
    
    func setupHeaderLabel() {
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(MyRecipeCell.self, forCellWithReuseIdentifier: "MyRecipeCell")

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func setupFloatingButton() {
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    @objc func addButtonTapped() {
        performSegue(withIdentifier: "showAddRecipe", sender: self)
    }

    // MARK: - Data Loading
    func loadRecipes() {
        guard let userId = Session.currentUserId else {
            recipes = []
            collectionView.reloadData()
            return
        }
        
        recipes = DatabaseManager.shared.getRecipesByUser(userId)
        recipes.sort { $0.name.lowercased() < $1.name.lowercased() }
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension MyRecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyRecipeCell", for: indexPath) as! MyRecipeCell
        let recipe = recipes[indexPath.item]
        cell.configure(with: recipe)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MyRecipesViewController: UICollectionViewDelegate {
    
    // recipe detail
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 1. Lấy Recipe được chọn
        let selectedRecipe = recipes[indexPath.item]
        
        // 2. Khởi tạo màn hình chi tiết
        let detailVC = RecipeDetailViewController()
        
        // 3. Truyền dữ liệu
        detailVC.recipe = selectedRecipe
        
        // 4. Chuyển màn hình (Push Navigation)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            let deleteAction = UIAction(title: "Xóa", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.deleteRecipe(at: indexPath)
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }
    
    func deleteRecipe(at indexPath: IndexPath) {
        let recipe = recipes[indexPath.item]
        let alert = UIAlertController(title: "Xác nhận xóa", message: "Bạn có chắc muốn xóa \"\(recipe.name)\"?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        alert.addAction(UIAlertAction(title: "Xóa", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            if DatabaseManager.shared.deleteRecipe(id: recipe.recipeId) {
                self.recipes.remove(at: indexPath.item)
                self.collectionView.deleteItems(at: [indexPath])
            }
        })
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MyRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 12
        let spacing: CGFloat = 12
        let totalSpacing = padding * 2 + spacing
        let width = (collectionView.frame.width - totalSpacing) / 2
        let imageHeight = width
        let textHeight: CGFloat = 88
        return CGSize(width: width, height: imageHeight + textHeight)
    }
}

// MARK: - MyRecipeCell
private class MyRecipeCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    let difficultyBadge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // Bỏ layer.cornerRadius và backgroundColor
        return view
    }()
    
    let difficultyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        // Đổi Font/Màu cho phù hợp với nền trắng
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .secondaryLabel // Màu xám để dễ nhìn
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 0.1
        
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(difficultyBadge)
        difficultyBadge.addSubview(difficultyLabel)
        
        NSLayoutConstraint.activate([
            // ImageView
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            // NameLabel
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // TimeLabel
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8),
            
            // Difficulty badge (Invisible container)
            difficultyBadge.topAnchor.constraint(equalTo: timeLabel.topAnchor),
            difficultyBadge.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 8),
            difficultyBadge.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            
            // Difficulty Label (Fill Badge, so the badge's position matches the label's content)
            difficultyLabel.topAnchor.constraint(equalTo: difficultyBadge.topAnchor),
            difficultyLabel.bottomAnchor.constraint(equalTo: difficultyBadge.bottomAnchor),
            difficultyLabel.leadingAnchor.constraint(equalTo: difficultyBadge.leadingAnchor),
            difficultyLabel.trailingAnchor.constraint(equalTo: difficultyBadge.trailingAnchor)
        ])
    }
    
    func configure(with recipe: Recipe) {
        nameLabel.text = recipe.name
        timeLabel.text = recipe.cookTime != nil ? "\(recipe.cookTime!) phút" : "-- phút"
        
        switch recipe.difficulty {
        case .easy:
            difficultyLabel.text = "Dễ"
        case .medium:
            difficultyLabel.text = "TB"
        case .hard:
            difficultyLabel.text = "Khó"
        }
        
        // --- LOGIC XỬ LÝ ẢNH THÔNG MINH (DOCUMENTS + ASSETS) ---
        
        // 1. Kiểm tra nếu recipe có tên ảnh
        guard let imageName = recipe.imageURL, !imageName.isEmpty else {
            imageView.image = UIImage(systemName: "photo")
            setupDefaultImageStyle()
            return
        }
        
        var finalImage: UIImage?
        
        // 2. ƯU TIÊN 1: Tìm trong thư mục Documents (Ảnh do người dùng thêm)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // Kiểm tra trong folder con recipe_images
        let subFolderURL = documentsURL.appendingPathComponent("recipe_images").appendingPathComponent(imageName)
        // Kiểm tra ngay ngoài Documents
        let directURL = documentsURL.appendingPathComponent(imageName)
        
        if let image = UIImage(contentsOfFile: subFolderURL.path) {
            finalImage = image
            print("Đã lấy ảnh từ Documents/recipe_images: \(imageName)")
        } else if let image = UIImage(contentsOfFile: directURL.path) {
            finalImage = image
            print("Đã lấy ảnh từ Documents (gốc): \(imageName)")
        }
        
        // 3. ƯU TIÊN 2: Nếu không thấy trong Documents, tìm trong Assets (Ảnh mẫu có sẵn)
        if finalImage == nil {
            // Lưu ý: UIImage(named:) sẽ tự tìm trong Assets của dự án
            if let image = UIImage(named: imageName) {
                finalImage = image
                print("Đã lấy ảnh từ Assets: \(imageName)")
            }
        }
        
        // 4. Hiển thị kết quả
        if let image = finalImage {
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.tintColor = .clear // Xóa màu tint nếu là ảnh thật
        } else {
            // Không tìm thấy ở đâu cả
            print("Không tìm thấy ảnh '\(imageName)' trong Documents hay Assets")
            imageView.image = UIImage(systemName: "photo")
            setupDefaultImageStyle()
        }
    }
    
    // Hàm phụ để chỉnh style cho icon mặc định
    private func setupDefaultImageStyle() {
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
    }
}
