struct Action: Identifiable, Decodable {
    var id: Int
    var sub_service_id: Int
    var name: String
    var type: String
    var icon_url: String
    var metadata: Metadata
    var created_at: String
    var updated_at: String
}

struct Metadata: Decodable {
    var fields: [MetadataField]
}

struct MetadataField: Decodable {
    var name: String
    var type: String
    var label: String
    var required: Bool
}