//
//  APIData.swift
//  IOSChatBot
//
//  Created by Raghuram on 24/05/22.
//

import Foundation

struct  ResponseType:Codable {
    let conversationId, token: String
    let expires_in: Int
}

struct ConversationType:Codable {
    let conversationId, token : String
    let expires_in : Int
    let streamUrl, referenceGrammarId : String
    
}

struct SentResponseType:Codable {
    let id: String
}

// MARK: - ReceiveMessage
struct ReceiveMessage: Codable {
    let activities : [Activities]?
    let watermark : String?

    enum CodingKeys: String, CodingKey {

        case activities = "activities"
        case watermark = "watermark"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        activities = try values.decodeIfPresent([Activities].self, forKey: .activities)
        watermark = try values.decodeIfPresent(String.self, forKey: .watermark)
    }

}
struct Activities: Codable {

  var type         : String?       = nil
  var id           : String?       = nil
  var timestamp    : String?       = nil
  var serviceUrl   : String?       = nil
  var channelId    : String?       = nil
  var from         : From?         = From()
  var conversation : Conversation? = Conversation()
  var attachmentLayout : String?        = nil
  var locale       : String?       = nil
  var text         : String?       = nil
  var speak        : String?       = nil
  var attachments  : [Attachments]?     = []
  var entities     : [String]?     = []
  var suggestedActions : SuggestedActions? = SuggestedActions()

  enum CodingKeys: String, CodingKey {

    case type         = "type"
    case id           = "id"
    case timestamp    = "timestamp"
    case serviceUrl   = "serviceUrl"
    case channelId    = "channelId"
    case from         = "from"
    case conversation = "conversation"
    case attachmentLayout = "attachmentLayout"
    case locale       = "locale"
    case text         = "text"
    case speak        = "speak"
    case attachments  = "attachments"
    case entities     = "entities"
    case suggestedActions = "suggestedActions"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    type         = try values.decodeIfPresent(String.self       , forKey: .type         )
    id           = try values.decodeIfPresent(String.self       , forKey: .id           )
    timestamp    = try values.decodeIfPresent(String.self       , forKey: .timestamp    )
    serviceUrl   = try values.decodeIfPresent(String.self       , forKey: .serviceUrl   )
    channelId    = try values.decodeIfPresent(String.self       , forKey: .channelId    )
    from         = try values.decodeIfPresent(From.self         , forKey: .from         )
    conversation = try values.decodeIfPresent(Conversation.self , forKey: .conversation )
    attachmentLayout = try values.decodeIfPresent(String.self        , forKey: .attachmentLayout )
    locale       = try values.decodeIfPresent(String.self       , forKey: .locale       )
    text         = try values.decodeIfPresent(String.self       , forKey: .text         )
    speak        = try values.decodeIfPresent(String.self       , forKey: .speak        )
    attachments  = try values.decodeIfPresent([Attachments].self     , forKey: .attachments  )
    entities     = try values.decodeIfPresent([String].self     , forKey: .entities     )
    suggestedActions = try values.decodeIfPresent(SuggestedActions.self , forKey: .suggestedActions )
     
 
  }

  init() {

  }

}

public struct Actions: Codable {

  var type  : String? = nil
  var title : String? = nil
  var value : String? = nil

  enum CodingKeys: String, CodingKey {

    case type  = "type"
    case title = "title"
    case value = "value"
  
  }

    public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    type  = try values.decodeIfPresent(String.self , forKey: .type  )
    title = try values.decodeIfPresent(String.self , forKey: .title )
    value = try values.decodeIfPresent(String.self , forKey: .value )
 
  }

  init() {

  }

}

struct SuggestedActions: Codable {

  var actions : [Actions]? = []

  enum CodingKeys: String, CodingKey {

    case actions = "actions"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    actions = try values.decodeIfPresent([Actions].self , forKey: .actions )
 
  }

  init() {

  }

}

struct Conversation: Codable {

  var id : String? = nil

  enum CodingKeys: String, CodingKey {

    case id = "id"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id = try values.decodeIfPresent(String.self , forKey: .id )
 
  }

  init() {

  }

}

struct From: Codable {

  var id   : String? = nil
  var name : String? = nil

  enum CodingKeys: String, CodingKey {

    case id   = "id"
    case name = "name"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id   = try values.decodeIfPresent(String.self , forKey: .id   )
    name = try values.decodeIfPresent(String.self , forKey: .name )
 
  }

  init() {

  }

}

public struct Attachments: Codable {

  var contentType : String?  = nil
  var content     : Content? = Content()

  enum CodingKeys: String, CodingKey {

    case contentType = "contentType"
    case content     = "content"
  
  }

    public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    contentType = try values.decodeIfPresent(String.self  , forKey: .contentType )
    content     = try values.decodeIfPresent(Content.self , forKey: .content     )
 
  }

  init() {

  }

}

struct Content: Codable {

  var lgtype   : String?    = nil
  var title    : String?    = nil
  var text     : String? = nil
  var subtitle : String?    = nil
  var images   : [Images]?  = []
  var buttons  : [Buttons]? = []

  enum CodingKeys: String, CodingKey {

    case lgtype   = "lgtype"
    case title    = "title"
    case text     = "text"
    case subtitle = "subtitle"
    case images   = "images"
    case buttons  = "buttons"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    lgtype   = try values.decodeIfPresent(String.self    , forKey: .lgtype   )
    title    = try values.decodeIfPresent(String.self    , forKey: .title    )
    text     = try values.decodeIfPresent(String.self    , forKey: .text    )
    subtitle = try values.decodeIfPresent(String.self    , forKey: .subtitle )
    images   = try values.decodeIfPresent([Images].self  , forKey: .images   )
    buttons  = try values.decodeIfPresent([Buttons].self , forKey: .buttons  )
 
  }

  init() {

  }

}

struct Buttons: Codable {

  var type         : String? = nil
  var title        : String? = nil
  var image        : String? = nil
  var text         : String? = nil
  var displayText  : String? = nil
  var value        : String? = nil
  var channelData  : String? = nil
  var imageAltText : String? = nil

  enum CodingKeys: String, CodingKey {

    case type         = "type"
    case title        = "title"
    case image        = "image"
    case text         = "text"
    case displayText  = "displayText"
    case value        = "value"
    case channelData  = "channelData"
    case imageAltText = "imageAltText"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    type         = try values.decodeIfPresent(String.self , forKey: .type         )
    title        = try values.decodeIfPresent(String.self , forKey: .title        )
    image        = try values.decodeIfPresent(String.self , forKey: .image        )
    text         = try values.decodeIfPresent(String.self , forKey: .text         )
    displayText  = try values.decodeIfPresent(String.self , forKey: .displayText  )
    value        = try values.decodeIfPresent(String.self , forKey: .value        )
    channelData  = try values.decodeIfPresent(String.self , forKey: .channelData  )
    imageAltText = try values.decodeIfPresent(String.self , forKey: .imageAltText )
 
  }

  init() {

  }

}

struct Images: Codable {

  var url : String? = nil

  enum CodingKeys: String, CodingKey {

    case url = "url"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    url = try values.decodeIfPresent(String.self , forKey: .url )
 
  }

  init() {

  }

}


