import Foundation
import Security

struct KeychainHelper {
    static func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Token saved successfully.")
        } else {
            print("Error saving token: \(status)")
        }
    }
    
    static func getToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            print("Error retrieving token: \(status)")
            return nil
        }
    }
    
    static func deleteToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Token deleted successfully.")
        } else {
            print("Error deleting token: \(status)")
        }
    }

    static func saveAction(_ action: Action) {
        guard let data = try? JSONEncoder().encode(action) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "action",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Action saved successfully.")
        } else {
            print("Error saving action: \(status)")
        }
    }

    static func getAction() -> Action? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "action",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let action = try? JSONDecoder().decode(Action.self, from: data) {
            return action
        } else {
            print("Error retrieving action: \(status)")
            return nil
        }
    }

    static func deleteAction() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "action"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Action deleted successfully.")
        } else {
            print("Error deleting action: \(status)")
        }
    }

    static func saveTrigger(_ trigger: Trigger) {
        guard let data = try? JSONEncoder().encode(trigger) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "trigger",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Trigger saved successfully.")
        } else {
            print("Error saving trigger: \(status)")
        }
    }

    static func getTrigger() -> Trigger? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "trigger",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let trigger = try? JSONDecoder().decode(Trigger.self, from: data) {
            return trigger
        } else {
            print("Error retrieving trigger: \(status)")
            return nil
        }
    }

    static func deleteTrigger() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "trigger"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Trigger deleted successfully.")
        } else {
            print("Error deleting trigger: \(status)")
        }
    }

    static func savedFormDataAction(_ formData: FormData) {
        guard let data = try? JSONEncoder().encode(formData) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "formDataAction",
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Action form data saved successfully.")
        } else {
            print("Error saving action form data: \(status)")
        }
    }

    static func getSavedFormDataAction() -> FormData? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "formDataAction",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let formData = try? JSONDecoder().decode(FormData.self, from: data) {
            return formData
        } else {
            print("Error retrieving action form data: \(status)")
            return nil
        }
    }

    static func deleteSavedFormDataAction() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "formDataAction"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Action form data deleted successfully.")
        } else {
            print("Error deleting action form data: \(status)")
        }
    }

    static func savedFormDataTrigger(_ formData: TriggerFormData) {
        guard let data = try? JSONEncoder().encode(formData) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "formDataTrigger",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Trigger form data saved successfully.")
        } else {
            print("Error saving trigger form data: \(status)")
        }
    }

    static func getSavedFormDataTrigger() -> TriggerFormData? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "formDataTrigger",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let formData = try? JSONDecoder().decode(TriggerFormData.self, from: data) {
            return formData
        } else {
            print("Error retrieving trigger form data: \(status)")
            return nil
        }
    }

    static func deleteSavedFormDataTrigger() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "formDataTrigger"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Trigger form data deleted successfully.")
        } else {
            print("Error deleting trigger form data: \(status)")
        }
    }

    static func saveSubService(_ subService: SubService) {
        guard let data = try? JSONEncoder().encode(subService) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "subService",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("SubService saved successfully.")
        } else {
            print("Error saving subService: \(status)")
        }
    }

    static func getSubService() -> SubService? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "subService",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let subService = try? JSONDecoder().decode(SubService.self, from: data) {
            return subService
        } else {
            print("Error retrieving subService: \(status)")
            return nil
        }
    }

    static func deleteSubService() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "subService"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("SubService deleted successfully.")
        } else {
            print("Error deleting subService: \(status)")
        }
    }

    static func saveTriggers(_ triggers: [Trigger]) {
        guard let data = try? JSONEncoder().encode(triggers) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "triggers",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Triggers saved successfully.")
        } else {
            print("Error saving triggers: \(status)")
        }
    }

    static func getTriggers() -> [Trigger]? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "triggers",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let triggers = try? JSONDecoder().decode([Trigger].self, from: data) {
            return triggers
        } else {
            print("Error retrieving triggers: \(status)")
            return nil
        }
    }

    static func deleteTriggers() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "triggers"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Triggers deleted successfully.")
        } else {
            print("Error deleting triggers: \(status)")
        }
    }

    static func saveActions(_ actions: [Action]) {
        guard let data = try? JSONEncoder().encode(actions) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "actions",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Actions saved successfully.")
        } else {
            print("Error saving actions: \(status)")
        }
    }

    static func getActions() -> [Action]? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "actions",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let actions = try? JSONDecoder().decode([Action].self, from: data) {
            return actions
        } else {
            print("Error retrieving actions: \(status)")
            return nil
        }
    }

    static func deleteActions() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "actions"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Actions deleted successfully.")
        } else {
            print("Error deleting actions: \(status)")
        }
    }

    static func saveNameArea(_ name: String) {
        guard let data = name.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "nameArea",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Name area saved successfully.")
        } else {
            print("Error saving name area: \(status)")
        }
    }

    static func getNameArea() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "nameArea",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let name = String(data: data, encoding: .utf8) {
            return name
        } else {
            print("Error retrieving name area: \(status)")
            return nil
        }
    }

    static func deleteNameArea() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "nameArea"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Name area deleted successfully.")
        } else {
            print("Error deleting name area: \(status)")
        }
    }

    static func saveSubServices(_ subServices: [SubService]) {
        guard let data = try? JSONEncoder().encode(subServices) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "subServices",
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("SubServices saved successfully.")
        } else {
            print("Error saving subServices: \(status)")
        }
    }

    static func getSubServices() -> [SubService]? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "subServices",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data, let subServices = try? JSONDecoder().decode([SubService].self, from: data) {
            return subServices
        } else {
            print("Error retrieving subServices: \(status)")
            return nil
        }
    }

    static func deleteSubServices() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "subServices"
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("SubServices deleted successfully.")
        } else {
            print("Error deleting subServices: \(status)")
        }
    }
}
