# Ứng dụng nhỏ để upload ảnh và video từ thư viện lên Locket sử dụng Locket API

- Sử dụng Locket API đăng ảnh và video ngắn từ thư viện lên locket với caption không giới hạn và có thể là hơn thế nữa
- Language: SwiftUI
- Minimum deployment: iOS 16.0

# Các bước thực hiện

- Đối với ảnh:
  - Đăng nhập locket bằng FirebaseAuth
  - Upload ảnh lên FirebaseStorage và lấy downloadUrl
  - Post ảnh lên locket bằng API **postMomentV2** với request là *downloadUrl* và *caption* sử dụng `httpsCallable`

- Đối với video:
  - Đăng nhập locket bằng FirebaseAuth
  - Lấy thumbnail của video sau đó upload lên FirebaseStorage lấy thumbnail_url
  - Upload video dạng .mp4 lên FirebaseStorage lấy video_url
  - Post video lên locket bằng API **postMomentV2** với request là *video_url*, *thumbnail_url* và *caption*

- **Lưu ý:** upload ngắn với dung lượng nhỏ để tránh crash app khi up lên locket 

# Build app
- Bước 1: Thêm [Firebase](https://firebase.google.com/docs/ios/setup) bao gồm **FirebaseAppCheck**, **FirebaseAuth**, **FirebaseFunctions**, **FirebaseStorage** và [Kingfisher](https://github.com/onevcat/Kingfisher) vào project (Sử dụng Swift Package Manager - SPM)
- Bước 2: Sửa config file **GoogleService-Inf**o với các tham số **API_KEY**, **PROJECT_ID**, **STORAGE_BUCKET**
- Bước 3: build app lên máy và đăng nhập tài khoản locket của bạn.

!["Home App"](./Images/app_1.jpeg#center)