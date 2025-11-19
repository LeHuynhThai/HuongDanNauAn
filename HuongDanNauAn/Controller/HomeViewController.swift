import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        loadRecipes()
    }
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Mang chua danh sach recipes tu database
    var recipes: [Recipe] = []
    
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
    
    // lay tat ca recipe tu database
    func loadRecipes() {
        recipes = DatabaseManager.shared.getAllRecipes()
        CollectionView.reloadData()
        print("Đã load \(recipes.count) recipes")
    }
    
    func setupNavigationBar() {
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
        let recipe = recipes[indexPath.row]
        cell.RecipeName.text = recipe.name
        cell.RecipeTime.text = "\(recipe.cookTime ?? 0) phút"
        cell.RecipeDifficulty.text = recipe.difficulty.rawValue.uppercased()
        // Load hình ảnh từ Assets
        if let imageURL = recipe.imageURL {
            cell.RecipeImageView.image = UIImage(named: imageURL)
        } else {
            cell.RecipeImageView.image = UIImage(named: "pho_bo") // Hình mặc định
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 12  // Padding trái phải
        let spacing: CGFloat = 12  // Khoảng cách giữa 2 cột
        let totalSpacing = padding * 2 + spacing
        
        let width = (collectionView.frame.width - totalSpacing) / 2
        
        let imageHeight = width
        let textHeight: CGFloat = 44 + 20 + 20
        
        return CGSize(width: width, height: imageHeight + textHeight)
    }
}
