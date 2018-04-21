function Foo(who) {
  this.me = who
}
Foo.prototype.identity = function() {
  return `I am + ${this.me}`
}

function Bar(who) {
  Foo.call(this, who)
}

Bar.prototype = Object.create(Foo.prototype)

Bar.prototype.speak = function() {
  alert(`Hello ${this.identify()}.`)
}


var b1 = new Bar('B1')
var b2 = new Bar('B2')
console.log('b1: ',b1)
console.log('b2: ',b2)