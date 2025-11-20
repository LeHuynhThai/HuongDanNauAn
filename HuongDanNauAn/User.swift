import Foundation

class User {
    // Thuộc tính
    let userId: Int64
    let userName: String
    let emailAddress: String
    let password: String
    var userImage: String?
    let createdAt: Date
    var updatedAt: Date

    // Computed property tiện lợi để định dạng ngày tạo
    var formattedCreatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: createdAt)
    }
    
    // Computed property tiện lợi để định dạng ngày cập nhật
    var formattedUpdatedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: updatedAt)
    }
    
    // Hàm khởi tạo
    init(userId: Int64 = 0,
         userName: String = "",
         emailAddress: String = "",
         password: String = "",
         userImage: String? = nil,
         createdAt: Date = Date(),
         updatedAt: Date = Date()) {
        self.userId = userId
        self.userName = userName
        self.emailAddress = emailAddress
        self.password = password
        self.userImage = userImage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

