import SwiftUI

struct CreateView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Text("Create")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                        .frame(maxWidth: .infinity, alignment: .center)

                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                        }
                        .padding(.leading, 20)

                        Spacer()
                    }
                }
                .padding(.top, 20)

                Spacer()

                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color.white : Color.black)
                    .frame(height: 100)
                    .overlay(
                        HStack {
                            Text("If This")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                .padding(.leading, 20)

                            Spacer()

                            NavigationLink(destination: SubServicesActionsView()) {
                                Text("Add")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding()
                                    .frame(width: 90)
                                    .background(colorScheme == .dark ? Color.black : Color.white)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    .cornerRadius(60)
                            }
                            .padding(.trailing, 20)
                        }
                    )
                    .padding(.horizontal, 20)

                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray)
                    .frame(height: 100)
                    .overlay(
                        HStack {
                            Text("Then That")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .padding(.leading, 20)

                            Spacer()

                         //   Button(action: {
                     //       }) {
                       //         Text("Add")
                      //              .font(.title3)
                     //               .fontWeight(.bold)
                   //                 .padding()
                    //                .frame(width: 90)
                      //              .background(Color.white)
                       //             .foregroundColor(Color.black)
                       //             .cornerRadius(60)
                        //    }
                       //     .padding(.trailing, 20)
                        }
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                Spacer()
            }
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CreateView()
                .preferredColorScheme(.light)
            CreateView()
                .preferredColorScheme(.dark)
        }
    }
}
