import Foundation

struct Session {

    private enum Keys {
        static let currentUserId = "currentUserId"
    }

    // Lấy userId hiện tại
    static var currentUserId: Int64? {
        get {
            return UserDefaults.standard.object(forKey: Keys.currentUserId) as? Int64
        }
        set {
            if let id = newValue {
                UserDefaults.standard.set(id, forKey: Keys.currentUserId)
            } else {
                UserDefaults.standard.removeObject(forKey: Keys.currentUserId)
            }
        }
    }

    // Xóa session khi logout
    static func clear() {
        UserDefaults.standard.removeObject(forKey: Keys.currentUserId)
    }
}

