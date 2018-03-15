const shape = w => h => ({width: w, height: h, area: h * w})


const shapeA = Object.create(shape(5)(5))
const shapeB = Object.create(shape(2)(4))
const shapeC = Object.create(shape(4)(6))
const shapeD = Object.create(shape(7)(8))
const shapeE = Object.create(shape(9)(9))

const shapes = [shapeA, shapeB, shapeC, shapeD, shapeE]

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

//but extending the object does not work
const triangleShape = Object.create(shape(7)(5), {'area':{value: this.area / 2 }})
const shapesWithTriangle = [triangleShape].concat(shapes)
const shapesWithTriangleArea = calculator.calculate(shapesWithTriangle)

/*This is because I am breaking the principle of single responsibility.
const shape = w => h => ({width: w, height: h, area: h * w})
both accepts the inputs and calculates the result.
*/