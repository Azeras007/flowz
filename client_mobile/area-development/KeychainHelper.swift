import Foundation
import Security

struct KeychainHelper {
    // Save token to keychain
    static func saveToken(_ token: String) {
        guard let data = token.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "authToken", // Identifier for the token
            kSecValueData as String: data
        ]
        
        // Delete any existing token before saving a new one
        SecItemDelete(query as CFDictionary)
        
        // Add new token to keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Token saved successfully.")
        } else {
            print("Error saving token: \(status)")
        }
    }
    
    // Retrieve token from keychain
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
    
    // Delete token from keychain
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
}
