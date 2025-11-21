import UIKit
import PhotosUI

class AddRecipeViewController: UIViewController, UITextViewDelegate {

    // MARK: - UI Elements
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let recipeImageView = UIImageView()
    let addImageLabel = UILabel()
    let nameTextField = UITextField()
    let timeTextField = UITextField()
    let levelSegmented = UISegmentedControl(items: ["Dễ","Trung bình","Khó"])
    let ingredientsTextView = UITextView()
    let instructionsTextView = UITextView()
    let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavigationBar()
        setupUI()
        setupKeyboardObservers()
        overrideUserInterfaceStyle = .light
        
        // Tap anywhere to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Navigation Bar
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        
        let leftStackView = UIStackView()
        leftStackView.axis = .horizontal
        leftStackView.spacing = 8
        leftStackView.alignment = .center
        
        // Nút Back
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .label
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let logoImageView = UIImageView(image: UIImage(named: "chef"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 32),
            logoImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        let titleLabel = UILabel()
        titleLabel.text = "Thêm công thức"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        
        leftStackView.addArrangedSubview(backButton)
        leftStackView.addArrangedSubview(logoImageView)
        leftStackView.addArrangedSubview(titleLabel)
        leftStackView.setCustomSpacing(16, after: backButton)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftStackView)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
        
        // Recipe Image Container
        let imageContainer = UIView()
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.backgroundColor = .white
        imageContainer.layer.cornerRadius = 12
        imageContainer.layer.shadowColor = UIColor.black.cgColor
        imageContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageContainer.layer.shadowRadius = 4
        imageContainer.layer.shadowOpacity = 0.1
        contentView.addSubview(imageContainer)
        
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
        recipeImageView.backgroundColor = .systemGray6
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 12
        recipeImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        recipeImageView.addGestureRecognizer(tapGesture)
        imageContainer.addSubview(recipeImageView)
        
        // Add Image Label
        addImageLabel.translatesAutoresizingMaskIntoConstraints = false
        addImageLabel.text = "📷 Chạm để thêm ảnh"
        addImageLabel.textAlignment = .center
        addImageLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addImageLabel.textColor = .secondaryLabel
        imageContainer.addSubview(addImageLabel)
        
        NSLayoutConstraint.activate([
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageContainer.heightAnchor.constraint(equalToConstant: 200),
            
            recipeImageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            recipeImageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            addImageLabel.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            addImageLabel.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
        ])
        
        // Name TextField
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Tên công thức *"
        nameTextField.borderStyle = .roundedRect
        nameTextField.backgroundColor = .white
        nameTextField.layer.cornerRadius = 8
        nameTextField.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(nameTextField)
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Time & Level Row
        let metaStackView = UIStackView()
        metaStackView.translatesAutoresizingMaskIntoConstraints = false
        metaStackView.axis = .horizontal
        metaStackView.spacing = 12
        metaStackView.distribution = .fillEqually
        contentView.addSubview(metaStackView)
        
        // Time TextField
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.placeholder = "Thời gian (phút) *"
        timeTextField.keyboardType = .numberPad
        timeTextField.borderStyle = .roundedRect
        timeTextField.backgroundColor = .white
        timeTextField.layer.cornerRadius = 8
        timeTextField.font = UIFont.systemFont(ofSize: 16)
        
        // Level Container
        let levelContainer = UIView()
        levelContainer.translatesAutoresizingMaskIntoConstraints = false
        
        levelSegmented.translatesAutoresizingMaskIntoConstraints = false
        levelSegmented.selectedSegmentIndex = 0
        levelContainer.addSubview(levelSegmented)
        
        metaStackView.addArrangedSubview(timeTextField)
        metaStackView.addArrangedSubview(levelContainer)
        
        NSLayoutConstraint.activate([
            metaStackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            metaStackView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            metaStackView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            metaStackView.heightAnchor.constraint(equalToConstant: 50),
            
            levelSegmented.centerYAnchor.constraint(equalTo: levelContainer.centerYAnchor),
            levelSegmented.leadingAnchor.constraint(equalTo: levelContainer.leadingAnchor),
            levelSegmented.trailingAnchor.constraint(equalTo: levelContainer.trailingAnchor)
        ])
        
        // Section Header: Nguyên liệu
        let ingredientsHeader = createSectionHeader(title: "Nguyên liệu *", subtitle: "Mỗi dòng là một nguyên liệu")
        contentView.addSubview(ingredientsHeader)
        
