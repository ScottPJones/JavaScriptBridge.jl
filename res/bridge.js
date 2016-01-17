"use strict";

var Julia = (function () {

    var sock = new WebSocket('ws://'+window.location.host);
    sock.onmessage = function( message ){
        var msg = JSON.parse(message.data);
        console.log(msg);
        var type = msg.type,
            data = msg.data;
        switch(type) {
            case "script":
                eval(data);
                break
        }
    }

    function message(name,args) {
        sock.send(JSON.stringify({"name":name,"args":args}))
    }

    var addget = function (c, name) {
		Object.defineProperty(c, name, {
			get: function () { return eval(name); },
			enumerable: true,
			configurable: true
		});
		return c;
	};

    var c = {};
    c = addget(c, "sock");
    c = addget(c, "message");
	return c;
})();
