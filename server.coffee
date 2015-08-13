argv = require('minimist')(process.argv.slice(2))
SocketCluster = require('socketcluster').SocketCluster
debugger
socketCluster = new SocketCluster(
  workers: Number(argv.w) or 1
  brokers: Number(argv.b) or 1
  port: Number(argv.p) or 8001
  appName: argv.n or null
  workerController: __dirname + '/worker.js'
  socketChannelLimit: 1000
  rebootWorkerOnCrash: argv['auto-reboot'] != false)