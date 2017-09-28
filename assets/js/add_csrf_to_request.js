(function(){
  var send = XMLHttpRequest.prototype.send,
      token = document.querySelector("meta[name=csrf-token]").getAttribute("content");
  XMLHttpRequest.prototype.send = function(data){
    this.setRequestHeader('X-CSRF-Token', token);
    return send.apply(this, arguments);
  }
})();

console.log("csrf-token: " + document.querySelector("meta[name=csrf-token]").getAttribute("content"))

