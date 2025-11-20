//
//  MyRecipesViewController.swift
//  HuongDanNauAn
//
//  Created by admin on 15/11/2025.
//

import UIKit

class MyRecipesViewController: UIViewController {

    // MARK: - 1. KẾT NỐI GIAO DIỆN (IBOutlets)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnCreated: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    // MARK: - 2. BIẾN DỮ LIỆU
    var recipes: [Recipe] = []           // Dữ liệu gốc từ DB
    var displayedRecipes: [Recipe] = []  // Dữ liệu đang hiển thị (sau khi search/filter)
    
    var currentUserId: Int64 = 1         // Giả định User ID hiện tại là 1
    var currentTab: String = "ALL"       // Tab hiện tại: "ALL", "CREATED", "FAVORITE"

    // MARK: - 3. CODE CŨ CỦA BẠN (Floating Button)
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
        return button
    }()
    
    // MARK: - 4. VÒNG ĐỜI (Life Cycle)
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        setupNavigationBar()     // Code cũ của bạn
        setupFloatingButton()    // Code cũ của bạn
        setupCollectionView()    // Code mới: Cấu hình lưới ảnh
        
        // Search Bar
        if let searchBar = searchBar {
            searchBar.delegate = self
        }
        
        // Mặc định load tab Tất cả
        didTapAll(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load lại dữ liệu mỗi khi quay lại màn hình này
        refreshCurrentTab()
    }
    
    // MARK: - 5. SETUP UI & DATA
    func setupCollectionView() {
        guard let cv = collectionView else { return }
        cv.delegate = self
        cv.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 12, bottom: 80, right: 12) // Bottom 80 để tránh nút cộng che mất
        cv.collectionViewLayout = layout
    }
    
    func updateButtonStyles(selectedBtn: UIButton?) {
        // Reset màu 3 nút về xám
        let buttons = [btnAll, btnCreated, btnFavorite]
        for btn in buttons {
            btn?.backgroundColor = .systemGray6
            btn?.setTitleColor(.black, for: .normal)
        }
        
        // Set màu nút đang chọn thành Xanh
        selectedBtn?.backgroundColor = .systemBlue
        selectedBtn?.setTitleColor(.white, for: .normal)
    }
    
    // Logic lấy dữ liệu
    func refreshCurrentTab() {
        if currentTab == "ALL" { loadAllRecipes() }
        else if currentTab == "CREATED" { loadCreatedRecipes() }
        else if currentTab == "FAVORITE" { loadFavoriteRecipes() }
    }
    
    func loadAllRecipes() {
        recipes = DatabaseManager.shared.getAllRecipes()
        finalizeDataLoad()
    }
    
    func loadCreatedRecipes() {
        recipes = DatabaseManager.shared.getRecipesByUser(currentUserId)
        finalizeDataLoad()
    }
    
    func loadFavoriteRecipes() {
        let favoriteList = DatabaseManager.shared.getFavoritesByUser(currentUserId)
        var tempRecipes: [Recipe] = []
        for fav in favoriteList {
            if let recipe = DatabaseManager.shared.getRecipe(byID: fav.recipeId) {
                tempRecipes.append(recipe)
            }
        }
        recipes = tempRecipes
        finalizeDataLoad()
    }
    
    func finalizeDataLoad() {
        // Nếu đang tìm kiếm thì lọc lại, nếu không thì hiện hết
        if let searchText = searchBar?.text, !searchText.isEmpty {
            displayedRecipes = recipes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            displayedRecipes = recipes
        }
        collectionView?.reloadData()
    }

    // MARK: - 6. ACTIONS (Sự kiện bấm nút lọc)
    
    @IBAction func didTapAll(_ sender: Any) {
        currentTab = "ALL"
        updateButtonStyles(selectedBtn: btnAll)
        loadAllRecipes()
    }
    
    @IBAction func didTapCreated(_ sender: Any) {
        currentTab = "CREATED"
        updateButtonStyles(selectedBtn: btnCreated)
        loadCreatedRecipes()
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        currentTab = "FAVORITE"
        updateButtonStyles(selectedBtn: btnFavorite)
        loadFavoriteRecipes()
    }
    
    // MARK: - 7. Nav & Floating Button
    func setupNavigationBar() {
        let leftStackView = UIStackView()
        leftStackView.axis = .horizontal
        leftStackView.spacing = 8
        leftStackView.alignment = .center
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftStackView)
        
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
    
    func setupFloatingButton() {
        view.addSubview(floatingButton)
        floatingButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            floatingButton.widthAnchor.constraint(equalToConstant: 60),
            floatingButton.heightAnchor.constraint(equalToConstant: 60),
            floatingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20) // Chỉnh lại một chút cho đẹp
        ])
        
        floatingButton.layer.cornerRadius = 30
        floatingButton.clipsToBounds = false
    }
    
    @objc func addButtonTapped() {
        // Gọi Segue sang màn hình Thêm công thức (nếu bạn đã vẽ)
        // performSegue(withIdentifier: "showAddRecipe", sender: self)
        print("Đã bấm nút thêm món!")
    }
}

// MARK: - EXTENSIONS: COLLECTIONVIEW & SEARCHBAR

extension MyRecipesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Vẫn dùng RecipeCell như trang Home
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! RecipeCell
        let recipe = displayedRecipes[indexPath.row]
        
        cell.RecipeName.text = recipe.name
        cell.RecipeTime.text = "\(recipe.cookTime ?? 0) phút"
        cell.RecipeDifficulty.text = recipe.difficulty.rawValue
        
        if let imageURL = recipe.imageURL, !imageURL.isEmpty {
            cell.RecipeImageView.image = UIImage(named: imageURL) ?? UIImage(named: "pho_bo")
        } else {
            cell.RecipeImageView.image = UIImage(named: "pho_bo")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 12
        let spacing: CGFloat = 12
        let totalSpacing = padding * 2 + spacing
        let width = (collectionView.frame.width - totalSpacing) / 2
        let imageHeight = width
        let textHeight: CGFloat = 88
        
        return CGSize(width: width, height: imageHeight + textHeight)
    }
    
    // Bấm vào món ăn -> Chuyển sang Detail
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedRecipe = displayedRecipes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as? RecipeDetailViewController {
            detailVC.recipeId = selectedRecipe.recipeId
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension MyRecipesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            displayedRecipes = recipes
        } else {
            displayedRecipes = recipes.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
