import UIKit

class RecipeDetailViewController: UIViewController {

    // MARK: - Data Variable
    var recipe: Recipe?

    // MARK: - UI Elements
    
    // 1. ScrollView để cuộn nội dung dài
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .systemBackground
        return sv
    }()
    
    // 2. Container View nằm trong ScrollView
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // 3. Ảnh món ăn
    private let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    // 4. Tên món ăn
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0 // Cho phép xuống dòng
        return label
    }()
    
    // 5. StackView chứa Thời gian & Độ khó
    private let metaStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    // Label thời gian
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // Badge độ khó
    private let difficultyBadge: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()
    
    // 6. Phần Nguyên liệu
    private let ingredientsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Nguyên liệu"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let ingredientsContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0 // Tự động dãn dòng
        return label
    }()
    
    // 7. Phần Cách làm
    private let instructionsHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cách làm"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let instructionsContentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0 // Tự động dãn dòng
        return label
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupUI()
        displayData()
    }
    
    // MARK: - Setup UI Layout
    func setupUI() {
        // Thêm ScrollView vào View chính
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Constraints cho ScrollView (Full màn hình)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View phải bám sát ScrollView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Quan trọng: Chặn cuộn ngang
        ])
        
        // Thêm các thành phần vào ContentView
        contentView.addSubview(recipeImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(metaStackView)
        contentView.addSubview(ingredientsHeaderLabel)
        contentView.addSubview(ingredientsContentLabel)
        contentView.addSubview(instructionsHeaderLabel)
        contentView.addSubview(instructionsContentLabel)
        
        // Thêm con vào StackView
        metaStackView.addArrangedSubview(timeLabel)
        metaStackView.addArrangedSubview(difficultyBadge)
        
        // --- Constraints chi tiết ---
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            // 1. Ảnh Header (Cao 250pt)
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 250),
            
            // 2. Tên món
            nameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: padding),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // 3. Stack (Thời gian + Độ khó)
            metaStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            metaStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            
            // Kích thước badge độ khó
            difficultyBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            difficultyBadge.heightAnchor.constraint(equalToConstant: 24),
            
            // 4. Header Nguyên liệu
            ingredientsHeaderLabel.topAnchor.constraint(equalTo: metaStackView.bottomAnchor, constant: 24),
            ingredientsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ingredientsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // 5. Nội dung Nguyên liệu
            ingredientsContentLabel.topAnchor.constraint(equalTo: ingredientsHeaderLabel.bottomAnchor, constant: 8),
            ingredientsContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            ingredientsContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // 6. Header Cách làm
            instructionsHeaderLabel.topAnchor.constraint(equalTo: ingredientsContentLabel.bottomAnchor, constant: 24),
            instructionsHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            instructionsHeaderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // 7. Nội dung Cách làm
            instructionsContentLabel.topAnchor.constraint(equalTo: instructionsHeaderLabel.bottomAnchor, constant: 8),
            instructionsContentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            instructionsContentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // QUAN TRỌNG: Constraint cuối cùng để ScrollView tính được độ cao nội dung
            instructionsContentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Display Data
    func displayData() {
        guard let recipe = recipe else { return }
        
        // 1. Tên
        nameLabel.text = recipe.name
        
        // 2. Thời gian
        if let time = recipe.cookTime {
            // Tạo text có icon đồng hồ
            let attachment = NSTextAttachment()
            attachment.image = UIImage(systemName: "clock")?.withTintColor(.secondaryLabel)
            attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
            let fullString = NSMutableAttributedString(attachment: attachment)
            fullString.append(NSAttributedString(string: " \(time) phút"))
            timeLabel.attributedText = fullString
        } else {
            timeLabel.text = ""
        }
        
        // 3. Độ khó
        switch recipe.difficulty {
        case .easy:
            difficultyBadge.text = "Dễ"
            difficultyBadge.backgroundColor = .systemGreen
        case .medium:
            difficultyBadge.text = "Trung bình"
            difficultyBadge.backgroundColor = .systemOrange
        case .hard:
            difficultyBadge.text = "Khó"
            difficultyBadge.backgroundColor = .systemRed
        }
        
        // 4. Xử lý Ảnh (Logic thông minh: Documents -> Assets)
        if let imageName = recipe.imageURL, !imageName.isEmpty {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let subFolderURL = documentsURL.appendingPathComponent("recipe_images").appendingPathComponent(imageName)
            let directURL = documentsURL.appendingPathComponent(imageName)
            
            if let image = UIImage(contentsOfFile: subFolderURL.path) {
                recipeImageView.image = image
            } else if let image = UIImage(contentsOfFile: directURL.path) {
                recipeImageView.image = image
            } else if let image = UIImage(named: imageName) {
                recipeImageView.image = image
            } else {
                recipeImageView.image = UIImage(systemName: "photo")
                recipeImageView.contentMode = .scaleAspectFit
                recipeImageView.tintColor = .systemGray3
            }
        } else {
            recipeImageView.image = UIImage(systemName: "photo")
            recipeImageView.contentMode = .scaleAspectFit
            recipeImageView.tintColor = .systemGray3
        }
        
        // 5. Xử lý Nguyên liệu (Mảng -> Text gạch đầu dòng)
        if recipe.ingredients.isEmpty {
            ingredientsContentLabel.text = "Chưa có thông tin nguyên liệu."
            ingredientsContentLabel.textColor = .secondaryLabel
            ingredientsContentLabel.font = UIFont.italicSystemFont(ofSize: 15)
        } else {
            let ingredientsText = recipe.ingredients.map { "• \($0)" }.joined(separator: "\n\n")
            // Tăng khoảng cách dòng cho dễ đọc
            ingredientsContentLabel.attributedText = createSpacedText(ingredientsText)
        }
        
        // 6. Xử lý Cách làm (Mảng -> Text bước 1, 2...)
        if recipe.instructions.isEmpty {
            instructionsContentLabel.text = "Chưa có hướng dẫn cách làm."
            instructionsContentLabel.textColor = .secondaryLabel
            instructionsContentLabel.font = UIFont.italicSystemFont(ofSize: 15)
        } else {
            let instructionsText = recipe.instructions.enumerated().map { index, step in
                return "Bước \(index + 1):\n\(step)"
            }.joined(separator: "\n\n")
            
            instructionsContentLabel.attributedText = createSpacedText(instructionsText)
        }
    }
    
    // Helper: Tạo khoảng cách dòng (Line Height)
    private func createSpacedText(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6 // Khoảng cách giữa các dòng
        
        return NSAttributedString(string: text, attributes: [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.label
        ])
    }
    
    // MARK: - Navigation Bar
    func setupNavigationBar() {
        // --- QUAN TRỌNG: Hiển thị nút Back ---
        // Vì đây là trang chi tiết, người dùng cần quay lại.
        // Dù bạn set hidesBackButton = true, tôi khuyên nên thêm nút back thủ công hoặc để mặc định.
        // Dưới đây là code giữ Header giống Home nhưng thêm nút Back.
        
        navigationItem.hidesBackButton = true // Theo yêu cầu của bạn
        
        let leftStackView = UIStackView()
        leftStackView.axis = .horizontal
        leftStackView.spacing = 8
        leftStackView.alignment = .center
        
        // Nút Back (Mũi tên)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // Logo
        let logoImageView = UIImageView(image: UIImage(named: "chef"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            logoImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Chi tiết" // Đổi title một chút cho hợp lý
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        
        leftStackView.addArrangedSubview(backButton) // Thêm nút back vào stack
        leftStackView.addArrangedSubview(logoImageView)
        leftStackView.addArrangedSubview(titleLabel)
        
        // Tăng vùng hit test cho nút back bằng cách set spacing custom nếu cần
        leftStackView.setCustomSpacing(16, after: backButton)

        let leftBarButton = UIBarButtonItem(customView: leftStackView)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
