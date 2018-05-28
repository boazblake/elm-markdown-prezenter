
const Shape = function(type) {
  return function(width) {
    return function(height) {
      const obj = Object.create(Shape.prototype)
      obj.type = type
      obj.width = width
      obj.height = height
      return obj
    }
  }
}

Shape.prototype.area = function() {
  if (this.type =='square') {
    return this.height * this.width
  }

  if (this.type == 'triangle') {
    return (( this.height * this.width) / 2)
  }

  if (this.type == 'circle') {
    if (this.height == this.width)
    return 3.141 * (this.height * this.height)
  }
  else return (3.141 * (this.height/2) * (this.length/2))
}

const shapeA = Shape('square')(5)(5)
const shapeB = Shape('circle')(2)(2)
const shapeC = Shape('triangle')(4)(6)
const shapeD = Shape('square')(7)(8)
const shapeE = Shape('triangle')(9)(9)


const Squares = Shape('square')


const shapes = [shapeA, shapeB, shapeC, shapeD, shapeE]

const calculator = {
    calculate(xs) {
      const sum = (accumulator, shape) => {
        return accumulator + shape.area()
      }
        const result = xs.reduce(sum, 0)

        return `The total area is: ${result}`
    }
}


const shapesArea = calculator.calculate(shapes)
console.log(shapesArea)