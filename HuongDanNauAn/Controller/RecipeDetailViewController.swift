import UIKit

class RecipeDetailViewController: UIViewController {
    
    // MARK: - Data Variable
    var recipeId: Int64?
    var recipe: Recipe?
    
    // MARK: - Favorite State
    private var isFavorite: Bool = false
    
    // MARK: - UI Elements
    
    // 1. Loading Indicator
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .systemGray
        return indicator
    }()
    
    // 2. Label thông báo loading
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Đang hiển thị dữ liệu..."
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    // 3. ScrollView (Chứa nội dung chính)
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .systemBackground
        sv.alpha = 0 // MẶC ĐỊNH ẨN ĐỂ CHỜ DỮ LIỆU
        return sv
    }()
    
    // 4. Container View
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // --- CÁC THÀNH PHẦN CHI TIẾT ---
    
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .systemRed
        button.backgroundColor = .white
        button.layer.cornerRadius = 22
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let metaStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let difficultyBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    // Header Nguyên liệu
    private let ingredientsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nguyên liệu"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    // Nội dung Nguyên liệu
    private let ingredientsContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    // Header Cách làm
    private let instructionsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cách làm"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    // Nội dung Cách làm
    private let instructionsContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        loadAndDisplayData()
        checkFavoriteStatus()
    }
    
    // MARK: - LOGIC QUAN TRỌNG: Load Data
    func loadAndDisplayData() {
        
        // 1. Luôn luôn hiển thị trạng thái Loading trước tiên
        loadingIndicator.startAnimating()
        loadingLabel.isHidden = false
        scrollView.alpha = 0 // Ẩn toàn bộ nội dung
        
        // 2. Kiểm tra ID
        guard let id = recipeId else {
            return
        }
        
        // 3. Nếu CÓ ID -> Bắt đầu tải dữ liệu
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let fetchedRecipe = DatabaseManager.shared.getRecipeById(id)
            
            // 4. Tải xong -> Cập nhật UI
            DispatchQueue.main.async {
                self.recipe = fetchedRecipe
                
                // Ẩn Loading
                self.loadingIndicator.stopAnimating()
                self.loadingLabel.isHidden = true
                
                if self.recipe != nil {
                    // Đổ dữ liệu vào View
                    self.displayData()
                    
                    // Hiện nội dung lên
                    UIView.animate(withDuration: 0.3) {
                        self.scrollView.alpha = 1
                    }
                } else {
                    self.showAlert(title: "Lỗi", message: "Không tìm thấy thông tin món ăn")
                }
            }
        }
    }
    
    // MARK: - Display Data to UI
    func displayData() {
        guard let recipe = recipe else { return }
        
        // Tên
        nameLabel.text = recipe.name
        
        // Thời gian
        if let time = recipe.cookTime {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(systemName: "clock")?.withTintColor(.secondaryLabel)
            attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
            let fullString = NSMutableAttributedString(attachment: attachment)
            fullString.append(NSAttributedString(string: " \(time) phút"))
            timeLabel.attributedText = fullString
        } else {
            timeLabel.text = ""
        }
        
        // Độ khó
        switch recipe.difficulty {
        case .easy:
            difficultyBadge.text = "  Dễ  "
            difficultyBadge.backgroundColor = .systemGreen
        case .medium:
            difficultyBadge.text = "  Trung bình  "
            difficultyBadge.backgroundColor = .systemOrange
        case .hard:
            difficultyBadge.text = "  Khó  "
            difficultyBadge.backgroundColor = .systemRed
        default:
            difficultyBadge.text = "  N/A  "
            difficultyBadge.backgroundColor = .systemGray
        }
        
        // Ảnh
        if let imageName = recipe.imageURL, !imageName.isEmpty {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imagesFolderURL = documentsURL.appendingPathComponent("recipe_images")
            let imagePath = imagesFolderURL.appendingPathComponent(imageName).path
            
            if fileManager.fileExists(atPath: imagePath), let image = UIImage(contentsOfFile: imagePath) {
                recipeImageView.image = image
            } else if let assetImage = UIImage(named: imageName) {
                recipeImageView.image = assetImage
            } else {
                recipeImageView.image = UIImage(named: "pho_bo") ?? UIImage(systemName: "photo")
            }
        } else {
            recipeImageView.image = UIImage(named: "pho_bo") ?? UIImage(systemName: "photo")
        }
        
        // Nguyên liệu
        if recipe.ingredients.isEmpty {
            ingredientsContentLabel.text = "Chưa có thông tin."
        } else {
            let text = recipe.ingredients.map { "• \($0)" }.joined(separator: "\n\n")
            ingredientsContentLabel.attributedText = createSpacedText(text)
        }
        
        // Cách làm
        if recipe.instructions.isEmpty {
            instructionsContentLabel.text = "Chưa có hướng dẫn."
        } else {
            let text = recipe.instructions.enumerated().map { "Bước \($0 + 1):\n\($1)" }.joined(separator: "\n\n")
            instructionsContentLabel.attributedText = createSpacedText(text)
        }
    }
    
    // MARK: - Setup UI Layout
    func setupUI() {
        // 1. Thêm các View chính
        view.addSubview(scrollView)
        view.addSubview(loadingIndicator)
        view.addSubview(loadingLabel)
        scrollView.addSubview(contentView)
        
        // 2. Constraints cho ScrollView & Loading
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 12),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // 3. Thêm nội dung vào ContentView
        contentView.addSubview(recipeImageView)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(nameLabel)
        contentView.addSubview(metaStackView)
        contentView.addSubview(ingredientsHeaderLabel)
        contentView.addSubview(ingredientsContentLabel)
        contentView.addSubview(instructionsHeaderLabel)
        contentView.addSubview(instructionsContentLabel)
        
        metaStackView.addArrangedSubview(timeLabel)
        metaStackView.addArrangedSubview(difficultyBadge)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        let padding: CGFloat = 16
        
        // 4. Constraints chi tiết cho nội dung
        NSLayoutConstraint.activate([
            // Ảnh
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 250),
            
            // Nút Favorite
            favoriteButton.trailingAnchor.constraint(equalTo: recipeImageView.trailingAnchor, constant: -16),
            favoriteButton.bottomAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Tên món
            nameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Meta Stack
            metaStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            metaStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            difficultyBadge.heightAnchor.constraint(equalToConstant: 24),
            
            // Header Nguyên liệu
            ingredientsHeaderLabel.topAnchor.constraint(equalTo: metaStackView.bottomAnchor, constant: 24),
            ingredientsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ingredientsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Nội dung Nguyên liệu
            ingredientsContentLabel.topAnchor.constraint(equalTo: ingredientsHeaderLabel.bottomAnchor, constant: 8),
            ingredientsContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ingredientsContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Header Cách làm
            instructionsHeaderLabel.topAnchor.constraint(equalTo: ingredientsContentLabel.bottomAnchor, constant: 24),
            instructionsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            instructionsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Nội dung Cách làm
            instructionsContentLabel.topAnchor.constraint(equalTo: instructionsHeaderLabel.bottomAnchor, constant: 8),
            instructionsContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            instructionsContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // CHỐT BOTTOM CONTENT VIEW
            instructionsContentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // Helper: Spaced Text
    private func createSpacedText(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        return NSAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label
        ])
    }
    
    // MARK: - Navigation Bar
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let leftStackView = UIStackView()
        leftStackView.axis = .horizontal
        leftStackView.spacing = 8
        leftStackView.alignment = .center
        
        let logoImageView = UIImageView(image: UIImage(named: "chef"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = "CookEase"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        
        leftStackView.addArrangedSubview(logoImageView)
        leftStackView.addArrangedSubview(titleLabel)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftStackView)
    }
    
    // MARK: - Favorite Logic
    func checkFavoriteStatus() {
        guard let userId = Session.currentUserId, let recipeId = recipeId else {
            updateFavoriteButton(isFavorite: false)
            return
        }
        isFavorite = DatabaseManager.shared.isFavoriteExist(userId: userId, recipeId: recipeId)
        updateFavoriteButton(isFavorite: isFavorite)
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        let iconName = isFavorite ? "heart.fill" : "heart"
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        favoriteButton.setImage(UIImage(systemName: iconName, withConfiguration: config), for: .normal)
    }
    
    @objc func favoriteButtonTapped() {
        guard let userId = Session.currentUserId, let recipeId = recipeId else {
            showAlert(title: "Thông báo", message: "Vui lòng đăng nhập để sử dụng tính năng này")
            return
        }
        
        if isFavorite {
            let success = DatabaseManager.shared.removeFavoriteRecipe(userId: userId, recipeId: recipeId)
            if success {
                isFavorite = false
                updateFavoriteButton(isFavorite: false)
                showToast(message: "Đã xóa khỏi yêu thích")
            }
        } else {
            let success = DatabaseManager.shared.addFavoriteRecipe(userId: userId, recipeId: recipeId)
            if success {
                isFavorite = true
                updateFavoriteButton(isFavorite: true)
                showToast(message: "Đã thêm vào yêu thích")
            }
        }
    }
    
    // MARK: - Helpers
    func showToast(message: String) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.text = message
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let textSize = message.size(withAttributes: [.font: toastLabel.font!])
        toastLabel.frame = CGRect(x: (view.frame.width - textSize.width - 40) / 2,
                                  y: view.frame.height - 150,
                                  width: textSize.width + 40,
                                  height: 35)
        view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
