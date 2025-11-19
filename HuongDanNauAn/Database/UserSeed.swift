import Foundation

extension DatabaseManager {
    func seedUsers() {
        let sampleUsers: [(name: String, email: String, password: String, image: String?)] = [
            ("Nguyễn Văn An", "nguyenvanan@gmail.com", "123456", nil),
            ("Trần Thị Bình", "tranthibinh@gmail.com", "123456", nil),
            ("Lê Hoàng Cường", "lehoangcuong@gmail.com", "123456", nil),
            ("Phạm Thị Dung", "phamthidung@gmail.com", "123456", nil),
            ("Hoàng Văn Em", "hoangvanem@gmail.com", "123456", nil),
            ("Vũ Thị Phượng", "vuthiphuong@gmail.com", "123456", nil),
            ("Đặng Minh Giang", "dangminhgiang@gmail.com", "123456", nil),
            ("Bùi Thị Hà", "buithiha@gmail.com", "123456", nil),
            ("Ngô Văn Inh", "ngovaninh@gmail.com", "123456", nil),
            ("Đinh Thị Kim", "dinhthikim@gmail.com", "123456", nil)
        ]
        
        print("===== Bắt đầu seed users =====")
        for user in sampleUsers {
            let success = addUser(
                userName: user.name,
                emailAddress: user.email,
                password: user.password,
                userImage: user.image
            )
            if success {
                print("✓ Đã thêm: \(user.name) - \(user.email)")
            } else {
                print("✗ Không thêm được: \(user.name) - \(user.email)")
            }
        }
        print("===== Kết thúc seed users =====")
    }
}
