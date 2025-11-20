//
//  SearchWithIngridientsTableViewController.swift
//  HuongDanNauAn
//

import UIKit

class SearchWithIngridientsTableViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var filteredRecipes: [Recipe] = []   // Mảng lưu kết quả tìm kiếm
    var isSearching = false               // Cờ đánh dấu đang tìm kiếm
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
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
    }
    
    // MARK: - Search Button Action
    @IBAction func SearchBtn(_ sender: Any) {
        performSearch()
    }
    
    // MARK: - Search Function
    private func performSearch() {
        
        // Lấy keyword và trim khoảng trắng
        guard let keyword = SearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !keyword.isEmpty else {
            showAlert("Vui lòng nhập nguyên liệu.")
            return
        }
        
        SearchBar.resignFirstResponder() // Ẩn bàn phím
        showLoading()
        
        // Tách nhiều nguyên liệu
        let ingredients = keyword
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Chỉ tìm kiếm theo nhiều nguyên liệu
            let results: [Recipe] = DatabaseManager.shared.searchRecipesByIngredients(ingredients)
            
            DispatchQueue.main.async {
                self.hideLoading()
                self.isSearching = true
                self.filteredRecipes = results
                self.updateUI()
                
                if results.isEmpty {
                    self.showAlert("Không tìm thấy món ăn với nguyên liệu '\(keyword)'")
                }
            }
        }
    }
    
    // MARK: - Update UI
    private func updateUI() {
        tableView.reloadData()
        
        if filteredRecipes.isEmpty && isSearching {
            tableView.isHidden = true
        } else if filteredRecipes.isEmpty && !isSearching {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }
    }
    
    // MARK: - Alert Popup
    private func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "Thông báo", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Loading Indicator
    private func showLoading() {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.center = view.center
        indicator.tag = 999
        indicator.startAnimating()
        view.addSubview(indicator)
    }
    
    private func hideLoading() {
        (view.viewWithTag(999) as? UIActivityIndicatorView)?.removeFromSuperview()
    }
    
    // MARK: - Setup SearchBar
    private func setupSearchBar() {
        SearchBar.delegate = self
        SearchBar.placeholder = "Nhập nguyên liệu (vd: thịt bò, tôm...)"
        SearchBar.searchBarStyle = .minimal
        
        if let textField = SearchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .systemGray6
            textField.layer.cornerRadius = 10
            textField.clipsToBounds = true
        }
    }
    
    // MARK: - Setup TableView
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
        tableView.estimatedRowHeight = 110
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGroupedBackground
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0) // Padding trên dưới
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
    }
}

// MARK: - UISearchBar Delegate
extension SearchWithIngridientsTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredRecipes = []
            updateUI()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        isSearching = false
        filteredRecipes = []
        updateUI()
    }
}

// MARK: - UITableView Delegate & DataSource
extension SearchWithIngridientsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as! RecipeTableCell
        let recipe = filteredRecipes[indexPath.row]
        cell.configure(with: recipe) // bind dữ liệu vào cell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Bỏ chọn dòng
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRecipe = filteredRecipes[indexPath.row]
        
        // Chuyển sang màn hình Chi Tiết (RecipeDetailViewController)
        let detailVC = RecipeDetailViewController()
        detailVC.recipe = selectedRecipe
        
        // Push Navigation
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

