converting
commandTemplate

	^ 'convert -density 300 "{input}" -depth 8 -strip -background white -alpha off "{output}"'.