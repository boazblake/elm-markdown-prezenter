const Shape = function(width) {
	return function(height) {
		const obj = Object.create(Shape.prototype)
		obj.width = width
		obj.height = height
		return obj
	}
}

Shape.prototype.area = function() {
  return this.height * this.width
}

const shapeA = Shape(5)(5)
const shapeB = Shape(2)(4)
const shapeC = Shape(4)(6)
const shapeD = Shape(7)(8)
const shapeE = Shape(9)(9)


const shapes = [shapeA, shapeB, shapeC, shapeD, shapeE]

console.log(shapeA.area())

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

/*This is because I am breaking the principle of single responsibility.
const shape = w => h => ({width: w, height: h, area: h * w})
both accepts the inputs and calculates the result.
*/