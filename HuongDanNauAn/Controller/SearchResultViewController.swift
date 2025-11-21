//
//  SearchResultViewController.swift
//  HuongDanNauAn
//
import UIKit

class SearchResultViewController: UIViewController {

    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Types
       private typealias DataSource = UICollectionViewDiffableDataSource<Int, Int64> // section -> recipeId
       private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Int64>

       // MARK: - Properties
       private var recipes: [Int64: Recipe] = [:]
       private var currentRecipeIds: [Int64] = []

       private var dataSource: DataSource!
       private let cellIdentifier = "SearchResultCellProgrammatic"

       private let imageCache = NSCache<NSString, UIImage>()
       private var searchWorkItem: DispatchWorkItem?

       private let loadingIndicator = UIActivityIndicatorView(style: .large)

       // If Home passes a keyword
       var searchKeyword: String?

       // MARK: - Lifecycle
       override func viewDidLoad() {
           super.viewDidLoad()
           overrideUserInterfaceStyle = .light

           configureCollectionView()
           configureDataSource()
           configureSearchBar()
           configureLoadingIndicator()
           configureNotFoundLabel()

           // If a keyword was passed, start with it; otherwise show all
           performSearch(keyword: searchKeyword, animated: false)
       }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let totalSpacing = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing
        let itemWidth = floor((collectionView.bounds.width - totalSpacing) / 2)
        let itemHeight = itemWidth + 88
        
