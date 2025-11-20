import Foundation
import SQLite

extension DatabaseManager {

    // MARK: - Check Email Exist
    func isEmailExist(_ emailToCheck: String) -> Bool {
        let trimmedEmail = emailToCheck.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let query = users.filter(emailAddress == trimmedEmail)
            let count = try db?.scalar(query.count) ?? 0
            return count > 0
        } catch {
            print("❌ Lỗi kiểm tra email: \(error)")
            return false
        }
    }

    // MARK: - Add User
    func addUser(userName: String, emailAddress: String, password: String, userImage: String? = nil) -> Bool {
        let trimmedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if isEmailExist(trimmedEmail) {
            print("⚠️ Email đã tồn tại")
            return false
        }

        do {
            // ✅ SỬA LỖI: Lấy ngày giờ dạng String
            let dateString = getCurrentDateString()
            
            let insert = users.insert(
                self.userName <- userName,
                self.emailAddress <- trimmedEmail,
                self.password <- trimmedPassword,
                self.userImage <- userImage,
                self.createdAt <- dateString, // <-- Truyền String
                self.updatedAt <- dateString  // <-- Truyền String
            )
            try db?.run(insert)
            return true
        } catch {
            print("❌ Lỗi khi thêm user: \(error)")
            return false
        }
    }

    // MARK: - Login
    func login(emailAddress: String, password: String) -> Bool {
        let trimmedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            // Query khớp cả email và password
            let query = users.filter(self.emailAddress == trimmedEmail && self.password == trimmedPassword)
            let count = try db?.scalar(query.count) ?? 0
            return count > 0
        } catch {
            print("❌ Lỗi login: \(error)")
            return false
        }
    }

    // MARK: - Get All Users (Emails)
    func getAllUsers() -> [String] {
        var list: [String] = []
        do {
            if let rows = try db?.prepare(users) {
                for row in rows {
                    list.append(row[emailAddress])
                }
            }
        } catch {
            print("❌ Lỗi lấy users: \(error)")
        }
        return list
    }

    // MARK: - Print All Users (Debug)
    func printAllUsers() {
        do {
            if let rows = try db?.prepare(users) {
                print("===== Danh sách người dùng =====")
                for row in rows {
                    // Lưu ý: Mật khẩu nên bảo mật, đây chỉ là in để test
                    print("ID: \(row[userId]), Name: \(row[userName]), Email: \(row[emailAddress]), Created: \(row[createdAt])")
                }
                print("===== Kết thúc danh sách =====")
            }
        } catch {
            print("❌ Lỗi in users: \(error)")
        }
    }
}
