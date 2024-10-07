import SwiftUI

struct CreateView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("X")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .padding(.leading, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            
            Spacer()
            
            Text("Create")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)
            
            HStack {
                Text("If This")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(8)
                
                Spacer()
                
                NavigationLink(destination: SubServicesActionsView()) {
                    Text("add")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.yellow)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 40)
            }
            Spacer()
            
            Text("Then That")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.gray)
                .cornerRadius(8)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}

struct UserSelection {
    var selectedSubService: SubService?
    var selectedTrigger: Trigger?
}
