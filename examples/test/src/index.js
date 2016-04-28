'use strict';

require('ace-css/css/ace.css');

// Require index.html so it gets copied to dist
// require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var app = Elm.embed(Elm.Main, mountNode);
