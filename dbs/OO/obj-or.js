let slides = {};

let counter = 0;

module.exports = {
	IncCount: (counter = counter + 1),
	UpdateSlides: function(newSlides, id) {
		slides[id] = newSlides;
		return slides[id];
	},
	SlidesDB: function(counter) {
		return slides[counter];
	},
};
