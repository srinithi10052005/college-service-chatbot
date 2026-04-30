// frontend/script.js

console.log("JS FILE LOADED");

let selectedLanguage = "English";

function selectLanguage(lang) {
  selectedLanguage = lang;

  // Change button colors dynamically
  const btnEnglish = document.getElementById("btn-english");
  const btnTamil = document.getElementById("btn-tamil");

  if (btnEnglish && btnTamil) {
    if (lang === "English") {
      btnEnglish.classList.add("active-lang");
      btnTamil.classList.remove("active-lang");
    } else if (lang === "Tamil") {
      btnTamil.classList.add("active-lang");
      btnEnglish.classList.remove("active-lang");
    }
  }

  // Change the welcome message text
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
  const inputField = document.getElementById("userInput");
  const message = (inputField?.value || "").trim();

  if (message === "") return;

  addMessageToChat(message, "user");
  inputField.value = "";

  // Always use the language selected by the user via the language buttons.
  // Do NOT override based on the script of the typed text — this ensures
  // that typing English words while Tamil mode is active still returns Tamil replies.
  const requestLanguage = selectedLanguage;

  fetch("../backend/api/chatbot.php", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      message: message,
      language: requestLanguage,
    }),
  })
    .then((res) => res.text())
    .then((txt) => {
      try {
        const data = JSON.parse(txt);
        const reply = data.reply || "No reply from server.";
        addMessageToChat(reply, "bot");
      } catch (e) {
        console.error("JSON Parse Error:", e);
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

  if (sender === "bot") {
    messageElement.innerHTML = formatBotReply(message);
  } else {
    messageElement.innerText = message;
  }

  chatBox.appendChild(messageElement);
  chatBox.scrollTop = chatBox.scrollHeight;
}

function formatBotReply(message) {
  if (!message) return "";

  const safeMessage = escapeHtml(message);

  if (safeMessage.toLowerCase().startsWith("available services:")) {
    const serviceText = safeMessage.substring("Available services:".length).trim();

    if (serviceText.includes(",")) {
      const services = serviceText
        .split(",")
        .map((item) => item.trim())
        .filter((item) => item !== "");

      if (services.length > 0) {
        let formattedReply = "<strong>Available services:</strong><br><br>";
        services.forEach((service, index) => {
          formattedReply += `${index + 1}. ${service}<br>`;
        });
        return formattedReply;
      }
    }
  }

  return safeMessage.replace(/\n/g, "<br>");
}

function escapeHtml(text) {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#039;");
}
