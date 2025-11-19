import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    var images: [String] = ["1","2","3","4","5","6","7"]
        var names: [String] = ["mon 1", "mon 2", "mon 3","mon 4", "mon 5", "mon 6", "mon 7"]

        override func viewDidLoad() {
            super.viewDidLoad()
            overrideUserInterfaceStyle = .light
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.collectionViewLayout = UICollectionViewFlowLayout()

            searchBar.delegate = self

            setupNavigationBar()
        }

        func setupNavigationBar() {
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

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "showSearchResults",
               let destination = segue.destination as? SearchResultViewController,
               let searchText = sender as? String {
                // Lọc dữ liệu đơn giản theo searchText
                let filteredNames = names.filter { $0.lowercased().contains(searchText.lowercased()) }
                destination.searchResults = filteredNames
            }
        }
    }

    extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return names.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
            cell.RecipeName.text = names[indexPath.row]
            cell.RecipeImageView.image = UIImage(named: images[indexPath.row])
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = (collectionView.frame.width - 10) / 2
            return CGSize(width: size, height: size)
        }
    }

    extension HomeViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            performSegue(withIdentifier: "showSearchResults", sender: searchBar.text ?? "")
        }
    }
