import UIKit

class PhotoSaveClass: Codable {
    var images: [Data] = [] // Массив данных изображений в формате PNG
    var note: String = ""
    var like:Bool=false
    
    init(images: [UIImage], note: String, like:Bool) {
        self.images = images.compactMap { $0.pngData() } // Конвертируем UIImage в Data (PNG)
        self.note = note
        self.like=like
    }
    
    public enum CodingKeys: String, CodingKey {
        case images
        case note
        case like
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.images = try container.decode([Data].self, forKey: .images) // Декодируем массив Data
        self.note = try container.decode(String.self, forKey: .note)
        self.like = try container.decode(Bool.self , forKey: .like) ?? false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(images, forKey: .images) // Кодируем массив Data
        try container.encode(note, forKey: .note)
        try container.encode(like, forKey: .like)
    }
    
    public func getImages() -> [UIImage] {
        return images.compactMap { UIImage(data: $0) } // Конвертируем Data обратно в UIImage
    }
}
