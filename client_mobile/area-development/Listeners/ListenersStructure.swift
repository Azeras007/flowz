struct Trigger: Identifiable, Decodable {
    var id: Int
    var sub_service_id: Int
    var name: String
    var type: String
    var icon_url: String
    var metadata: TriggerMetadata?
    var created_at: String
    var updated_at: String

    var metadataFields: [TriggerMetadataField] {
        return metadata?.fields ?? []
    }

    enum CodingKeys: String, CodingKey {
        case id
        case sub_service_id
        case name
        case type
        case icon_url
        case metadata
        case created_at
        case updated_at
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        sub_service_id = try container.decode(Int.self, forKey: .sub_service_id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        icon_url = try container.decode(String.self, forKey: .icon_url)
        created_at = try container.decode(String.self, forKey: .created_at)
        updated_at = try container.decode(String.self, forKey: .updated_at)

        if let metadataDict = try? container.decode(TriggerMetadata.self, forKey: .metadata) {
            metadata = metadataDict
        } else if let _ = try? container.decode([TriggerMetadataField].self, forKey: .metadata) {
            metadata = nil
        } else {
            metadata = nil
        }
    }
}

struct TriggerMetadata: Decodable {
    var fields: [TriggerMetadataField]
}

struct TriggerMetadataField: Decodable {
    var label: String
    var name: String
    var required: Bool
    var type: String
}


struct TriggerFormData {
    var fields: [String: String]
}
