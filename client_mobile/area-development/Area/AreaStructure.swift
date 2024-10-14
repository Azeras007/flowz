
struct AreaResponse: Decodable {
    var data: [Area]
    var meta: Meta
    var links: Links
}

struct AreaRep: Decodable {
    var data: Area
}

struct Area: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String
    var status: Bool
    var created_at: String
    var is_failed: Bool
    var listener_name: String
    var listener_sub_service_name: String
    var listener_sub_service_icon: String
    
    var action_name: String
    var action_sub_service_name: String
    var action_sub_service_icon: String

    enum CodingKeys: String, CodingKey {
        case id, name, status, created_at, is_failed
        case listener, action
    }

    enum ListenerKeys: String, CodingKey {
        case name
        case sub_service_name
        case sub_service_icon
    }

    enum ActionKeys: String, CodingKey {
        case name
        case sub_service_name
        case sub_service_icon
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(Bool.self, forKey: .status)
        self.created_at = try container.decode(String.self, forKey: .created_at)
        self.is_failed = try container.decode(Bool.self, forKey: .is_failed)

        let listenerContainer = try container.nestedContainer(keyedBy: ListenerKeys.self, forKey: .listener)
        self.listener_name = try listenerContainer.decode(String.self, forKey: .name)
        self.listener_sub_service_name = try listenerContainer.decode(String.self, forKey: .sub_service_name)
        self.listener_sub_service_icon = try listenerContainer.decode(String.self, forKey: .sub_service_icon)

        let actionContainer = try container.nestedContainer(keyedBy: ActionKeys.self, forKey: .action)
        self.action_name = try actionContainer.decode(String.self, forKey: .name)
        self.action_sub_service_name = try actionContainer.decode(String.self, forKey: .sub_service_name)
        self.action_sub_service_icon = try actionContainer.decode(String.self, forKey: .sub_service_icon)
    }
}


struct Meta: Decodable {
    var current_page: Int
    var from: Int?
    var last_page: Int
    var per_page: Int
    var to: Int
    var total: Int
}

struct Links: Decodable {
    var first: String
    var last: String
    var next: String?
    var prev: String?
}

struct LogResponse: Decodable {
    var current_page: Int
    var data: [Log]
    var first_page_url: String
    var from: Int?
    var last_page: Int
    var last_page_url: String
    var next_page_url: String?
    var path: String
    var per_page: Int
    var prev_page_url: String?
    var to: Int?
    var total: Int
}

struct Log: Identifiable, Decodable {
    var id: Int
    var area_id: Int
    var status: String
    var triggered_by: String
    var response: String
    var created_at: String
}
