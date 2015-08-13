fs = require('fs')
express = require('express')
serveStatic = require('serve-static')
path = require('path')

module.exports.run = (worker) ->
  console.log '   >> Worker PID:', process.pid
  app = require('express')()
  httpServer = worker.httpServer
  scServer = worker.scServer
  debugger
  app.use serveStatic(path.resolve(__dirname, 'public'))
  httpServer.on 'request', app

  ###
    In here we handle our incoming realtime connections and listen for events.
  ###

  scServer.on 'connection', (socket) ->
    new_data = []
    socket.on 'ping', (data, res) ->
      if res
        console.log 'Chat', data
        socket.emit 'ping', data
        new_data.push Success: 'Successfully Recieved'
        res null, JSON.stringify(new_data)
        #   scServer.global.publish('pong',''+JSON.stringify(new_data));
      else
        new_data.push Error: 'Connection Error'
        res null, JSON.stringify(new_data)
      return
    interval = setInterval((->
      socket.emit 'rand', rand: Math.floor(Math.random() * 5)
      return
    ), 100000000)
    socket.on 'disconnect', ->
      clearInterval interval
      console.log 'Client Connection is disconnected'
      return
    return
  return
