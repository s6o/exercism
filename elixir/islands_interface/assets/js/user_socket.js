// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"

// And connect to the path in "lib/islands_interface_web/endpoint.ex". We pass the
// token for authentication.
//
// Read the [`Using Token Authentication`](https://hexdocs.pm/phoenix/channels.html#using-token-authentication)
// section to see how the token should be used.
let socket = new Socket("/socket", {authToken: window.userToken})
socket.connect()

// Initialized game Channels waiting for 2nd player
let gameChannels = [];
// Channels with a game were both players have joined
let activeGames = [];

let gameIcon          = document.querySelector("#game-icon")
let gameInfo          = document.querySelector("#game-info")
let player1           = document.querySelector("#player1")
let player2           = document.querySelector("#player2")

function notify(message) {
  gameIcon.className = "alert"
  gameInfo.innerHTML = message;
}

function notifyError(message) {
  gameIcon.className = "alert alert-error"
  gameInfo.innerHTML = message;
}

function notifyWarning(message) {
  gameIcon.className = "alert alert-warning"
  gameInfo.innerHTML = message;
}


player1.addEventListener("keypress", event => {
  if (event.key === 'Enter' && player1.value.length > 0) {
    topic = "game:" + player1.value
    let topicChannel = gameChannels.filter((ch, _, __) => ch.topic == topic)[0]
    console.log("Topic channel", topicChannel)
    if (topicChannel) {
      topicChannel.push("new_game")
    } else {
      gameChannels.push(socket.channel("game:" + player1.value))
      index = gameChannels.length - 1;
      gameChannels[index].join()
        .receive("ok", resp => {
          let players = gameChannels.map((ch) => ch.topic.split(":")[1]).join(", ")
          notify("Games waiting: " + players)
          gameChannels[index].push("new_game")
        })
        .receive("error", resp => {
          console.log("Unable to join game", resp)
          notifyError("Unable to create game")
        })
    }
    player1.value = ""
  }
})

player2.addEventListener("keypress", event => {
  if (event.key === 'Enter') {
    if (gameChannels.length > 0 && player2.value.length > 0) {
      activateChannel = gameChannels.shift()
      let p1 = activateChannel.topic.split(":")[1];
      let p2 = player2.value
      activeGames.push(activateChannel)
      activateChannel.push("add_player", p2).receive("error", resp => {
        notifyError("Unable to add new player: " + p2)
        console.log("Unable to add new player: " + p2, resp)
      })
      activateChannel.on("player_added", resp => {
        notify(`New Game with ${p1} and ${p2}`)
      })
    } else {
      notifyWarning("No active games to join, initialize one first.")
    }
    player2.value = ""
  }
})


export default socket
