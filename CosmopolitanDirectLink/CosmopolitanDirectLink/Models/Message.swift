//
//  Message.swift
//  IOSChatBot
//
//  Created by Raghuram on 25/05/22.
//

import Foundation

public protocol MessageType : Codable {
    var sender: SenderType { get }
    var messageId: String { get }
    var sentDate: Date { get }
    var kind: MessageKind { get }

}

public protocol SenderType {
    var senderId: String { get }
    var displayName: String { get }
}

public enum MessageKind {
    case text(String)
    case attachments([Attachments]?)
    case actions([Actions]?)
    case custom(String?)
}

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

public struct Sender: SenderType, Codable {
    public let senderId: String
    public let displayName: String
}

struct Message:Codable  {
     var sender: Sender
     var messageId: String
     var sentDate: Date
     var kind: MessageKind
     var sectionCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case sender, messageId, sentDate, kind
        case sectionCount = "sectionCount"
    }
    
    init(sender:Sender, messageId:String, kind:MessageKind , sentDate: Date, sectionCount: Int?) {
        self.sender = sender
        self.messageId = messageId
        self.kind = kind
        self.sentDate = sentDate
        self.sectionCount = sectionCount
    }  
}

extension MessageKind: Codable{
    enum Key: CodingKey {
            case rawValue
            case associatedValue
        }
        
        enum CodingError: Error {
            case unknownValue
        }
    
    public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: Key.self)
            let rawValue = try container.decode(Int.self, forKey: .rawValue)
            switch rawValue {
            case 0:
                let textValue = try container.decode(String.self, forKey: .associatedValue)
                self = .text(textValue)
            case 1:
                let value = try container.decodeIfPresent(String.self, forKey: .associatedValue)
                self = .custom(value)
            case 2:
                let value = try container.decodeIfPresent([Attachments].self, forKey: .associatedValue)
                self = .attachments(value)
            case 3:
                let value = try container.decodeIfPresent([Actions].self, forKey: .associatedValue)
                self = .actions(value)
            default:
                throw CodingError.unknownValue
            }
        }
        
    public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: Key.self)
            switch self {
            case .text(let textValue):
                try container.encode(0, forKey: .rawValue)
                try container.encode(textValue, forKey: .associatedValue)
            case .custom(let value):
                try container.encode(1, forKey: .rawValue)
                try container.encode(value, forKey: .associatedValue)
            case .attachments(let value):
                try container.encode(2, forKey: .rawValue)
                try container.encode(value, forKey: .associatedValue)
            case .actions(let value):
                try container.encode(3, forKey: .rawValue)
                try container.encode(value, forKey: .associatedValue)
            }
        }
}

extension Message {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    sender = try values.decodeIfPresent(Sender.self, forKey: .sender) ?? Sender(senderId: "", displayName: "")
    messageId = try values.decode(String.self, forKey: .messageId)
    sentDate = try values.decodeIfPresent(Date.self, forKey: .sentDate) ?? Date()
    kind = try values.decodeIfPresent(MessageKind.self, forKey: .kind) ?? MessageKind.custom("")
    sectionCount = try values.decodeIfPresent(Int.self, forKey: .sectionCount) ?? 1
  }
}
