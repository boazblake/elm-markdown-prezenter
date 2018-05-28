/* jshint esversion: 6 */

let { SlidesDB, IncCount, UpdateSlides } = require('../OO/obj-or.js');

let slides = SlidesDB;

module.exports = {
	postSlides: function(slides) {
		id = IncCount;
		UpdateSlides(slides, id);
	},

	getSlides: function() {
		return slides ? slides : null;
	},

	getSlide: function(id) {
		const len = slides.length;
		let slides = null;
		// return  slides ? slides.map((slide, i) => (slide.id == id ? slide : [])) : null

		for (var i = 0; i < len; i++) {
			slide = data[i];
			if (slide.id === id) {
				return slide;
			}
		}
		return null;
	},
};
