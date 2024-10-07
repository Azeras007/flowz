import Alamofire
import Foundation

func createArea(name: String, trigger: Trigger, actionFormData: FormData, triggerFormData: TriggerFormData?) {
    let url = "https://area-development.tech/api/areas/new"
    let token = KeychainHelper.getToken() ?? ""
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(token)"
    ]
    let listenerID = String(trigger.id)
    let actionID = String(trigger.id)
    
    print("Creating area with listener ID \(listenerID) and action ID \(actionID)")
    print("Trigger form data: \(triggerFormData?.fields ?? [:])")
    print("Action form data: \(actionFormData.fields)")

    let triggerPayload = triggerFormData?.fields.mapValues { String(describing: $0) } ?? [:]
    let actionPayload = actionFormData.fields.mapValues { String(describing: $0) }

    guard JSONSerialization.isValidJSONObject(triggerPayload),
          JSONSerialization.isValidJSONObject(actionPayload) else {
        print("Invalid JSON object in payloads")
        return
    }

    let parameters: [String: Any] = [
        "listener_id": listenerID,
        "action_id": actionID,
        "name": name,
        "listener_payload": triggerPayload,
        "action_payload": actionPayload
    ]

    guard JSONSerialization.isValidJSONObject(parameters) else {
        print("Invalid JSON object in parameters")
        return
    }

    AF.request(url,method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        switch response.result {
        case .success(let data):
            print("Server response: \(data)")
        case .failure(let error):
            print("Failed to create area: \(error)")
            if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                print("Raw server response: \(rawString)")
            }
        }
    }
}
