import Foundation


class GroupMessageDTO: Identifiable, Decodable, ObservableObject, Hashable {
  var groupId: String
  var authorDeviceId: String
  var message: String
  var createdAt: String

  init(
    groupId: String,  authorDeviceId: String, message: String, createdAt: String
  ) {
    self.groupId = groupId
    self.authorDeviceId = authorDeviceId
    self.message = message
    self.createdAt = createdAt

  }

  private enum CodingKeys: String, CodingKey {
    case groupId
    case authorDeviceId
    case message
    case createdAt
  }

  required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
      groupId = try container.decode(String.self, forKey: .groupId)
      authorDeviceId = try container.decode(String.self, forKey: .authorDeviceId)
      message = try container.decode(String.self, forKey: .message)
      createdAt = try container.decode(String.self, forKey: .createdAt)

  }
    
    static func == (lhs: GroupMessageDTO, rhs: GroupMessageDTO) -> Bool {
        return lhs.createdAt == rhs.createdAt
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(createdAt)
    }
}
