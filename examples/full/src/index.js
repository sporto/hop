'use strict';

require('basscss-btn/css/btn.css');
require('basscss-btn-primary/css/btn-primary.css');
require('basscss-btn-sizes/css/btn-sizes.css');
require('basscss-colors/css/colors.css');
require('basscss-background-colors/css/background-colors.css');
require('basscss/css/basscss.css');

require('./global.css');

// Require index.html so it gets copied to dist
// require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var app = Elm.embed(Elm.Main, mountNode);
