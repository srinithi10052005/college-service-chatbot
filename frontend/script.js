function sendMessage() {
  const input = document.getElementById("userInput");
  const message = input.value.trim();

  if (message === "") return;

  const chatBody = document.getElementById("chatBody");

  // User message
  const userMsg = document.createElement("div");
  userMsg.className = "bot-message";
  userMsg.style.background = "#d1e7dd";
  userMsg.style.marginLeft = "auto";
  userMsg.textContent = message;

  chatBody.appendChild(userMsg);

  input.value = "";
  chatBody.scrollTop = chatBody.scrollHeight;
}

function selectLanguage(lang) {
  alert("Language selected: " + lang);
}

