import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        CollectionView.delegate = self
        CollectionView.delegate = self
        CollectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var images : [String] = ["1","2","3","4","5","6","7"]
    var name : [String] = ["mon 1", "mon 2", "mon 3","mon 4", "mon 5", "mon 6", "mon 7"]
    
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
        
        // AVATAR
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
        
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        navigationItem.rightBarButtonItem = profileBarButton
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return name.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
        cell.RecipeName.text = name[indexPath.row]
        cell.RecipeImageView.image = UIImage(named: images[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-10)/2
        return CGSize(width: size, height: size)
    }
}
