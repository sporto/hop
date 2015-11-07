import router5 from 'router5'

// console.log(Router5)

const router = new router5.Router5()
    .addNode('home',       '/home')
    .addNode('users',      '/users')
    .addNode('users.show', '/users/:id')
    .start();

// console.log(router);
var mount = document.getElementById('app');
var elmApp = Elm.embed(Elm.Router5, mount, {});

elmApp.ports.routeChange.subscribe(function(message) {
  // console.log(message);
  const parts = message.split(' ');
  if (parts[0] === 'ChangeRoute') {
    const route = parts[1];
    console.log('route', route);
    router.navigate('section', {section: 'home'}, {}, function (err, state) {
    	console.log(err)
		});
  }
});
