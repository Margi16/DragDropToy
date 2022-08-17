//
//  BabyToyView.swift
//  DragDropToy
//
//  Created by Margi  Bhatt on 31/07/22.
//

import SwiftUI

struct Response: Codable {
  let success: Bool
}

struct BabyToyView: View {
    @StateObject private var viewModel = ToyViewModel()
    @ObservedObject var resData: ResponseData
    let gridItems = [
        GridItem(.flexible())
    ]
    @State private var resultString: String = ""
    var drag: some Gesture {
        DragGesture()
            .onChanged { state in
                viewModel.update(dragPosition: state.location)
            }
            .onEnded { state in
                viewModel.update(dragPosition: state.location)
                withAnimation {
                    viewModel.confirmWhereToyWasDropped()
                }
            }
    }
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 20).frame(width: UIScreen.main.bounds.width/1.2, height: UIScreen.main.bounds.height/3, alignment: .top)
                    .foregroundColor(.white)
                    .padding()
                Text(resData.responseData)
            }
            
            ZStack {
                LazyVGrid(columns: gridItems, spacing: 100) {
                ForEach(viewModel.toyContainers, id: \.id) { toy in
                    ToyContainer(
                        toy: toy,
                        viewModel: viewModel
                    )
//                    .background(Color.green)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3, alignment: .center)
                    
                }
            }
                if let currentToy = viewModel.currentToy {
                    DraggableToy(
                        toy: currentToy,
                        position: viewModel.currentPosition,
                        gesture: drag
                    )
                    .opacity(viewModel.draggableToyOpacity)
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2, alignment: .top)
                .padding(.bottom,20)
//            .background(.blue)
        }.background(Color.black.opacity(0.8))
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                
            .onAppear {
                viewModel.setNextToy()
            }
            .task {
                resData.loadData()
            }
            .alert(
                Text("Success"),
                isPresented: $viewModel.isGameOver,
                actions: {
                    Button("OK") {

                    }
                }
            )
    }
    
}

class ResponseData: ObservableObject {
    @StateObject private var viewModel = ToyViewModel()
    @Published var responseData: String = ""
    func loadData() {
          guard let successUrl = URL(string: "https://api.mocklets.com/p68348/success_case") else {
            print("Invalid URL")
            return
          }
        guard let failureUrl = URL(string: "https://api.mocklets.com/p68348/failure_case") else {
          print("Invalid URL")
          return
        }
//        print("hello")
        if($viewModel.isGameOver.wrappedValue==true){
            let request = URLRequest(url: successUrl)
            URLSession.shared.dataTask(with: request) { data, response, error in
              if let data = data {
                do {
                 let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                 DispatchQueue.main.async {
                     print("\(decodedResponse.success)")
                         if(decodedResponse.success == true){
                             self.responseData = "Success"
                         }
                  }
                } catch let jsonError as NSError {
                 print("JSON decode failed: \(jsonError.localizedDescription)")
                }
              }
            }.resume()
        }
        else if($viewModel.isGameOver.wrappedValue==false){
            let request = URLRequest(url: failureUrl)
            URLSession.shared.dataTask(with: request) { data, response, error in
              if let data = data {
                do {
                 let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
                 DispatchQueue.main.async {
                     print("\(decodedResponse.success)")
                         if(decodedResponse.success == false){
                             self.responseData = "Failure"
                         }
                  }
                } catch let jsonError as NSError {
                 print("JSON decode failed: \(jsonError.localizedDescription)")
                }
              }
            }.resume()
        }
        }
}

struct BabyToyView_Previews: PreviewProvider {
    static var previews: some View {
        BabyToyView(resData: ResponseData())
    }
}

