struct Action: Identifiable, Codable {
    var id: Int
    var sub_service_id: Int
    var name: String
    var type: String
    var icon_url: String
    var metadata: Metadata
    var created_at: String
    var updated_at: String
}

struct Metadata: Codable {
    var fields: [MetadataField]
}

struct MetadataField: Codable {
    var name: String
    var type: String
    var label: String
    var required: Bool
}

struct FormData: Codable {
    var fields: [String: String]
}