        // Ingredients TextView
        ingredientsTextView.translatesAutoresizingMaskIntoConstraints = false
        ingredientsTextView.delegate = self
        ingredientsTextView.layer.borderWidth = 0.5
        ingredientsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        ingredientsTextView.layer.cornerRadius = 8
        ingredientsTextView.font = .systemFont(ofSize: 16)
        ingredientsTextView.backgroundColor = .white
        ingredientsTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        ingredientsTextView.text = "Ví dụ:\n500g thịt heo\n2 củ hành tây\n3 muống canh nước mắm"
        ingredientsTextView.textColor = .placeholderText
        contentView.addSubview(ingredientsTextView)
        
        NSLayoutConstraint.activate([
            ingredientsHeader.topAnchor.constraint(equalTo: metaStackView.bottomAnchor, constant: 20),
            ingredientsHeader.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            ingredientsHeader.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            ingredientsTextView.topAnchor.constraint(equalTo: ingredientsHeader.bottomAnchor, constant: 8),
            ingredientsTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            ingredientsTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            ingredientsTextView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        // Section Header: Hướng dẫn
        let instructionsHeader = createSectionHeader(title: "Hướng dẫn nấu *", subtitle: "Mỗi dòng là một bước")
        contentView.addSubview(instructionsHeader)
        
        // Instructions TextView
        instructionsTextView.translatesAutoresizingMaskIntoConstraints = false
        instructionsTextView.delegate = self
        instructionsTextView.layer.borderWidth = 0.5
        instructionsTextView.layer.borderColor = UIColor.systemGray4.cgColor
        instructionsTextView.layer.cornerRadius = 8
        instructionsTextView.font = .systemFont(ofSize: 16)
        instructionsTextView.backgroundColor = .white
        instructionsTextView.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        instructionsTextView.text = "Ví dụ:\nRửa sạch thịt, cắt miếng vừa ăn\nÁp chảo với hành tây đến khi thơm\nThêm gia vị nêm nếm cho vừa khẩu vị"
        instructionsTextView.textColor = .placeholderText
        contentView.addSubview(instructionsTextView)
        
        NSLayoutConstraint.activate([
            instructionsHeader.topAnchor.constraint(equalTo: ingredientsTextView.bottomAnchor, constant: 20),
            instructionsHeader.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            instructionsHeader.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            
            instructionsTextView.topAnchor.constraint(equalTo: instructionsHeader.bottomAnchor, constant: 8),
            instructionsTextView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            instructionsTextView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            instructionsTextView.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        // Save Button
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Lưu công thức", for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.35, green: 0.78, blue: 0.35, alpha: 1.0)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        saveButton.layer.cornerRadius = 12
        saveButton.layer.shadowColor = UIColor.black.cgColor
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveButton.layer.shadowRadius = 4
        saveButton.layer.shadowOpacity = 0.2
        saveButton.addTarget(self, action: #selector(saveRecipe), for: .touchUpInside)
        contentView.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: instructionsTextView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 54),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    // MARK: - Helper: Create Section Header
    func createSectionHeader(title: String, subtitle: String) -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 2
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .label
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        
        return stack
    }
    
    @objc func selectImage() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Save Recipe
    @objc func saveRecipe() {
        // Validate all fields
        guard let userId = Session.currentUserId else {
            showAlert(title: "Lỗi", message: "Vui lòng đăng nhập để thêm công thức")
            return
        }
        
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let ingredientsText = ingredientsTextView.textColor == .placeholderText ? "" : ingredientsTextView.text ?? ""
        let instructionsText = instructionsTextView.textColor == .placeholderText ? "" : instructionsTextView.text ?? ""
        let timeText = timeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        // Validation
        if name.isEmpty {
            showAlert(title: "Thiếu thông tin", message: "Vui lòng nhập tên công thức")
            nameTextField.becomeFirstResponder()
            return
        }
        
        if timeText.isEmpty {
            showAlert(title: "Thiếu thông tin", message: "Vui lòng nhập thời gian nấu")
            timeTextField.becomeFirstResponder()
            return
        }
        
        guard let cookTime = Int(timeText), cookTime > 0 else {
            showAlert(title: "Lỗi", message: "Thời gian phải là số dương")
            timeTextField.becomeFirstResponder()
            return
        }
        
        guard let image = recipeImageView.image else {
            showAlert(title: "Thiếu ảnh", message: "Vui lòng chọn một ảnh món ăn")
            return
        }
        
        if ingredientsText.isEmpty {
            showAlert(title: "Thiếu thông tin", message: "Vui lòng nhập nguyên liệu")
            ingredientsTextView.becomeFirstResponder()
            return
        }
        
        if instructionsText.isEmpty {
            showAlert(title: "Thiếu thông tin", message: "Vui lòng nhập hướng dẫn nấu")
            instructionsTextView.becomeFirstResponder()
            return
        }
        
        // Get difficulty
        let difficulty: Recipe.Difficulty
        switch levelSegmented.selectedSegmentIndex {
        case 0: difficulty = .easy
        case 1: difficulty = .medium
        case 2: difficulty = .hard
        default: difficulty = .medium
        }
        
        // Save image
        guard let imageFileName = saveImageToDocuments(image) else {
            showAlert(title: "Lỗi", message: "Không thể lưu ảnh")
            return
        }
        
        // Parse ingredients and instructions
        let ingredients = ingredientsText.components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        let instructions = instructionsText.components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        // Show loading
        saveButton.isEnabled = false
        saveButton.setTitle("Đang lưu...", for: .normal)
        saveButton.alpha = 0.6
        
        // Save to database
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let success = DatabaseManager.shared.addRecipe(
                name: name,
                ingredients: ingredients,
                instructions: instructions,
                userId: userId,
                cookTime: cookTime,
                difficulty: difficulty,
                imageURL: imageFileName
            )
            
            DispatchQueue.main.async {
                self.saveButton.isEnabled = true
                self.saveButton.setTitle("Lưu công thức", for: .normal)
                self.saveButton.alpha = 1.0
                
                if success {
                    print("✅ Đã lưu công thức: \(name)")
                    self.showSuccessAndReset()
                } else {
                    self.showAlert(title: "Lỗi", message: "Không thể lưu công thức. Vui lòng thử lại.")
                }
            }
        }
    }
    
    func saveImageToDocuments(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }

        let filename = "recipe_\(UUID().uuidString).jpg"
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagesFolderURL = documentsURL.appendingPathComponent("recipe_images")

        if !fileManager.fileExists(atPath: imagesFolderURL.path) {
            do {
                try fileManager.createDirectory(at: imagesFolderURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Lỗi tạo thư mục recipe_images: \(error)")
                return nil
            }
        }

        let fileURL = imagesFolderURL.appendingPathComponent(filename)

        do {
            try data.write(to: fileURL)
            
            // --- ĐOẠN CODE ĐƯỢC THÊM VÀO ĐÂY ---
            print("Đã lưu ảnh thành công!")
            print("Đường dẫn file ảnh: \(fileURL.path)")
            // ------------------------------------
            
            return filename
        } catch {
            print("Lỗi lưu ảnh: \(error)")
            return nil
        }
    }
    
    func showSuccessAndReset() {
        let alert = UIAlertController(title: "Thành công! 🎉", message: "Công thức của bạn đã được lưu", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.resetForm()
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
    
    func resetForm() {
        nameTextField.text = ""
        timeTextField.text = ""
        levelSegmented.selectedSegmentIndex = 0
        recipeImageView.image = nil
        addImageLabel.isHidden = false

        ingredientsTextView.text = "Ví dụ:\n500g thịt heo\n2 củ hành tây\n3 muống canh nước mắm"
        ingredientsTextView.textColor = .placeholderText

        instructionsTextView.text = "Ví dụ:\nRửa sạch thịt, cắt miếng vừa ăn\nÁp chảo với hành tây đến khi thơm\nThêm gia vị nêm nếm cho vừa khẩu vị"
        instructionsTextView.textColor = .placeholderText

        NotificationCenter.default.post(name: NSNotification.Name("DidAddNewRecipe"), object: nil)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Placeholder logic cho UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if textView == ingredientsTextView {
                textView.text = "Ví dụ:\n500g thịt heo\n2 củ hành tây\n3 muống canh nước mắm"
            } else if textView == instructionsTextView {
                textView.text = "Ví dụ:\nRửa sạch thịt, cắt miếng vừa ăn\nÁp chảo với hành tây đến khi thơm\nThêm gia vị nêm nếm cho vừa khẩu vị"
            }
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
            scrollView.verticalScrollIndicatorInsets.bottom = frame.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AddRecipeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.recipeImageView.image = image
                    self?.addImageLabel.isHidden = true
                }
            }
        }
    }
}
