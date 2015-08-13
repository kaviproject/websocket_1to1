var fs = require('fs');
var express = require('express');
var serveStatic = require('serve-static');
var path = require('path');

module.exports.run = function(worker) {
    console.log('   >> Worker PID:', process.pid);
    var app = require('express')();
    var httpServer = worker.httpServer;
    var scServer = worker.scServer;
    debugger;
    app.use(serveStatic(path.resolve(__dirname, 'public')));

    httpServer.on('request', app);

    /*
      In here we handle our incoming realtime connections and listen for events.
    */
    scServer.on('connection', function(socket) {
         var new_data=[];

        socket.on('ping', function(data, res) {
            if (res) {
             console.log('Chat', data);

             socket.emit('ping', data);
          new_data.push({Success:"Successfully Recieved"});
         res(null,JSON.stringify(new_data));

          //   scServer.global.publish('pong',''+JSON.stringify(new_data));
           
            } else {
               new_data.push({Error:"Connection Error"});

                res(null,JSON.stringify(new_data))
            }
        });

        var interval = setInterval(function() {
            socket.emit('rand', {
                rand: Math.floor(Math.random() * 5)
            });
        }, 100000000);

        socket.on('disconnect', function() {
            clearInterval(interval);
            console.log('Client Connection is disconnected')
        });
    });
};
