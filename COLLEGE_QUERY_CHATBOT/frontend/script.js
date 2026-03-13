// frontend/script.js

console.log("JS FILE LOADED");

let selectedLanguage = "English";

function selectLanguage(lang) {
  selectedLanguage = lang;

  const botMessage = document.getElementById("botMessage");
  if (botMessage) {
    if (lang === "Tamil") {
      botMessage.innerHTML =
        "👋 SDNB ASKNOVA-விற்கு வரவேற்கிறோம். உங்கள் கேள்விகளுக்கு உதவ நான் இங்கு இருக்கும் உங்கள் சேவை உதவியாளர் 😊.";
    } else {
      botMessage.innerHTML =
        "👋 Welcome to SDNB ASKNOVA. I am your service assistant, here to assist you with your inquiries 😊.";
    }
  }
}

document.getElementById("userInput").addEventListener("keydown", function (event) {
  if (event.key === "Enter") {
    event.preventDefault();
    sendMessage();
  }
});

function sendMessage() {
  console.log("Button clicked");

  const inputField = document.getElementById("userInput");
  const message = (inputField?.value || "").trim();
  if (message === "") return;

  addMessageToChat(message, "user");
  inputField.value = "";

  console.log("Calling API...");

  fetch("../backend/api/chatbot.php", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ message: message, language: selectedLanguage }),
  })
    .then((res) => {
      console.log("Status:", res.status);
      return res.text();
    })
    .then((txt) => {
      console.log("Raw response:", txt);

      try {
        const data = JSON.parse(txt);
        addMessageToChat(data.reply || "No reply from server.", "bot");
      } catch (e) {
        addMessageToChat("Server returned non-JSON: " + txt, "bot");
      }
    })
    .catch((err) => {
      console.error("Fetch error:", err);
      addMessageToChat("Fetch failed. Check Network/Console.", "bot");
    });
}

function addMessageToChat(message, sender) {
  const chatBox = document.getElementById("chatBody");
  const messageElement = document.createElement("div");
  messageElement.classList.add(sender + "-message");
  messageElement.innerText = message;
  chatBox.appendChild(messageElement);
  chatBox.scrollTop = chatBox.scrollHeight;
}