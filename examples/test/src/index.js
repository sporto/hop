'use strict';

var config = window.CONFIG;

if (config == null) {
	throw new Error('Expected config');
}

if (config.hash == null) {
	throw new Error('Expected config.hash');
}

if (config.basePath == null) {
	throw new Error('Expected config.basePath');
}

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');
var app = Elm.Main.embed(mountNode,  config);
