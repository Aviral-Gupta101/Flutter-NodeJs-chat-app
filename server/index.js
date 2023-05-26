const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);

const PORT = 3000;

// var rooms = [];

app.get('/', (req, res) => {
  res.send("Hello world");
});

io.on('connection', (socket) => {
  console.log('a user connected to NodeJs');
  socket.emit("connected", "Connection Successful to NodeJS");

  // Send Message

  socket.on("send-message", (roomid, user, msg) => {
    console.log("Recieved: " + roomid + " " + user + " " + msg);
    socket.emit("recieve-msg", [user, msg]);
  });

  // create new room
  socket.on("create-room", (roomid) => {
    console.log("Joined Room : " + roomid);
    socket.join(roomid);
    // rooms.push(roomid);qn
  });

  // leave room

  socket.on("leave-room", (roomid) => {
    console.log("Leaving Room : " + roomid);
    socket.leave(roomid);
  });

});

server.listen(PORT, () => {
  console.log('listening on http://localhost:'+PORT);
});