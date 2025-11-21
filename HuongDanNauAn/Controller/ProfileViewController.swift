//
//  ProfileViewController.swift
//  HuongDanNauAn
//
//  Created by admin on 15/11/2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var LogoutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Gắn action cho nút Logout
        LogoutBtn.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - LOGOUT ACTION
    
    @objc func logoutButtonTapped() {
        
        // Hiển thị alert xác nhận
        let alert = UIAlertController(
            title: "Đăng xuất",
            message: "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?",
            preferredStyle: .alert
        )
        
        // Thêm nút Hủy
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        
        // Thêm nút Đăng xuất và xử lý logic
        alert.addAction(UIAlertAction(title: "Đăng xuất", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    private func performLogout() {
        // 1. Xóa thông tin session (currentUserId)
        Session.clear()
        
        // 2. Chuyển hướng về màn hình đăng nhập (hoặc màn hình root ban đầu)
        navigateToLoginScreen()
    }
    
    // MARK: - NAVIGATION
    
    private func navigateToLoginScreen() {
        
        // Khởi tạo màn hình đăng nhập/đăng ký (thường là Root View Controller)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Thay "LoginNav" bằng ID của ViewController hoặc NavigationController chứa màn hình Login
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewContronller.swift") as? UIViewController else {
            print("Lỗi: Không tìm thấy Login View Controller. Kiểm tra Storyboard ID.")
            return
        }
        
        // Đặt Login VC làm Root View Controller mới
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = loginVC
            
            // Thêm animation chuyển đổi màn hình
            UIView.transition(with: sceneDelegate.window!,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
    
    func setupNavigationBar() {
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
