// Generated by Haxe 3.4.6
(function () { "use strict";
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var motors = ["M3","M4"].map(($_=trik_Trik.brick,$bind($_,$_.motor)));
	var _g = 0;
	while(_g < motors.length) {
		var motor = motors[_g];
		++_g;
		motor.setPower(100);
	}
	trik_Trik.script.wait(1000);
	trik_Trik.print(10);
};
Math.__name__ = true;
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) {
					return o[0];
				}
				var str = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i = _g1++;
					if(i != 2) {
						str += "," + js_Boot.__string_rec(o[i],s);
					} else {
						str += js_Boot.__string_rec(o[i],s);
					}
				}
				return str + ")";
			}
			var l = o.length;
			var i1;
			var str1 = "[";
			s += "\t";
			var _g11 = 0;
			var _g2 = l;
			while(_g11 < _g2) {
				var i2 = _g11++;
				str1 += (i2 > 0 ? "," : "") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var k = null;
		var str2 = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str2.length != 2) {
			str2 += ", \n";
		}
		str2 += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str2 += "\n" + s + "}";
		return str2;
	case "string":
		return o;
	default:
		return String(o);
	}
};
var trik_robot_Brick = function() {
	this.accelerometer = brick.accelerometer();
	this.battery = brick.battery();
	this.display = brick.display();
	this.keys = new trik_robot_keys_KeysHigher(brick.display());
	this.led = brick.led();
	this.gyroscope = brick.gyroscope();
};
trik_robot_Brick.__name__ = true;
trik_robot_Brick.prototype = {
	encoder: function(port) {
		return brick.encoder(port);
	}
	,motor: function(port) {
		return brick.motor(port);
	}
	,colorSensor: function(port) {
		return brick.colorSensor(port);
	}
	,playSound: function(filename) {
		brick.playSound(filename);
	}
	,say: function(phrase) {
		brick.say(phrase);
	}
	,sensor: function(port) {
		return brick.sensor(port);
	}
	,stop: function() {
		brick.stop();
	}
	,objectSensor: function(port) {
		return brick.objectSensor(port);
	}
	,getPhoto: function() {
		return getPhoto();
	}
};
var trik_robot_keys_KeysHigher = function(lowerKeys) {
	this.lowerKeys = lowerKeys;
};
trik_robot_keys_KeysHigher.__name__ = true;
trik_robot_keys_KeysHigher.prototype = {
	keyToCode: function(key) {
		var res = 0;
		switch(key[1]) {
		case 0:
			res = 105;
			break;
		case 1:
			res = 103;
			break;
		case 2:
			res = 108;
			break;
		case 3:
			res = 28;
			break;
		case 4:
			res = 106;
			break;
		case 5:
			res = 116;
			break;
		case 6:
			res = 1;
			break;
		}
		return res;
	}
	,isPressed: function(key) {
		return this.lowerKeys.isPressed(this.keyToCode(key));
	}
	,wasPressed: function(key) {
		return this.lowerKeys.wasPressed(this.keyToCode(key));
	}
};
var trik_robot_Mailbox = function() {
};
trik_robot_Mailbox.__name__ = true;
trik_robot_Mailbox.prototype = {
	connect: function(ip,port) {
		if(port == null) {
			port = -1;
		}
		if(port == -1) {
			mailbox.connect(ip);
		} else {
			mailbox.connect(ip, port);
		}
	}
	,hasMessages: function() {
		return mailbox.hasMessages();
	}
	,myHullNumber: function() {
		return mailbox.myHullNumber();
	}
	,receive: function() {
		return mailbox.receive();
	}
	,send: function(message,robotNumber) {
		if(robotNumber == null) {
			robotNumber = -1;
		}
		if(robotNumber == -1) {
			mailbox.send(message);
		} else {
			mailbox.send(robotNumber, message);
		}
	}
};
var trik_robot_Script = function() {
};
trik_robot_Script.__name__ = true;
trik_robot_Script.prototype = {
	quit: function() {
		script.quit();
	}
	,random: function(from,to) {
		return script.random(from, to);
	}
	,readAll: function(filename) {
		return script.readAll(filename);
	}
	,removeFile: function(filename) {
		script.removeFile(filename);
	}
	,run: function() {
		script.run();
	}
	,system: function(command) {
		script.system(command);
	}
	,time: function() {
		return script.time();
	}
	,wait: function(duration) {
		return script.wait(duration);
	}
	,writeToFile: function(filename,content) {
		return script.writeToFile(filename, content);
	}
};
var trik_Trik = function() { };
trik_Trik.__name__ = true;
trik_Trik.print = function(text) {
	print(text);
};
var trik_robot_keys_Key = { __ename__ : true, __constructs__ : ["Left","Up","Down","Enter","Right","Power","Esc"] };
trik_robot_keys_Key.Left = ["Left",0];
trik_robot_keys_Key.Left.__enum__ = trik_robot_keys_Key;
trik_robot_keys_Key.Up = ["Up",1];
trik_robot_keys_Key.Up.__enum__ = trik_robot_keys_Key;
trik_robot_keys_Key.Down = ["Down",2];
trik_robot_keys_Key.Down.__enum__ = trik_robot_keys_Key;
trik_robot_keys_Key.Enter = ["Enter",3];
trik_robot_keys_Key.Enter.__enum__ = trik_robot_keys_Key;
trik_robot_keys_Key.Right = ["Right",4];
trik_robot_keys_Key.Right.__enum__ = trik_robot_keys_Key;
trik_robot_keys_Key.Power = ["Power",5];
trik_robot_keys_Key.Power.__enum__ = trik_robot_keys_Key;
trik_robot_keys_Key.Esc = ["Esc",6];
trik_robot_keys_Key.Esc.__enum__ = trik_robot_keys_Key;
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.__name__ = true;
Array.__name__ = true;
trik_Trik.brick = new trik_robot_Brick();
trik_Trik.script = new trik_robot_Script();
trik_Trik.mailbox = new trik_robot_Mailbox();
Main.main();
})();