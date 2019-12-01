// Generated by Haxe 3.4.6
(function ($global) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var trik_robotModel_RobotModel = function(args) {
	this.rotateCount = 0;
	this.leftMotor = args.leftMotor;
	this.rightMotor = args.rightMotor;
	this.leftEncoder = args.leftEncoder;
	this.rightEncoder = args.rightEncoder;
	this.cameraPort = this.nullcoalescence_String(args.cameraPort,"video1");
	this.environment = args.environment;
};
trik_robotModel_RobotModel.__name__ = true;
trik_robotModel_RobotModel.prototype = {
	nullcoalescence_trik_time_Time: function(value,defaultValue) {
		if(value == null) {
			return defaultValue;
		} else {
			return value;
		}
	}
	,nullcoalescence_String: function(value,defaultValue) {
		if(value == null) {
			return defaultValue;
		} else {
			return value;
		}
	}
	,stop: function(delayTime) {
		delayTime = this.nullcoalescence_trik_time_Time(delayTime,trik_time_Time.Milliseconds(0));
		this.leftMotor.setPower(0);
		this.rightMotor.setPower(0);
		trik_robot__$ScriptHigher_ScriptHigher_$Impl_$.wait(trik_Trik.script,delayTime);
	}
	,resetEncoders: function() {
		this.leftEncoder.reset();
		this.rightEncoder.reset();
	}
	,calibrateGyro: function(duration) {
		duration = this.nullcoalescence_trik_time_Time(duration,trik_time_Time.Seconds(10));
		trik_robot_gyroscope__$GyroscopeHigher_GyroscopeHigher_$Impl_$.calibrate(trik_Trik.brick.gyroscope,duration);
	}
	,readGyro: function() {
		return trik_Trik.brick.gyroscope.read()[6] / 1000;
	}
	,readGyro360: function() {
		return (360 - this.readGyro()) % 360;
	}
	,move: function(speed,setpoint,readF,koefficients,condition,interval) {
		if(speed == null) {
			speed = 100;
		}
		interval = this.nullcoalescence_trik_time_Time(interval,trik_time_Time.Seconds(0.1));
		this.resetEncoders();
		var pid = new trik_pid_PID(interval,-100,100,koefficients);
		while(true) {
			var u = pid.calculate(readF(),setpoint);
			this.leftMotor.setPower(Math.round(speed + u));
			this.rightMotor.setPower(Math.round(speed - u));
			if(condition == null) {
				return;
			}
			trik_robot__$ScriptHigher_ScriptHigher_$Impl_$.wait(trik_Trik.script,interval);
			if(!condition()) {
				break;
			}
		}
		this.stop(trik_time_Time.Seconds(0.1));
	}
	,moveGyro: function(speed,condition,interval) {
		if(speed == null) {
			speed = 100;
		}
		var direction = (this.rotateCount + 2) % 4 - 2;
		this.move(speed,90 * direction,$bind(this,this.readGyro),{ kp : 13, kd : 8, ki : 0.03},condition,interval);
	}
	,turnSimulator: function(angle,speed) {
		var deg = 250;
		if(angle == 90) {
			this.leftMotor.setPower(speed);
			this.rightMotor.setPower(-speed);
			while(this.leftEncoder.read() < deg) trik_robot__$ScriptHigher_ScriptHigher_$Impl_$.wait(trik_Trik.script,trik_time_Time.Milliseconds(1));
			this.rotateCount += 1;
		} else {
			this.leftMotor.setPower(-speed);
			this.rightMotor.setPower(speed);
			while(this.rightEncoder.read() < deg) trik_robot__$ScriptHigher_ScriptHigher_$Impl_$.wait(trik_Trik.script,trik_time_Time.Milliseconds(1));
			this.rotateCount -= 1;
		}
		this.stop(trik_time_Time.Seconds(0.1));
	}
	,turn: function(angle,speed) {
		if(speed == null) {
			speed = 50;
		}
		this.resetEncoders();
		var _g = this.environment;
		if(_g[1] == 1) {
			this.turnSimulator(angle,speed);
		} else {
			return;
		}
	}
	,__class__: trik_robotModel_RobotModel
};
var FinalModel = function(args) {
	trik_robotModel_RobotModel.call(this,args);
	this.frontSensor = args.frontSensor;
	this.leftSensor = args.leftSensor;
};
FinalModel.__name__ = true;
FinalModel.__super__ = trik_robotModel_RobotModel;
FinalModel.prototype = $extend(trik_robotModel_RobotModel.prototype,{
	moveWall: function(speed,setpoint,condition,interval) {
		if(speed == null) {
			speed = 100;
		}
		var _gthis = this;
		this.move(speed,setpoint,function() {
			var readVal = _gthis.leftSensor.read();
			if(Math.abs(readVal - setpoint) > 3) {
				return setpoint;
			} else {
				return readVal;
			}
		},{ kp : 0.5},condition,interval);
	}
	,solution: function() {
		var _gthis = this;
		var leftStart = this.leftSensor.read();
		var leftMax = leftStart;
		var maxIndex = -1;
		var count = 0;
		var countLock = false;
		var readPrev = leftStart;
		this.moveWall(90,leftStart,function() {
			var readVal = _gthis.leftSensor.read();
			if(!countLock && readPrev - readVal < -4) {
				count += 1;
				countLock = true;
			}
			if(countLock && readPrev - readVal > 4) {
				countLock = false;
			}
			if(Math.abs(readVal - leftStart) > 10 && readVal > leftMax) {
				leftMax = readVal;
				maxIndex = count;
				trik_Trik.print("new min found " + leftMax + " " + maxIndex);
			}
			readPrev = readVal;
			return _gthis.frontSensor.read() > 25;
		});
		this.stop(trik_time_Time.Seconds(.5));
		this.moveGyro(-90,function() {
			trik_Trik.print(count);
			var readVal1 = _gthis.leftSensor.read();
			if(!countLock && readPrev - readVal1 < -10) {
				count -= 1;
				countLock = true;
			}
			if(countLock && readPrev - readVal1 > 10) {
				countLock = false;
			}
			readPrev = readVal1;
			return count != maxIndex - 1;
		});
		this.stop(trik_time_Time.Seconds(.5));
		this.turn(-90,25);
		this.stop(trik_time_Time.Seconds(.5));
		this.moveGyro(90,function() {
			return _gthis.frontSensor.read() > (leftMax - leftStart) / 2;
		});
		trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.addLabel(trik_Trik.brick.display,"finish",new trik_robot_display_Pixel(0,0));
	}
	,__class__: FinalModel
});
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var model = new FinalModel({ leftMotor : trik_Trik.brick.motor("M4"), rightMotor : trik_Trik.brick.motor("M3"), leftEncoder : trik_Trik.brick.encoder("E4"), rightEncoder : trik_Trik.brick.encoder("E3"), frontSensor : trik_Trik.brick.sensor("D1"), leftSensor : trik_Trik.brick.sensor("D2"), environment : trik_robotModel_Environment.Simulator});
	model.solution();
};
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) {
		v = parseInt(x);
	}
	if(isNaN(v)) {
		return null;
	}
	return v;
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) {
		Error.captureStackTrace(this,js__$Boot_HaxeError);
	}
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.wrap = function(val) {
	if((val instanceof Error)) {
		return val;
	} else {
		return new js__$Boot_HaxeError(val);
	}
};
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
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
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		if((o instanceof Array)) {
			return o.__enum__ == null;
		} else {
			return false;
		}
		break;
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return true;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return (o|0) === o;
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) {
					return true;
				}
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var trik_robot_Brick = function() {
	this.accelerometer = brick.accelerometer();
	this.battery = brick.battery();
	this.display = trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$._new();
	this.keys = trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$._new();
	this.led = brick.led();
	this.gyroscope = trik_robot_gyroscope__$GyroscopeHigher_GyroscopeHigher_$Impl_$._new();
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
	,getRawPhoto: function() {
		return trik_image__$RawImage_RawImage_$Impl_$._new(getPhoto());
	}
	,getPhoto: function() {
		return trik_image__$RawImage_RawImage_$Impl_$.toImage(this.getRawPhoto());
	}
	,__class__: trik_robot_Brick
};
var trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$ = {};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.__name__ = true;
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$._new = function() {
	var this1 = brick.display();
	return this1;
};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.addLabel = function(this1,text,pixel) {
	this1.addLabel(text,pixel.x,pixel.y);
};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.drawArc = function(this1,rect,from,to) {
	this1.drawArc(rect.points[0].x,rect.points[0].y,rect.length,rect.height,from,to);
};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.drawEllipse = function(this1,rect) {
	this1.drawEllipse(rect.points[0].x,rect.points[0].y,rect.length,rect.height);
};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.drawLine = function(this1,line) {
	this1.drawLine(line.first.x,line.first.y,line.second.x,line.second.y);
};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.drawPixel = function(this1,pixel) {
	this1.drawPoint(pixel.x,pixel.y);
};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.drawRect = function(this1,rect) {
	this1.drawRect(rect.points[0].x,rect.points[0].y,rect.length,rect.height);
};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.setBackground = function(this1,color) {
	this1.setBackground(color.name);
};
trik_robot_display__$DisplayHigher_DisplayHigher_$Impl_$.setPainterColor = function(this1,color) {
	this1.setPainterColor(color.name);
};
var trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$ = {};
trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$.__name__ = true;
trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$.keyToCode = function(this1,key) {
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
};
trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$.isPressed = function(this1,key) {
	return this1.isPressed(trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$.keyToCode(this1,key));
};
trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$.wasPressed = function(this1,key) {
	return this1.wasPressed(trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$.keyToCode(this1,key));
};
trik_robot_keys__$KeysHigher_KeysHigher_$Impl_$._new = function() {
	var this1 = brick.keys();
	return this1;
};
var trik_robot_gyroscope__$GyroscopeHigher_GyroscopeHigher_$Impl_$ = {};
trik_robot_gyroscope__$GyroscopeHigher_GyroscopeHigher_$Impl_$.__name__ = true;
trik_robot_gyroscope__$GyroscopeHigher_GyroscopeHigher_$Impl_$._new = function() {
	var this1 = brick.gyroscope();
	return this1;
};
trik_robot_gyroscope__$GyroscopeHigher_GyroscopeHigher_$Impl_$.calibrate = function(this1,duration) {
	var _g = trik_tools_TimeTools.toMilliseconds(duration);
	if(_g[1] == 0) {
		var value = _g[2];
		this1.calibrate(value);
	} else {
		return;
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
	,__class__: trik_robot_Mailbox
};
var trik_robot__$ScriptHigher_ScriptHigher_$Impl_$ = {};
trik_robot__$ScriptHigher_ScriptHigher_$Impl_$.__name__ = true;
trik_robot__$ScriptHigher_ScriptHigher_$Impl_$._new = function() {
	var this1 = script;
	return this1;
};
trik_robot__$ScriptHigher_ScriptHigher_$Impl_$.time = function(this1) {
	return trik_time_Time.Milliseconds(this1.time());
};
trik_robot__$ScriptHigher_ScriptHigher_$Impl_$.wait = function(this1,duration) {
	var _g = trik_tools_TimeTools.toMilliseconds(duration);
	if(_g[1] == 0) {
		var value = _g[2];
		this1.wait(value);
	} else {
		return;
	}
};
var trik_robot_Concurrency = function() {
};
trik_robot_Concurrency.__name__ = true;
trik_robot_Concurrency.prototype = {
	joinThread: function(threadId) {
		Threading.joinThread(threadId);
	}
	,killThread: function(threadId) {
		Threading.killThread(threadId);
	}
	,receiveMessage: function(wait) {
		return Threading.receiveMessage(wait);
	}
	,sendMessage: function(threadId,message) {
		Threading.sendMessage(threadId, message);
		return;
	}
	,startThread: function(threadId,functionName) {
		Threading.startThread(threadId, functionName);
		return;
	}
	,__class__: trik_robot_Concurrency
};
var trik_Trik = function() { };
trik_Trik.__name__ = true;
trik_Trik.print = function(text) {
	print(text);
};
var trik_color_Color = function() { };
trik_color_Color.__name__ = true;
trik_color_Color.prototype = {
	__class__: trik_color_Color
};
var trik_color_BinaryColor = function(value) {
	this.value = value;
};
trik_color_BinaryColor.__name__ = true;
trik_color_BinaryColor.__interfaces__ = [trik_color_Color];
trik_color_BinaryColor.prototype = {
	inverse: function() {
		return new trik_color_BinaryColor(!this.value);
	}
	,__class__: trik_color_BinaryColor
};
var trik_color_HSVColor = function(h,s,v) {
	if(h < 0 || h > 360) {
		throw new js__$Boot_HaxeError("h value must be in the range [0; 360]");
	}
	if(s < 0 || s > 1) {
		throw new js__$Boot_HaxeError("s value must be in the range [0; 1]");
	}
	if(v < 0 || v > 1) {
		throw new js__$Boot_HaxeError("v value must be in the range [0; 1]");
	}
	this.h = h;
	this.s = s;
	this.v = v;
};
trik_color_HSVColor.__name__ = true;
trik_color_HSVColor.__interfaces__ = [trik_color_Color];
trik_color_HSVColor.prototype = {
	__class__: trik_color_HSVColor
};
var trik_color_RGBColor = function(r,g,b) {
	if(r < 0 || r > 255) {
		throw new js__$Boot_HaxeError("r value must be in the range [0; 255]");
	}
	if(g < 0 || g > 255) {
		throw new js__$Boot_HaxeError("g value must be in the range [0; 255]");
	}
	if(b < 0 || b > 255) {
		throw new js__$Boot_HaxeError("b value must be in the range [0; 255]");
	}
	this.r = r;
	this.g = g;
	this.b = b;
};
trik_color_RGBColor.__name__ = true;
trik_color_RGBColor.__interfaces__ = [trik_color_Color];
trik_color_RGBColor.prototype = {
	__class__: trik_color_RGBColor
};
var trik_color_LiteralColor = function(r,g,b,name) {
	trik_color_RGBColor.call(this,r,g,b);
	this.name = name;
};
trik_color_LiteralColor.__name__ = true;
trik_color_LiteralColor.__super__ = trik_color_RGBColor;
trik_color_LiteralColor.prototype = $extend(trik_color_RGBColor.prototype,{
	__class__: trik_color_LiteralColor
});
var trik_color_MonoColor = function(value) {
	if(value < 0 || value > 255) {
		throw new js__$Boot_HaxeError("value of mono color has to be in the range [0; 255]");
	}
	this.value = value;
};
trik_color_MonoColor.__name__ = true;
trik_color_MonoColor.__interfaces__ = [trik_color_Color];
trik_color_MonoColor.prototype = {
	__class__: trik_color_MonoColor
};
var trik_color_RGB24Color = function(value) {
	this.value = value;
	this.r = null;
	this.g = null;
	this.b = null;
};
trik_color_RGB24Color.__name__ = true;
trik_color_RGB24Color.__interfaces__ = [trik_color_Color];
trik_color_RGB24Color.prototype = {
	__class__: trik_color_RGB24Color
};
var trik_geometry_Point = function(x,y) {
	if(y == null) {
		y = 0;
	}
	if(x == null) {
		x = 0;
	}
	this.x = x;
	this.y = y;
};
trik_geometry_Point.__name__ = true;
trik_geometry_Point.prototype = {
	sum: function(point) {
		return new trik_geometry_Point(this.x + point.x,this.y + point.y);
	}
	,sub: function(point) {
		return new trik_geometry_Point(this.x - point.x,this.y - point.y);
	}
	,neg: function() {
		return new trik_geometry_Point(-this.x,-this.y);
	}
	,mul: function(koef) {
		return new trik_geometry_Point(this.x * koef,this.y * koef);
	}
	,div: function(koef) {
		return new trik_geometry_Point(this.x / koef,this.y / koef);
	}
	,scalar_product: function(point) {
		return this.x * point.x + this.y * point.y;
	}
	,vector_product: function(point) {
		return this.x * point.y - this.y * point.x;
	}
	,length: function() {
		return this.scalar_product(this);
	}
	,distTo: function(point) {
		return this.sub(point).length();
	}
	,distToLine: function(a,b) {
		var d = a.distTo(b);
		if(d == 0) {
			throw new js__$Boot_HaxeError("cant define a line with two same points");
		}
		var s = this.sub(a).vector_product(this.sub(b));
		return Math.abs(s) / d;
	}
	,__class__: trik_geometry_Point
};
var trik_geometry_Point3D = function(x,y,z) {
	if(z == null) {
		z = 0;
	}
	if(y == null) {
		y = 0;
	}
	if(x == null) {
		x = 0;
	}
	this.x = x;
	this.y = y;
	this.z = z;
};
trik_geometry_Point3D.__name__ = true;
trik_geometry_Point3D.prototype = {
	distTo: function(point) {
		return Math.sqrt(Math.pow(point.x - this.x,2) + Math.pow(point.y - this.y,2) + Math.pow(point.z - this.z,2));
	}
	,__class__: trik_geometry_Point3D
};
var trik_image__$Image_Image_$Impl_$ = {};
trik_image__$Image_Image_$Impl_$.__name__ = true;
trik_image__$Image_Image_$Impl_$._new = function(pixels) {
	var this1;
	var _g = 0;
	while(_g < pixels.length) {
		var i = pixels[_g];
		++_g;
		if(i.length != pixels[0].length) {
			throw new js__$Boot_HaxeError("all row arrays must have the same length");
		}
	}
	this1 = pixels;
	return this1;
};
trik_image__$Image_Image_$Impl_$.get = function(this1,index) {
	return this1[index];
};
trik_image__$Image_Image_$Impl_$.set = function(this1,index,val) {
	this1[index] = val;
	return val;
};
var trik_image__$RawImage_RawImage_$Impl_$ = {};
trik_image__$RawImage_RawImage_$Impl_$.__name__ = true;
trik_image__$RawImage_RawImage_$Impl_$._new = function(raw_photo) {
	var this1;
	var _g = [];
	var _g2 = 0;
	var _g1 = raw_photo.length;
	while(_g2 < _g1) {
		var i = _g2++;
		_g.push(new trik_color_RGB24Color(Std.parseInt(raw_photo.charAt(i))));
	}
	this1 = _g;
	return this1;
};
trik_image__$RawImage_RawImage_$Impl_$.toImage = function(this1) {
	var w = 160;
	var h = 120;
	var res = [];
	var _g1 = 0;
	var _g = h;
	while(_g1 < _g) {
		var i = _g1++;
		var tmp = [];
		var _g3 = 0;
		var _g2 = w;
		while(_g3 < _g2) {
			var j = _g3++;
			tmp.push(trik_tools_ColorTools.toRGB(this1[w * i + j]));
		}
		res.push(tmp);
	}
	return trik_image__$Image_Image_$Impl_$._new(res);
};
var trik_ordering_Ordering = { __ename__ : true, __constructs__ : ["EQ","GT","LT"] };
trik_ordering_Ordering.EQ = ["EQ",0];
trik_ordering_Ordering.EQ.__enum__ = trik_ordering_Ordering;
trik_ordering_Ordering.GT = ["GT",1];
trik_ordering_Ordering.GT.__enum__ = trik_ordering_Ordering;
trik_ordering_Ordering.LT = ["LT",2];
trik_ordering_Ordering.LT.__enum__ = trik_ordering_Ordering;
var trik_pid_PID = function(interval,min,max,ks) {
	this.integral = 0;
	this.prevError = 0;
	this.interval = interval;
	this.min = min;
	this.max = max;
	this.kp = ks.kp;
	this.kd = ks.kd == null ? 0 : ks.kd;
	this.ki = ks.ki == null ? 0 : ks.ki;
};
trik_pid_PID.__name__ = true;
trik_pid_PID.prototype = {
	calculate: function(value,setpoint) {
		if(setpoint == null) {
			setpoint = 0;
		}
		var error = setpoint - value;
		var pOut = error * this.kp;
		var derivative;
		var _g = trik_tools_TimeTools.toMilliseconds(this.interval);
		if(_g[1] == 0) {
			var timeValue = _g[2];
			this.integral += error * timeValue;
			derivative = error * this.prevError / timeValue;
		} else {
			return 0;
		}
		var iOut = this.integral * this.ki;
		var dOut = derivative * this.kd;
		var res = pOut + iOut + dOut;
		if(res > this.max) {
			res = this.max;
		}
		if(res < this.min) {
			res = this.min;
		}
		this.prevError = error;
		return res;
	}
	,__class__: trik_pid_PID
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
	,__class__: trik_robot_Script
};
var trik_robot_display_Line = function(first,second) {
	this.first = first;
	this.second = second;
};
trik_robot_display_Line.__name__ = true;
trik_robot_display_Line.prototype = {
	__class__: trik_robot_display_Line
};
var trik_robot_display_Pixel = function(x,y) {
	if(y == null) {
		y = 0;
	}
	if(x == null) {
		x = 0;
	}
	if(x < 0 || x > 240) {
		throw new js__$Boot_HaxeError("x value must be in the range [0; 240]");
	}
	if(y < 0 || y > 320) {
		throw new js__$Boot_HaxeError("y value must be in the range [0; 320]");
	}
	this.x = x;
	this.y = y;
};
trik_robot_display_Pixel.__name__ = true;
trik_robot_display_Pixel.prototype = {
	__class__: trik_robot_display_Pixel
};
var trik_robot_display_Rectangle = function(pixel,length,height) {
	try {
		this.points = [pixel,new trik_robot_display_Pixel(pixel.x + length,pixel.y),new trik_robot_display_Pixel(pixel.x + length,pixel.y + height),new trik_robot_display_Pixel(pixel.x,pixel.y + height)];
	} catch( err ) {
		if (err instanceof js__$Boot_HaxeError) err = err.val;
		if( js_Boot.__instanceof(err,String) ) {
			throw new js__$Boot_HaxeError("rectangle doesnt fit in the screen");
		} else throw(err);
	}
	this.length = length;
	this.height = height;
};
trik_robot_display_Rectangle.__name__ = true;
trik_robot_display_Rectangle.prototype = {
	__class__: trik_robot_display_Rectangle
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
var trik_robotModel_Environment = { __ename__ : true, __constructs__ : ["Real","Simulator"] };
trik_robotModel_Environment.Real = ["Real",0];
trik_robotModel_Environment.Real.__enum__ = trik_robotModel_Environment;
trik_robotModel_Environment.Simulator = ["Simulator",1];
trik_robotModel_Environment.Simulator.__enum__ = trik_robotModel_Environment;
var trik_sequence_Sequence = function() { };
trik_sequence_Sequence.__name__ = true;
var trik_time_Time = { __ename__ : true, __constructs__ : ["Milliseconds","Seconds","Minutes"] };
trik_time_Time.Milliseconds = function(value) { var $x = ["Milliseconds",0,value]; $x.__enum__ = trik_time_Time; return $x; };
trik_time_Time.Seconds = function(value) { var $x = ["Seconds",1,value]; $x.__enum__ = trik_time_Time; return $x; };
trik_time_Time.Minutes = function(value) { var $x = ["Minutes",2,value]; $x.__enum__ = trik_time_Time; return $x; };
var trik_tools_ColorTools = function() { };
trik_tools_ColorTools.__name__ = true;
trik_tools_ColorTools.toRGB = function(color) {
	var o = color;
	var _g = o == null ? null : js_Boot.getClass(o);
	switch(_g) {
	case trik_color_BinaryColor:
		if(color.value) {
			return new trik_color_RGBColor(0,0,0);
		} else {
			return new trik_color_RGBColor(255,255,255);
		}
		break;
	case trik_color_HSVColor:
		var h = color.h;
		var s = color.s;
		var v = color.v;
		var fH = Math.max(0,Math.min(360,h)) / 60;
		var fS = Math.max(0,Math.min(1,s));
		var fV = Math.max(0,Math.min(1,v));
		if(fS == 0) {
			return new trik_color_RGBColor(Math.round(v * 255),Math.round(v * 255),Math.round(v * 255));
		}
		var i = Math.floor(h);
		var f = h - i;
		var p = v * (1 - s);
		var q = v * (1 - s * f);
		var t = v * (1 - s * (1 - f));
		var res;
		switch(i) {
		case 0:
			res = [v,t,p];
			break;
		case 1:
			res = [q,v,p];
			break;
		case 2:
			res = [p,v,t];
			break;
		case 3:
			res = [p,q,v];
			break;
		case 4:
			res = [t,p,v];
			break;
		default:
			res = [v,p,q];
		}
		return new trik_color_RGBColor(Math.round(res[0] * 255),Math.round(res[1] * 255),Math.round(res[2] * 255));
	case trik_color_MonoColor:
		return new trik_color_RGBColor(color.value,color.value,color.value);
	case trik_color_RGB24Color:
		return new trik_color_RGBColor((color.value & 16711680) >> 16,(color.value & 65280) >> 8,color.value & 255);
	case trik_color_RGBColor:
		return color;
	default:
		throw new js__$Boot_HaxeError("unknown color class was passed to the generic function colorToRgb");
	}
};
trik_tools_ColorTools.toHSV = function(color) {
	var o = color;
	var _g = o == null ? null : js_Boot.getClass(o);
	if(_g == trik_color_HSVColor) {
		return color;
	} else {
		var rgbColor = trik_tools_ColorTools.toRGB(color);
		var r = rgbColor.r;
		var g = rgbColor.g;
		var b = rgbColor.b;
		var fR = r / 255;
		var fG = g / 255;
		var fB = b / 255;
		var minRGB = Math.min(fR,Math.min(fG,fB));
		var maxRGB = Math.max(fR,Math.max(fG,fB));
		if(minRGB == maxRGB) {
			return new trik_color_HSVColor(0,0,minRGB);
		}
		var d = fR == minRGB ? fG - fB : fB == minRGB ? fR - fG : fB - fR;
		var h = fR == minRGB ? 3 : fB == minRGB ? 1 : 5;
		return new trik_color_HSVColor(60 * (h - d / (maxRGB - minRGB)),(maxRGB - minRGB) / maxRGB,maxRGB);
	}
};
trik_tools_ColorTools.toMono = function(color) {
	var o = color;
	var _g = o == null ? null : js_Boot.getClass(o);
	if(_g == trik_color_MonoColor) {
		return color;
	} else {
		var rgbColor = trik_tools_ColorTools.toRGB(color);
		return new trik_color_MonoColor(Math.floor((rgbColor.r + rgbColor.g + rgbColor.b) / 3));
	}
};
trik_tools_ColorTools.toPoint3D = function(color) {
	var rgbColor = trik_tools_ColorTools.toRGB(color);
	return new trik_geometry_Point3D(rgbColor.r,rgbColor.g,rgbColor.b);
};
trik_tools_ColorTools.compareMono = function(color1,color2,threshold) {
	if(threshold == null) {
		threshold = 0;
	}
	if(color1.value < color2.value) {
		return trik_ordering_Ordering.LT;
	}
	if(color1.value > color2.value) {
		return trik_ordering_Ordering.GT;
	}
	return trik_ordering_Ordering.EQ;
};
trik_tools_ColorTools.compare = function(color1,color2,threshold) {
	if(threshold == null) {
		threshold = 0;
	}
	var color1Rgb = trik_tools_ColorTools.toRGB(color1);
	var color2Rgb = trik_tools_ColorTools.toRGB(color2);
	if(Math.abs(color1Rgb.r - color2Rgb.r) <= threshold && Math.abs(color1Rgb.g - color2Rgb.g) <= threshold) {
		return Math.abs(color1Rgb.b - color2Rgb.b) <= threshold;
	} else {
		return false;
	}
};
var trik_tools_TimeTools = function() { };
trik_tools_TimeTools.__name__ = true;
trik_tools_TimeTools.toMilliseconds = function(time) {
	switch(time[1]) {
	case 0:
		return time;
	case 1:
		var value = time[2];
		return trik_time_Time.Milliseconds(Math.round(value * 1000));
	case 2:
		var value1 = time[2];
		return trik_time_Time.Milliseconds(Math.round(60000 * value1));
	}
};
trik_tools_TimeTools.toSeconds = function(time) {
	switch(time[1]) {
	case 0:
		var value = time[2];
		return trik_time_Time.Seconds(value / 1000);
	case 1:
		return time;
	case 2:
		var value1 = time[2];
		return trik_time_Time.Seconds(value1 * 60);
	}
};
trik_tools_TimeTools.toMinutes = function(time) {
	switch(time[1]) {
	case 0:
		var value = time[2];
		return trik_time_Time.Minutes(value / 60000);
	case 1:
		var value1 = time[2];
		return trik_time_Time.Minutes(value1 / 60);
	case 2:
		return time;
	}
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
js_Boot.__toStr = ({ }).toString;
trik_Trik.brick = new trik_robot_Brick();
trik_Trik.script = trik_robot__$ScriptHigher_ScriptHigher_$Impl_$._new();
trik_Trik.mailbox = new trik_robot_Mailbox();
trik_Trik.threading = new trik_robot_Concurrency();
Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
