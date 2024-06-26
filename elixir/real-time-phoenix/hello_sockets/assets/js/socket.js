// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import { Socket } from 'phoenix';

let socket = new Socket('/socket', { params: { token: window.userToken } });

let authSocket = new Socket('/auth_socket', {
  params: { token: window.authToken },
});

let statsSocket = new Socket('/stats_socket', {});

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "lib/web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect();

authSocket.onOpen(() => console.log('authSocket connected.'));
authSocket.connect();

statsSocket.connect();

const recurringChannel = authSocket.channel('recurring');
recurringChannel.on('new_token', (payload) => {
  console.log('received new auth token', payload);
});
recurringChannel.join();

const authUserChannel = authSocket.channel(`user:${window.userId}`);
authUserChannel.on('push', (payload) => {
  console.log('received auth user push', payload);
});
authUserChannel.join();

authUserChannel.on('push_timed', (payload) => {
  console.log('received timed auth user push', payload);
});

const statsChannelInvalid = statsSocket.channel('invalid');
statsChannelInvalid.join().receive('error', () => statsChannelInvalid.leave());

const statsChannelValid = statsSocket.channel('valid');
statsChannelValid.join();

for (let i = 0; i < 5; i++) {
  statsChannelValid.push('ping', {});
}

for (let i = 0; i < 5; i++) {
  statsChannelValid
    .push('parallel_slow_ping', {})
    .receive('ok', () => console.log('Parallel slow ping response', i));
}

const dupeChannel = socket.channel('dupe');
dupeChannel.on('number', (payload) => {
  console.log('new number received', payload);
});
dupeChannel.join();

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel('ping', {});
channel
  .join()
  .receive('ok', (resp) => {
    console.log('Joined successfully', resp);
  })
  .receive('error', (resp) => {
    console.log('Unable to join', resp);
  });

channel.on('send_ping', (payload) => {
  console.log('ping requested', payload);
  channel.push('ping').receive('ok', (resp) => console.log('ping:', resp.ping));
});

console.log('send ping');
channel.push('ping').receive('ok', (resp) => console.log('receive', resp.ping));

channel
  .push('param_ping', { error: true })
  .receive('error', (resp) => console.error('param_ping error:', resp));
channel
  .push('param_ping', { error: false, arr: [1, 2] })
  .receive('ok', (resp) => console.log('param_ping ok:', resp));

export default socket;
