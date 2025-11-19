import Foundation
import SQLite

extension DatabaseManager {

    func isEmailExist(_ emailToCheck: String) -> Bool {
        let trimmedEmail = emailToCheck.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let query = users.filter(emailAddress == trimmedEmail)
            let count = try db?.scalar(query.count) ?? 0
            return count > 0
        } catch {
            print("Lỗi kiểm tra email: \(error)")
            return false
        }
    }

    func addUser(userName: String, emailAddress: String, password: String, userImage: String? = nil) -> Bool {
        let trimmedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if isEmailExist(trimmedEmail) {
            print("Email đã tồn tại")
            return false
        }

        do {
            let insert = users.insert(
                self.userName <- userName,
                self.emailAddress <- trimmedEmail,
                self.password <- trimmedPassword,
                self.userImage <- userImage,
                self.createdAt <- Date(),
                self.updatedAt <- Date()
            )
            try db?.run(insert)
            return true
        } catch {
            print("Lỗi khi thêm user: \(error)")
            return false
        }
    }

    func login(emailAddress: String, password: String) -> Bool {
        let trimmedEmail = emailAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            let query = users.filter(self.emailAddress == trimmedEmail && self.password == trimmedPassword)
            let count = try db?.scalar(query.count) ?? 0
            return count > 0
        } catch {
            print("Lỗi login: \(error)")
            return false
        }
    }

    func getAllUsers() -> [String] {
        var list: [String] = []
        do {
            if let rows = try db?.prepare(users) {
                for row in rows {
                    list.append(row[emailAddress])
                }
            }
        } catch {
            print("Lỗi lấy users: \(error)")
        }
        return list
    }

    func printAllUsers() {
        do {
            if let rows = try db?.prepare(users) {
                print("===== Danh sách người dùng =====")
                for row in rows {
                    print("ID: \(row[userId]), Name: \(row[userName]), Email: \(row[emailAddress]), Password: \(row[password])")
                }
                print("===== Kết thúc danh sách =====")
            }
        } catch {
            print("Lỗi lấy users: \(error)")
        }
    }
}

