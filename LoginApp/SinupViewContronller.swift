import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
    }

    // Nút "Đăng ký"
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

        // Kiểm tra định dạng email cơ bản (nếu cần)
        if !isValidEmail(email) {
            showAlert(message: "Email không hợp lệ.")
            return
        }

        // Kiểm tra độ dài mật khẩu (ví dụ tối thiểu 6 ký tự)
        if password.count < 6 {
            showAlert(message: "Mật khẩu phải có ít nhất 6 ký tự.")
            return
        }

        // Kiểm tra khớp confirm password
        if password != confirm {
            showAlert(message: "Mật khẩu và xác nhận mật khẩu không khớp.")
            return
        }

        // Lưu tài khoản (ví dụ dùng UserDefaults)
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
        UserDefaults.standard.set(name, forKey: "userName")

        // Thông báo thành công
        let alert = UIAlertController(title: "Thành công", message: "Đăng ký thành công! Hãy đăng nhập lại.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Tự động quay về màn hình Login
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }

    // Nút "Login" để quay lại màn hình đăng nhập (nếu bạn vẫn giữ nút này)
    @IBAction func loginBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    // Hàm hiển thị alert chung
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // Hàm kiểm tra email cơ bản
    func isValidEmail(_ email: String) -> Bool {
        // Một regex đơn giản, đủ cho test; bạn có thể thay bằng regex chặt hơn nếu cần
        let pattern = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: email)
    }
}
