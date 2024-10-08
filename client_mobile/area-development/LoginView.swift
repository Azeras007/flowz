import SwiftUI
import AuthenticationServices
import SafariServices
import Alamofire

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String?
    @State private var showSafari: Bool = false
    @State private var authURL: URL?
    @Binding var isUserLoggedIn: Bool
    @Binding var isLoginorRegister: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.bottom, 40)
            
            Text("Sign in to your account")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 30)
            
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
            
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                            handleAppleIDCredential(appleIDCredential)
                        }
                    case .failure(let error):
                        print("Sign in with Apple failed: \(error.localizedDescription)")
                        errorMessage = "Sign in with Apple failed: \(error.localizedDescription)"
                    }
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(width: 250, height: 50)
            .padding()
            
            Button(action: {
                authURL = URL(string: "https://area-development.tech/api/auth/google?redirect_url=areadevelopment://auth")
                if authURL != nil {
                    showSafari.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .foregroundColor(.white)
                    Text("Sign in with Google")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
                .frame(width: 250, height: 50)
                .background(Color.red)
                .cornerRadius(10)
            }
            .padding()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
        }
        .padding()
        .navigationTitle("Login")
        .sheet(isPresented: $showSafari, onDismiss: {
            authURL = nil
            showSafari = false
        }) {
            if let url = authURL {
                SafariView(url: url)
                    .onAppear {
                        print("Opening Safari with URL: \(url)")
                    }
            }
        }
    }
    
    func handleAppleIDCredential(_ credential: ASAuthorizationAppleIDCredential) {
        let userID = credential.user
        let email = credential.email ?? "No email provided"
        let fullName = credential.fullName?.formatted() ?? "No name provided"
        
        guard let identityToken = credential.identityToken,
              let tokenString = String(data: identityToken, encoding: .utf8) else {
            errorMessage = "Failed to retrieve identity token."
            return
        }
        
        print("Apple Sign-In successful!")
        print("User ID: \(userID)")
        print("Email: \(email)")
        print("Full Name: \(fullName)")
        print("Token: \(tokenString)")
        KeychainHelper.saveToken(tokenString)
        isUserLoggedIn = true
        
        // let parameters: [String: String] = [
        //     "user_id": userID,
        //     "email": email,
        //     "full_name": fullName,
        //     "token": tokenString
        // ]
        
        // // Faire une requête POST à votre backend avec le token
        // AF.request("https://area-development.tech/api/auth/apple/callback", method: .post, parameters: parameters, encoding: JSONEncoding.default)
        //     .validate(statusCode: 200..<300)
        //     .responseJSON { response in
        //         switch response.result {
        //         case .success(let value):
        //             print("Token successfully sent to backend. Response: \(value)")
        //         case .failure(let error):
        //             print("Failed to send token to backend: \(error)")
        //             errorMessage = "Failed to authenticate with backend."
        //         }
        //     }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}
