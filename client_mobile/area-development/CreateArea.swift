import Alamofire
import Foundation

func createArea(name: String, trigger: Trigger, action: Action,actionFormData: FormData, triggerFormData: TriggerFormData?) {
    let url = "https://area-development.tech/api/areas/new"
    let token = KeychainHelper.getToken() ?? ""
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(token)",
        "Accept": "application/json"
    ]
    
    let listenerID = String(trigger.id)
    let actionID = String(action.id)
    
    print("Creating area with listener ID \(listenerID) and action ID \(actionID)")
    print("Trigger form data: \(triggerFormData?.fields ?? [:])")
    print("Action form data: \(actionFormData.fields)")

    let triggerPayload = triggerFormData?.fields.isEmpty == false ? triggerFormData?.fields.mapValues { String(describing: $0) } : nil
    let actionPayload = actionFormData.fields.mapValues { String(describing: $0) }

    guard JSONSerialization.isValidJSONObject(actionPayload) else {
        print("Invalid JSON object in actionPayload")
        return
    }

    var parameters: [String: Any] = [
        "listener_id": listenerID,
        "action_id": actionID,
        "name": name,
        "action_payload": actionPayload
    ]

    if let triggerPayload = triggerPayload, !triggerPayload.isEmpty {
        if JSONSerialization.isValidJSONObject(triggerPayload) {
            parameters["listener_payload"] = triggerPayload
        } else {
            print("Invalid JSON object in triggerPayload")
            return
        }
    }

    guard JSONSerialization.isValidJSONObject(parameters) else {
        print("Invalid JSON object in parameters")
        return
    }

    AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        switch response.result {
        case .success(let data):
            print("Area created successfully: \(data)")
        case .failure(let error):
            print("Failed to create area: \(error)")
            if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                print("Raw server response: \(rawString)")
            }
        }
    }
}
