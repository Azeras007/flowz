import SwiftUI
import Alamofire

struct RegisterView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var errorMessage: String?
    @Binding var isUserLoggedIn: Bool
    @Binding var isLoginorRegister: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "wave.3.forward.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .padding(.bottom, 40)
            
            Text("Create your account")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 30)
            
            TextField("Name", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .autocapitalization(.words)
                .disableAutocorrection(true)
            
            TextField("Email address", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                if password == confirmPassword {
                    register(name: name, email: email, password: password) { success, error in
                        if success {
                            isUserLoggedIn = true
                            isLoginorRegister = false
                            print("Registration successful!")
                        } else {
                            errorMessage = error
                        }
                    }
                } else {
                    errorMessage = "Passwords do not match."
                }
            }) {
                Text("Sign up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            HStack {
                Text("Already have an account?")
                    .foregroundColor(.gray)
                    .font(.footnote)
                
                Button(action: {
                    isLoginorRegister = true
                }) {
                    Text("Sign in")
                        .foregroundColor(.blue)
                        .font(.footnote)
                        .underline()
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = "https://area-development.tech/api/register"
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let json):
                if let json = json as? [String: Any] {
                    if let message = json["message"] as? String, message == "User created, you can now log in." {
                        completion(true, nil)
                    } else if let errors = json["errors"] as? [String: Any], let firstError = errors.values.first as? [String] {
                        completion(false, firstError.first ?? "Unknown error")
                    } else if let token = json["token"] as? String {
                        KeychainHelper.saveToken(token)
                        completion(true, nil)
                    } else {
                        completion(false, "An unknown error occurred.")
                    }
                } else {
                    completion(false, "Invalid response from server.")
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
}
