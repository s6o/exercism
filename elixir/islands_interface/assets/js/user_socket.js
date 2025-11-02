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

let gameIcon          = document.querySelector("#game-icon")
let gameInfo          = document.querySelector("#game-info")
let gamesWaiting      = document.querySelector("#games-waiting")
let gameStart         = document.querySelector("#game-start")
let gameJoin          = document.querySelector("#game-join")
let player1           = document.querySelector("#player1")
let playerReady       = document.querySelector("#player-ready")
let player2           = document.querySelector("#player2")


let gameLobby = socket.channel("game:lobby");
gameLobby.join()
  .receive("ok", resp => {
    notify("Entered game lobby, start a game or join an existing player.")
    gamesWaiting.textContent = `Games waiting: ${resp.players}`
  })
  .receive("error", resp => {
    console.log("Unable to join game lobby.", resp)
    notifyError("Unable to join game lobby.")
  })
gameLobby.on("games_waiting", payload => {
  gamesWaiting.textContent = `Games waiting: ${payload.players}`;
})

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
  if (event.key === 'Enter') {
    let player = player1.value
    let topic = "game:" + player1.value

    if (player.length > 0) {
      let gameChannel = socket.channel(topic, {player: player});

      gameChannel.on("players_added", payload => {
        notify(payload[player])
      })
      gameChannel.on("show_subscribers", payload => {
        console.log("Show subscribers", payload)
      })

      gameChannel.join()
        .receive("ok", resp => {
          let payload = {player: player}
          console.log("New game payload", payload, player)
          gameChannel.push("new_game", payload).receive("ok", resp => {
            notify(`Game with ${player} waiting for 2nd player.`)
            gameStart.style.display = "none"
            gameJoin.style.display = "none"
          })
          gameChannel.push("show_subscribers")
        })
        .receive("error", resp => {
          console.log("Unable to create game", resp)
          notifyError("Unable to create game")
        })
      player1.value = ""
    }
  }
})

player2.addEventListener("keypress", event => {
  if (event.key === 'Enter') {
    let player1Name = playerReady.value;
    let player2Name = player2.value;
    let topic = "game:" + player1Name;

    if (player1Name.length > 0 && player2Name.length > 0) {
      gameChannel = socket.channel(topic, {player: player2Name});

      gameChannel.on("players_added", payload => {
        notify(payload[player2Name])
      })
      gameChannel.on("show_subscribers", payload => {
        console.log("Show subscribers", payload)
      })

      gameChannel.join()
        .receive("ok", resp => {
          payload = {player1: player1Name, player2: player2Name}
          gameChannel.push("add_player", payload).receive("ok", resp => {
            gameStart.style.display = "none"
            gameJoin.style.display = "none"
          })
        })
        .receive("error", resp => {
          console.log("Unable to join game", resp)
          notifyError("Unable to join game.")
        })
      gameChannel.push("show_subscribers")
      playerReady.value = ""
      player2.value = ""
    }
  }
})

export default socket
