// import consumer from "channels/consumer"

// consumer.subscriptions.create("MessageChannel", {
//   connected() {
//     // Called when the subscription is ready for use on the server
//   },

//   disconnected() {
//     // Called when the subscription has been terminated by the server
//   },

//   received(data) {
//     // Called when there's incoming data on the websocket for this channel
//   }
// });
import { createConsumer } from "@rails/actioncable";

const consumer = createConsumer();
console.log("message channel connection")

document.addEventListener("DOMContentLoaded", () => {
  const chatContainer = document.getElementById("chat-messages");
  const messagesContainer = document.getElementById("messages");
  console.log(chatContainer.dataset)
  console.log(chatContainer.dataset.chatRoomId);
  const chatRoomId = chatContainer.dataset.chatRoomId;



  consumer.subscriptions.create(
    { channel: "MessageChannel", chat_room_id: chatRoomId },
    {
      connected() {
        console.log("Connected to the message channel for chatroom:", chatRoomId);
      },

      disconnected() {
        console.log("Disconnected from the message channel for chatroom:", chatRoomId);
      },

      received(data) {
        const messageElement = `<div><strong>${data.user}</strong>: ${data.message} <small>${data.created_at}</small></div>`;
        console.log(messageElement);
        messagesContainer.insertAdjacentHTML("beforeend", messageElement);
      },
    }
  );
});