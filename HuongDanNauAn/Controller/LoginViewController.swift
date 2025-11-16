import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.returnKeyType = .next
        emailTextField.isSecureTextEntry = false

        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.returnKeyType = .done
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                emailTextField.text = ""
                passwordTextField.text = ""
    }

    @IBAction func loginTap(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        if email.isEmpty || password.isEmpty {
            showAlert(message: "Vui lòng nhập đầy đủ thông tin.")
        } else if DatabaseManager.shared.login(email: email, password: password) {
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginTap(self)
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in completion?() })
        present(alert, animated: true)
    }

    func goToHome() {
        if let tabBarVC = storyboard?.instantiateViewController(withIdentifier: "MainTabBarController") {
            tabBarVC.modalPresentationStyle = .fullScreen
            present(tabBarVC, animated: true)
        }
    }
}
