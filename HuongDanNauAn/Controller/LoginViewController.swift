import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // --- Email TextField ---
           emailTextField.delegate = self
           emailTextField.keyboardType = .emailAddress   // bàn phím kiểu email
           emailTextField.autocapitalizationType = .none
           emailTextField.returnKeyType = .next
           emailTextField.isSecureTextEntry = false     // Hiển thị bình thường
           
           // --- Password TextField ---
           passwordTextField.delegate = self
           passwordTextField.isSecureTextEntry = true   // ẩn ký tự
           passwordTextField.autocapitalizationType = .none
           passwordTextField.returnKeyType = .done
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // -----------------------------
        // Bàn phím tự bật khi màn hình hiện
        // -----------------------------
        emailTextField.becomeFirstResponder()
    }

    // MARK: - Button Actions
    @IBAction func loginTap(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail")
        let savedPassword = UserDefaults.standard.string(forKey: "userPassword")
        
        if email.isEmpty || password.isEmpty {
            showAlert(message: "Vui lòng nhập đầy đủ thông tin.")
        } else if email == savedEmail && password == savedPassword {
            showAlert(message: "Đăng nhập thành công!") {
                self.goToHome()
            }
        } else {
            showAlert(message: "Sai email hoặc mật khẩu.")
        }
    }

    @IBAction func signUpTap(_ sender: Any) {
        if let signUpVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(signUpVC, animated: true)
        }
    }

    // -----------------------------
    // UITextFieldDelegate: Next / Done
    // -----------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder() // chuyển focus sang password
        } else {
            textField.resignFirstResponder() // ẩn bàn phím khi nhấn Done
        }
        return true
    }

    // -----------------------------
    // Ẩn bàn phím khi chạm ngoài
    // -----------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Helper
    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true)
    }

    func goToHome() {
        if let homeVC = storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            homeVC.modalPresentationStyle = .fullScreen
            present(homeVC, animated: true)
        }
    }

}


