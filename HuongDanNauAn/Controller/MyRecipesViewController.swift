//
//  MyRecipesViewController.swift
//  HuongDanNauAn
//

import UIKit

class MyRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI Elements
    let tableView = UITableView()
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
        view.backgroundColor = .systemBackground
        overrideUserInterfaceStyle = .light

        setupNavigationBar()
        setupTableView()
        setupFloatingButton()
        loadRecipes()
        
        NotificationCenter.default.addObserver(self,
                           selector: #selector(reloadRecipes),
                           name: NSNotification.Name("DidAddNewRecipe"),
                           object: nil)
    }
    
    @objc func reloadRecipes() {
        loadRecipes()
    }

    // MARK: - Navigation Bar
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

    // MARK: - TableView
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
        tableView.tableFooterView = UIView() // bỏ dòng trống

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Floating Button
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

    // MARK: - Load Recipes
    func loadRecipes() {
        // Tạm thời userId = 1
        recipes = DatabaseManager.shared.getRecipesByUser(1)

        // Sắp xếp theo tên công thức (A → Z)
        recipes.sort { $0.name.lowercased() < $1.name.lowercased() }

        tableView.reloadData()
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        let recipe = recipes[indexPath.row]
        cell.textLabel?.text = recipe.name
        cell.imageView?.image = nil

        // Load image từ Documents/recipe_images
        if let imageName = recipe.imageURL {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let imageURL = documentsURL.appendingPathComponent("recipe_images").appendingPathComponent(imageName)
            if let image = UIImage(contentsOfFile: imageURL.path) {
                cell.imageView?.image = image
            }
        }

        return cell
    }

    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: show recipe detail
    }
    
    // MARK: - Swipe to Delete
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Xóa") { [weak self] _, _, completionHandler in
            guard let self = self else { return }

            // Lấy recipe cần xoá
            let recipe = self.recipes[indexPath.row]

            // Xoá khỏi database
            let success = DatabaseManager.shared.deleteRecipe(id: recipe.recipeId)

            if success {
                // Xoá khỏi mảng local
                self.recipes.remove(at: indexPath.row)
                // Xoá row khỏi tableView với animation
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                // Thông báo lỗi
                let alert = UIAlertController(title: "Lỗi", message: "Không thể xoá công thức", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }

            completionHandler(true)
        }

        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
