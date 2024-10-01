import SwiftUI

struct QuoteView: View {
    @StateObject private var vm = QuoteViewViewModel()
    var body: some View {
        NavigationView {
            Group {
                if vm.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = vm.errorMessage {
                    VStack {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            vm.fetchPosts()
                        }
                    }
                } else {
                    List(vm.posts) { post in
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                        }
                        .padding()
                        .background(Color("bgColor"))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    
                   
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Posts")
         
            .onAppear {
                vm.fetchPosts()
            }
        }
    }
}


class QuoteViewViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false

    func fetchPosts() {
        isLoading = true
        errorMessage = nil

        ApiService.shared.fetchPosts { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let posts):
                    self.posts = posts
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
