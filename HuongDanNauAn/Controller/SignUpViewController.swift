import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        let fields = [nameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        fields.forEach { $0?.delegate = self }

        nameTextField.returnKeyType = .next
        emailTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        confirmPasswordTextField.returnKeyType = .done

        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.isSecureTextEntry = false

        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no

        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.autocapitalizationType = .none
        confirmPasswordTextField.autocorrectionType = .no
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField: emailTextField.becomeFirstResponder()
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            textField.resignFirstResponder()
            registerTap(self)
        default: textField.resignFirstResponder()
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    @IBAction func registerTap(_ sender: Any) {
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let confirm = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

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

        if !DatabaseManager.shared.addUser(userName: name, emailAddress: email, password: password) {
            showAlert(message: "Email đã tồn tại hoặc lỗi hệ thống.")
            return
        }

        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""

        showAlert(message: "Đăng ký thành công!") {
            self.navigationController?.popViewController(animated: true)
        }
    }

    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }

    func isValidEmail(_ email: String) -> Bool {
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }

    @IBAction func loginBtnTapped(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
}
