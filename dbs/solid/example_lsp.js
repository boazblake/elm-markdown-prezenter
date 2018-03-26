const Shape = function(width) {
  return function(height) {
    return ({width, height})
  }
}

Shape.prototype.setType = function(type) {
  return this.type = type
}

Shape.prototype.getType = function() {
  return this.type
}

Shape.prototype.getArea = function() {
  if (this.type === 'circle') {
    return this.area
  } else {
    return this.area / 2
  }
}

const _singelton = Shape(5)(5)
const shapeA = Object.create(Shape(5)(5))
const shapeB = Object.create(Shape(2)(4))
const shapeC = Object.create(Shape(4)(6))
const shapeD = Object.create(Shape(7)(8))
const shapeE = Object.create(Shape(9)(9))

const shapes = [shapeA, shapeB, shapeC, shapeD, shapeE, _singelton]

const calculator = {
    calculate(xs) {
      const sum = (accumulator, shape) => {
        return accumulator + shape.area
      }
        const result = xs.reduce(sum, 0)

        return `The total area is: ${result}`
    }
}


const shapesArea = calculator.calculate(shapes)

const triangleShape = Object.create(Shape(7)(5),{ 'value': this.area/2})
const shapesWithTriangle = [triangleShape].concat(shapes)
const shapesWithTriangleArea = calculator.calculate(shapesWithTriangle)
