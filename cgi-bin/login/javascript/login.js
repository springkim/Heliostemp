var global;
function CheckSubmit(){
	var id = document.getElementById("ID").value;
	var pw = document.getElementById("PW").value;
	
	if(id == "" || pw == ""){
		alert("Please enter all information.");
		return false;
	}
	// AES256 암호화
	var iv = document.getElementById("IV").value;
	var salt = document.getElementById("SALT_TEMP").value;
	var passPhrase = document.getElementById("PASSPHRASE").value;
	
	var aesUtil = new AesUtil(192, 500);
	
	var enc = aesUtil.encrypt(salt, iv, passPhrase, pw);
	document.getElementById("EPW").value = enc;
	return true;
	
}

function id_keyup() {
	var i = document.getElementById("ID");
	// 알파벳,숫자,언더바가 아니면 삭제한다.
	if (i.value.length > 0) {
		i.value = i.value.replace(/[^(\d|a-z|A-Z|_)]+/g, '');
	}
}
function loginComplete(){
	clearTimeout(global);
	document.forms["loginForm"].submit();
}