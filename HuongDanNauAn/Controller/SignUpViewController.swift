import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ẩn back button nếu muốn
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        // Set delegate cho tất cả TextField
        [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField].forEach {
            $0?.delegate = self
        }
        
        // Return key type
        nameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        confirmPasswordTextField.returnKeyType = .done
        
        // Kiểu bàn phím & autocapitalization
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.autocorrectionType = .no
    }

    // MARK: - UITextFieldDelegate: Next / Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            textField.resignFirstResponder()
            // Tự động gọi đăng ký khi nhấn Done ở confirm password
            registerTap(self) 
        default:
            textField.resignFirstResponder()
        }
        return true
    }

    // Tap ngoài ẩn bàn phím
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func registerTap(_ sender: Any) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""
        let confirm = confirmPasswordTextField.text ?? ""

        // Kiểm tra hợp lệ
        if name.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty {
            showAlert(message: "Vui lòng nhập đầy đủ thông tin.")
            return
        }

        if !isValidEmail(email) {
            showAlert(message: "Email không hợp lệ.")
            return
        }

        if password.count < 6 {
            showAlert(message: "Mật khẩu phải có ít nhất 6 ký tự.")
            return
        }

        if password != confirm {
            showAlert(message: "Mật khẩu và xác nhận mật khẩu không khớp.")
            return
        }

        // Kiểm tra email đã đăng ký chưa
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail")
        if savedEmail == email {
            showAlert(message: "Email này đã được sử dụng rồi.")
            return
        }

        // Lưu vào UserDefaults
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
        UserDefaults.standard.set(name, forKey: "userName")

        // Thông báo thành công và reset form
        let alert = UIAlertController(title: "Thành công", message: "Đăng ký thành công! Hãy đăng nhập lại.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Clear các field
            self.nameTextField.text = ""
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
            self.confirmPasswordTextField.text = ""
            
            // Quay về Login
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Helpers
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
}
