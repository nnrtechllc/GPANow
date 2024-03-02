//
//  GpaBud.swift
//  GPANow
//
//  Created by Nikhil Vaddey on 2/18/24.
//

import SwiftUI
import OpenAI


class ChatController: ObservableObject{
    @Published var messages: [Message] = [.init(content: "Hello", isUser: true), .init(content: "Hello", isUser: false)]
    
    
    let openAI = OpenAI(apiToken: "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")
    
    
    func sendNewMessage(content:String) {
        let userMessage = Message(content: content, isUser: true)
        
        self.messages.append(userMessage)
        getBotReply()
    }
    func getBotReply(){
        openAI.chats(query: .init(model: .gpt3_5Turbo,
                                  messages: self.messages.map({Chat(role: .user, content: $0.content)}))) { result in
            
            switch result {
            case .success(let success):
                guard let choice = success.choices.first else {
                    return
                }
                let message = choice.message.content
                DispatchQueue.main.async{
                    self.messages.append(Message(content: message ?? "",isUser: false))
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

struct Message: Identifiable{
    var id: UUID = .init()
    var content:String
    var isUser: Bool
}

struct GpaBud: View {
    @StateObject var chatController: ChatController = .init()
    @State var string: String = ""
    var body: some View {
        VStack{
            ScrollView{
                ForEach(chatController.messages){
                    message in
                    MessageView(message: message)
                }
            }
            HStack{
                TextField("Message.....", text: self.$string, axis: .vertical)
                    .padding(5)
                Button{
                    self.chatController.sendNewMessage(content: string)
                    string = ""
                } label: {
                    Image(systemName: "paperplane")
                }
            }
            .padding()
        }
    }
}

struct MessageView: View{
    var message: Message
    var body: some View {
        Group {
            if message.isUser {
                HStack{
                    Spacer()
                    Text(message.content)
                        .padding()
                        .padding().background(Color.blue)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                }
            }else {
                HStack{
                    
                    Text(message.content)
                        .padding()
                        .padding().background(Color.green)
                        .foregroundColor(Color.white)
                        .clipShape(Capsule())
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    GpaBud ()
}
