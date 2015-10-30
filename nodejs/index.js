'use strict'

var http = require('http');
var fs = require('fs');

http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('running - add node programm to listen on port 2500');
}).listen(2500);

console.log('running - add node programm to listen on port 2500');