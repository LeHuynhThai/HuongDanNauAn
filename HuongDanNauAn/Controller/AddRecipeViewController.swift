//
//  AddRecipeViewController.swift
//  HuongDanNauAn
//
//  Created by admin on 15/11/2025.
//

import UIKit

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: - UI Elements
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let recipeImageView = UIImageView()
    let nameTextField = UITextField()
    let descriptionTextView = UITextView()
    let timeTextField = UITextField()
    let levelSegmented = UISegmentedControl(items: ["Dễ","Trung bình","Khó"])
    let ingredientsTextView = UITextView()
    let instructionsTextView = UITextView()
    let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
        setupKeyboardObservers()
        overrideUserInterfaceStyle = .light
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
    
    // MARK: - Setup UI
    func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Recipe Image
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.backgroundColor = .systemGray5
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 12
        recipeImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        recipeImageView.addGestureRecognizer(tapGesture)
        contentView.addSubview(recipeImageView)
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            recipeImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            recipeImageView.widthAnchor.constraint(equalToConstant: 150),
            recipeImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Name TextField
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Tên công thức"
        nameTextField.borderStyle = .roundedRect
        contentView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Description
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.delegate = self
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.systemGray4.cgColor
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.text = "Mô tả..."
        descriptionTextView.textColor = .placeholderText
        contentView.addSubview(descriptionTextView)
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // Time TextField
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.placeholder = "Thời gian (phút)"
        timeTextField.keyboardType = .numberPad
        timeTextField.borderStyle = .roundedRect
        contentView.addSubview(timeTextField)
        
        // Level Segmented
        levelSegmented.translatesAutoresizingMaskIntoConstraints = false
        levelSegmented.selectedSegmentIndex = 0
        contentView.addSubview(levelSegmented)
        
        NSLayoutConstraint.activate([
            timeTextField.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            timeTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            timeTextField.widthAnchor.constraint(equalToConstant: 120),
            timeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            levelSegmented.centerYAnchor.constraint(equalTo: timeTextField.centerYAnchor),
            levelSegmented.leadingAnchor.constraint(equalTo: timeTextField.trailingAnchor, constant: 16),
            levelSegmented.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor)
        ])
        
        // Ingredients TextView
        ingredientsTextView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTextView.delegate = self
        ingredientsTextView.layer.borderWidth = 0.5
        ingredientsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        ingredientsTextView.layer.cornerRadius = 8
        ingredientsTextView.font = .systemFont(ofSize: 16)
        ingredientsTextView.text = "Nguyên liệu..."
        ingredientsTextView.textColor = .placeholderText
        contentView.addSubview(ingredientsTextView)
        NSLayoutConstraint.activate([
            ingredientsTextView.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 16),
            ingredientsTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            ingredientsTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            ingredientsTextView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // Instructions TextView
        instructionsTextView.translatesAutoresizingMaskIntoConstraints = false
        instructionsTextView.delegate = self
        instructionsTextView.layer.borderWidth = 0.5
        instructionsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        instructionsTextView.layer.cornerRadius = 8
        instructionsTextView.font = .systemFont(ofSize: 16)
        instructionsTextView.text = "Hướng dẫn..."
        instructionsTextView.textColor = .placeholderText
        contentView.addSubview(instructionsTextView)
        NSLayoutConstraint.activate([
            instructionsTextView.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: 16),
            instructionsTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            instructionsTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            instructionsTextView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // Save Button
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Lưu công thức", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 12
        saveButton.addTarget(self, action: #selector(saveRecipe), for: .touchUpInside)
        contentView.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: instructionsTextView.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    // MARK: - Image Picker
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selected = info[.originalImage] as? UIImage {
            recipeImageView.image = selected
        }
        picker.dismiss(animated: true)
    }
    
    // MARK: - Save Recipe
    @objc func saveRecipe() {
        // Lấy dữ liệu từ các field
        let name = nameTextField.text ?? ""
        let ingredients = ingredientsTextView.textColor == .placeholderText ? "" : ingredientsTextView.text ?? ""
        let instructions = instructionsTextView.textColor == .placeholderText ? "" : instructionsTextView.text ?? ""
        let cookTime = Int(timeTextField.text ?? "0")
        let difficulty: Recipe.Difficulty
        switch levelSegmented.selectedSegmentIndex {
        case 0: difficulty = .easy
        case 1: difficulty = .medium
        case 2: difficulty = .hard
        default: difficulty = .medium
        }
        
        guard let image = recipeImageView.image else {
            let alert = UIAlertController(title: "Thiếu ảnh",
                                          message: "Vui lòng chọn một ảnh món ăn",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        guard let imageFileName = saveImageToDocuments(image) else {
            let alert = UIAlertController(title: "Lỗi ảnh",
                                          message: "Không thể lưu ảnh",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // Kiểm tra dữ liệu cơ bản
        if name.isEmpty || ingredients.isEmpty || instructions.isEmpty {
            let alert = UIAlertController(title: "Lỗi", message: "Vui lòng điền đầy đủ thông tin", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // Tạm thời set userId = 1
        let userId: Int64 = 1

        // Thêm recipe vào database
        let success = DatabaseManager.shared.addRecipe(
            name: name,
            ingredients: ingredients.components(separatedBy: "\n"),
            instructions: instructions.components(separatedBy: "\n"),
            userId: userId,
            cookTime: cookTime,
            difficulty: difficulty,
            imageURL: imageFileName
        )

        if success {
            print("Đã lưu công thức: \(name)")
            resetForm()
        } else {
            let alert = UIAlertController(title: "Lỗi", message: "Không thể lưu công thức", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    func saveImageToDocuments(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }

        // Tạo tên file
        let filename = "recipe_\(UUID().uuidString).jpg"

        // Thư mục Documents/recipe_images
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagesFolderURL = documentsURL.appendingPathComponent("recipe_images")

        // Nếu thư mục chưa tồn tại thì tạo
        if !fileManager.fileExists(atPath: imagesFolderURL.path) {
            do {
                try fileManager.createDirectory(at: imagesFolderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Lỗi tạo thư mục recipe_images: \(error)")
                return nil
            }
        }

        // Đường dẫn file ảnh
        let fileURL = imagesFolderURL.appendingPathComponent(filename)

        do {
            try data.write(to: fileURL)
            return filename // lưu tên file vào database, khi load sẽ nối path với imagesFolderURL
        } catch {
            print("Lỗi lưu ảnh: \(error)")
            return nil
        }
    }

    
    func resetForm() {
        nameTextField.text = ""
        timeTextField.text = ""
        levelSegmented.selectedSegmentIndex = 0
        recipeImageView.image = nil
        
        ingredientsTextView.text = "Nguyên liệu..."
        ingredientsTextView.textColor = .placeholderText
        
        instructionsTextView.text = "Hướng dẫn..."
        instructionsTextView.textColor = .placeholderText
    }
    
    
    // MARK: - Placeholder logic cho UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == descriptionTextView { textView.text = "Mô tả..." }
            else if textView == ingredientsTextView { textView.text = "Nguyên liệu..." }
            else if textView == instructionsTextView { textView.text = "Hướng dẫn..." }
            textView.textColor = .placeholderText
        }
    }
    
    // MARK: - Keyboard Handling
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            scrollView.contentInset.bottom = frame.height + 20
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}
