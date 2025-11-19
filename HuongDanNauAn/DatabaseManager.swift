import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: Connection?

    private let users = Table("users")
    private let id = Expression<Int64>("id")
    private let name = Expression<String>("name")
    private let email = Expression<String>("email")
    private let password = Expression<String>("password") // plaintext, debug only

    private init() {
        do {
            let fileUrl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("AccCount.sqlite3")
            db = try Connection(fileUrl.path)
            createTable()
            print("Database lưu ở: \(fileUrl.path)")
        } catch {
            print("Không tạo được database: \(error)")
        }
    }

    private func createTable() {
        do {
            try db?.run(users.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name)
                t.column(email, unique: true, collate: .nocase)
                t.column(password)
            })
        } catch {
            print("Không tạo được table: \(error)")
        }
    }

    func addUser(name: String, email: String, password: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        if isEmailExist(trimmedEmail) {
            print("Email đã tồn tại")
            return false
        }

        do {
            let insert = users.insert(
                self.name <- name,
                self.email <- trimmedEmail,
                self.password <- trimmedPassword
            )
            try db?.run(insert)
            print("Đã thêm user: \(name) - \(email)")
            return true
        } catch {
            print("Lỗi khi thêm user: \(error)")
            return false
        }
    }

    func login(email: String, password: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            let query = users.filter(email == trimmedEmail && self.password == trimmedPassword)
            let count = try db?.scalar(query.count) ?? 0
            return count > 0
        } catch {
            print("Lỗi login: \(error)")
            return false
        }
    }

    func isEmailExist(_ emailToCheck: String) -> Bool {
        let trimmedEmail = emailToCheck.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let query = users.filter(email == trimmedEmail)
            let count = try db?.scalar(query.count) ?? 0
            return count > 0
        } catch {
            print("Lỗi kiểm tra email: \(error)")
            return false
        }
    }

    // ===========================================
    // Hàm debug toàn bộ database ra console
    // ===========================================
    func debugDatabase() {
        do {
            // In đường dẫn file
            let fileUrl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("AccCount.sqlite3")
            print("===== Debug Database =====")
            print("Đường dẫn database: \(fileUrl.path)\n")

            // In tất cả user
            if let rows = try db?.prepare(users) {
                print("----- Danh sách user -----")
                for row in rows {
                    print("ID: \(row[id]), Name: \(row[name]), Email: \(row[email]), Password: \(row[password])")
                }
                print("----- Kết thúc danh sách -----\n")
            } else {
                print("Chưa có user nào trong database.\n")
            }
        } catch {
            print("Lỗi debug database: \(error)")
        }
    }
}
