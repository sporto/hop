'use strict';

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

var config = {
	basePath: '',
	hash: true,
}
var app = Elm.embed(Elm.Main, mountNode, {config: config});
