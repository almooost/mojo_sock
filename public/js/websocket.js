/*
* Javascript for Websocket Chat
* Date: 30.03.14;
* Author: S.Alfano;
* Version: v0.1;
*/

//Function definition

function Chat () {
	
	var chat_output = document.getElementById("chat_output");
	var chat_input = document.getElementById("chat_input");
	var chat_send = document.getElementById("chat_send");
	
	var current_time = new Date().toLocaleString();

	Chat.prototype.addChatMsg = function(chat_user, inmsg){
		var html = '<p class="add_chat_msg"><span class="chat_user">['+current_time+'] '+chat_user+" :</span>"+inmsg+'</p>';
		chat_output.innerHTML += html;
		chat_input.value = '';
		chat_output.scrollTop = chat_output.scrollHeight;
	};

	Chat.prototype.listener = function(){
		chat_input.addEventListener("keypress", function (e) {
			console.log(e.keyCode);
			if (e.keyCode == 13) {
				chat_send.click();
			}
		});
	};
}

function User () {
	
	var username ;
	var password;

	// Setter Methods
	User.prototype.setUsername = function(username) {
		this.username = username;
	};

	User.prototype.setPassword = function(password) {
		this.password = password;
	};

	// Getter Methods
	User.prototype.getUsername = function() {
		return this.username;
	};

	User.prototype.getPassword = function() {
		return this.password
	};

	User.prototype.cryptPassword = function(password) {
		User.setPassword(password);
	};
}


// Class for Messages
function Message(){

	var msg;

	Message.prototype.setMessage = function(inmsg) {
		this.msg = inmsg;
	}

	Message.prototype.getMessage = function(){
		return this.msg;
	}
}

// Class for sending things to socket
function sendtoSocket() {

	var sender;
	var sender_id;
	var recipient;
	var command;


	sendtoSocket.prototype.senttoSocket = function(msg){
		var newmsg = msg; 
	}

	// Setter Functions
	sendtoSocket.prototype.setCommand = function(command){
		this.command = command;
	}

	sendtoSocket.prototype.setSender = function(sender){
		this.sender = sender;
	}

	sendtoSocket.prototype.setRecipient  = function(recipient) {
		this.recipient = recipient;
	}

	// Getter Functions
	sendtoSocket.prototype.getCommand  = function() {
		return command;
	}

	sendtoSocket.prototype.getSendter = function(){
		return sender;
	}

	sendtoSocket.prototype.getRecipient = function(){
		return recipient;
	}
}

/***********/
/* Global Functions */
function setFocus(elem){
	document.getElementById(elem).focus();
}


function setListener() {
	var chat_msg = new Chat().listener();
}

function connectUser(user, elem) {
	document.getElementById(elem).value = user;
	document.getElementById('user').value = user;
	document.getElementById('chat_input').value = 'Connected';
	setTimeout(wss.newmessage(), 3000);
}

function createUserList(userlist){
	// Set User List
	var newuserlist = '';
	for (var user in userlist) {
		newuserlist += "<div class='user_online'>"+user+"</div>"; 
	}
	return newuserlist;
}