        // Cập nhật itemSize nếu khác hiện tại
        if layout.itemSize.width != itemWidth {
            layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            layout.invalidateLayout()
        }
    }

    // MARK: - Configuration
    private func configureCollectionView() {
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.delegate = self

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)

        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing: CGFloat = layout.sectionInset.left + layout.sectionInset.right + layout.minimumInteritemSpacing
        
        let itemWidth = floor((screenWidth - totalSpacing) / 2)
        let itemHeight = itemWidth + 88

        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.alwaysBounceVertical = true
    }

       private func configureDataSource() {
           dataSource = DataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, recipeId) -> UICollectionViewCell? in
               guard let self = self, let recipe = self.recipes[recipeId] else { return nil }
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! SearchResultCell
               cell.recipeNameLabel.text = recipe.name

               // Async load image with cache
               if let imageName = recipe.imageURL {
                   self.loadImage(name: imageName) { image in
                       DispatchQueue.main.async {
                           // cell may have been reused; double-check indexPath & recipe id
                           if let currentIndexPath = collectionView.indexPath(for: cell),
                              currentIndexPath == indexPath {
                               cell.recipeImageView.image = image ?? UIImage(named: "pho_bo")
                           }
                       }
                   }
               } else {
                   cell.recipeImageView.image = UIImage(named: "pho_bo")
               }

               // simple appear animation
               cell.alpha = 0
               UIView.animate(withDuration: 0.25, delay: 0.02 * Double(indexPath.row % 6), options: [.curveEaseOut], animations: {
                   cell.alpha = 1
               }, completion: nil)

               return cell
           }
       }

       private func configureSearchBar() {
           searchBar.delegate = self
           searchBar.placeholder = "Tìm công thức (ví dụ: phở bò)"
           searchBar.text = searchKeyword
           searchBar.searchBarStyle = .minimal
       }

       private func configureLoadingIndicator() {
           loadingIndicator.hidesWhenStopped = true
           loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(loadingIndicator)
           NSLayoutConstraint.activate([
               loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ])
       }

       private func configureNotFoundLabel() {
           notFoundLabel.text = "Không tìm thấy công thức nào."
           notFoundLabel.textAlignment = .center
           notFoundLabel.numberOfLines = 0
           notFoundLabel.isHidden = true
       }

       // MARK: - Search / Data loading

       /// Perform search with optional debounce and snapshot animation
       func performSearch(keyword: String?, animated: Bool = true) {
           // Cancel previous scheduled work (debounce)
           searchWorkItem?.cancel()

           // Create a new work item so rapid typing doesn't trigger many DB reads
           let work = DispatchWorkItem { [weak self] in
               guard let self = self else { return }
               DispatchQueue.main.async {
                   self.setLoading(true)
               }

               // Run DB work on background queue
               DispatchQueue.global(qos: .userInitiated).async {
                   let results: [Recipe]
                   if let kw = keyword?.trimmingCharacters(in: .whitespacesAndNewlines), !kw.isEmpty {
                       results = DatabaseManager.shared.searchRecipesByName(kw)
                   } else {
                       results = DatabaseManager.shared.getAllRecipes()
                   }

                   // Build maps for datasource (use recipeId as identifier)
                   var newMap: [Int64: Recipe] = [:]
                   let ids = results.map { recipe -> Int64 in
                       newMap[recipe.recipeId] = recipe
                       return recipe.recipeId
                   }

                   DispatchQueue.main.async {
                       self.recipes = newMap
                       self.currentRecipeIds = ids
                       self.applySnapshot(animated: animated)
                       self.setLoading(false)
                   }
               }
           }

           // Save and schedule with a small debounce (typing)
           searchWorkItem = work
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.28, execute: work)
       }

       private func applySnapshot(animated: Bool) {
           var snap = Snapshot()
           snap.appendSections([0])
           snap.appendItems(currentRecipeIds, toSection: 0)
           dataSource.apply(snap, animatingDifferences: animated)

           // Empty state
           notFoundLabel.isHidden = !currentRecipeIds.isEmpty
           collectionView.isHidden = currentRecipeIds.isEmpty
       }

       // MARK: - Loading UI
       private func setLoading(_ loading: Bool) {
           if loading {
               loadingIndicator.startAnimating()
               UIView.animate(withDuration: 0.15) { self.collectionView.alpha = 0.6 }
           } else {
               loadingIndicator.stopAnimating()
               UIView.animate(withDuration: 0.15) { self.collectionView.alpha = 1.0 }
           }
       }

       // MARK: - Image Loading & Cache

       /// Load image from Documents/recipe_images with caching (calls completion on background thread)
       private func loadImage(name: String, completion: @escaping (UIImage?) -> Void) {
           if let cached = imageCache.object(forKey: name as NSString) {
               completion(cached)
               return
           }

           DispatchQueue.global(qos: .userInitiated).async {
               let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
               let imageURL = documentsURL.appendingPathComponent("recipe_images").appendingPathComponent(name)
               let image = UIImage(contentsOfFile: imageURL.path)
               if let img = image {
                   self.imageCache.setObject(img, forKey: name as NSString)
               }
               completion(image)
           }
       }
   }

   // MARK: - UICollectionViewDelegate
   extension SearchResultViewController: UICollectionViewDelegate {
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           // Get selected recipe
           let recipeId = currentRecipeIds[indexPath.item]
           guard let recipe = recipes[recipeId] else { return }

           // Example action: print or push detail VC (you can implement push)
           print("Selected recipe: \(recipe.name) (id: \(recipe.recipeId))")

           // Optional: animate selection
           if let cell = collectionView.cellForItem(at: indexPath) {
               UIView.animate(withDuration: 0.08, animations: {
                   cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
               }, completion: { _ in
                   UIView.animate(withDuration: 0.12) {
                       cell.transform = .identity
                   }
               })
           }

           // TODO: navigate to detail VC (if you have one), e.g.:
           // let vc = RecipeDetailViewController(recipe: recipe)
           // navigationController?.pushViewController(vc, animated: true)
       }
   }

   // MARK: - UISearchBarDelegate
   extension SearchResultViewController: UISearchBarDelegate {
       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
           performSearch(keyword: searchBar.text)
       }

       func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           // Debounced live search while typing:
           performSearch(keyword: searchText)
       }

       func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
           searchBar.text = nil
           searchBar.resignFirstResponder()
           performSearch(keyword: nil)
       }
}
