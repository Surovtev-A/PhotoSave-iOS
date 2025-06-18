# PhotoSave 🔐

PhotoSave — это iOS-приложение, представляющее собой приватное фотохранилище. Оно позволяет пользователям сохранять свои фотографии и заметки к ним в галерее, защищенной паролем.

<img src="https://github.com/user-attachments/assets/a804274d-d32d-4060-a711-49ded5edb690" width="200" />
<img src="https://github.com/user-attachments/assets/79df99bb-c5f9-4a34-a7d6-32bb2deadaa6" width="200" />
<img src="https://github.com/user-attachments/assets/e2b08bfc-0443-434a-9bbf-867b713d3729" width="200" />
<img src="https://github.com/user-attachments/assets/c1e8c094-fff2-49dd-9b68-d978b373d137" width="200" />
<img src="https://github.com/user-attachments/assets/791b393b-522c-46e8-a8d6-7156b0f0d810" width="200" />



---

### 🇷🇺 Русский

#### Основные возможности

-   **Защита паролем:** Система регистрации при первом входе и экран входа для последующих запусков.
-   **Фотогалерея:** Просмотр всех сохраненных фотографий в виде сетки (`UICollectionView`).
-   **Добавление фото:** Импорт фотографий из камеры или фотогалереи устройства.
-   **Заметки к фото:** Возможность прикреплять текстовые заметки к каждому сохраняемому изображению.
-   **Просмотр и управление:** Полноэкранный просмотрщик фотографий с навигацией свайпами, возможностью "лайкнуть" и удалить фото.
-   **Локальное хранилище:** Все данные (фото, заметки, пароль) сохраняются локально на устройстве.

#### ⚠️ Важное примечание по безопасности

В текущей версии проекта для простоты и демонстрации используется `UserDefaults` для хранения пароля и данных. В реальном приложении для обеспечения безопасности следует:
1.  **Хранить пароль** в **Keychain (Связке ключей)**. В проекте уже импортирована библиотека `SwiftyKeychainKit`, которая идеально для этого подходит.
2.  **Хранить изображения** в файловой системе (например, в директории документов приложения), а в базе данных (Core Data, Realm или SQLite) хранить пути к файлам и метаданные (заметки, лайки).

#### Стек технологий

-   **Язык:** Swift
-   **UI Framework:** UIKit (Storyboards)
-   **Архитектурный паттерн:** Delegate
-   **Хранение данных:** `UserDefaults`, `Codable`
-   **Менеджер зависимостей:** CocoaPods
-   **Зависимости:** `SwiftyKeychainKit` (импортирована для работы с Keychain)

#### Запуск проекта

1.  Убедитесь, что у вас установлен [CocoaPods](https://cocoapods.org/).
2.  Склонируйте репозиторий:
    ```bash
    git clone [https://github.com/new](https://github.com/new)
    ```
3.  Перейдите в директорию проекта через терминал:
    ```bash
    cd [название_папки_проекта]
    ```
4.  Установите зависимости:
    ```bash
    pod install
    ```
5.  Откройте файл `.xcworkspace` в Xcode (**важно: не используйте `.xcodeproj`**).
6.  Соберите и запустите проект.

---

### 🇬🇧 English

#### Key Features

-   **Password Protection:** A registration system for the first launch and a login screen for subsequent access.
-   **Photo Gallery:** View all your saved photos in a grid layout (`UICollectionView`).
-   **Add Photos:** Import photos from the device's camera or photo library.
-   **Photo Notes:** Attach text notes to each image you save.
-   **View & Manage:** A full-screen photo viewer with swipe navigation, a "like" feature, and the ability to delete photos.
-   **Local Storage:** All data (photos, notes, password) is saved locally on the device.

#### ⚠️ Important Security Note

For simplicity and demonstration purposes, the current version of the project uses `UserDefaults` for storing the password and photo data. In a production application, for proper security, you should:
1.  **Store the password** in the **Keychain**. The project already includes the `SwiftyKeychainKit` library, which is perfect for this.
2.  **Store images** in the file system (e.g., in the app's documents directory) and store the file paths and metadata (notes, likes) in a database like Core Data, Realm, or SQLite.

#### Tech Stack

-   **Language:** Swift
-   **UI Framework:** UIKit (Storyboards)
-   **Architectural Pattern:** Delegate
-   **Data Persistence:** `UserDefaults`, `Codable`
-   **Dependency Manager:** CocoaPods
-   **Dependencies:** `SwiftyKeychainKit` (imported for Keychain functionality)

#### How To Run

1.  Make sure you have [CocoaPods](https://cocoapods.org/) installed.
2.  Clone the repository:
    ```bash
    git clone [your_repository_url]
    ```
3.  Navigate to the project directory in your terminal:
    ```bash
    cd [project_folder_name]
    ```
4.  Install the dependencies:
    ```bash
    pod install
    ```
5.  Open the `.xcworkspace` file in Xcode (**important: do not use the `.xcodeproj` file**).
6.  Build and run the project.

---

**Автор / Author**

Surovtev A
