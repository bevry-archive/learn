text @partial('list/items.html.coffee', false, {
	type: @type ? 'menu'
	items: @items
	activeItem: @activeItem
	showDescription: @showDescription ? false
	showDate: @showDate ? false
	showContent: @showContent ? false
	moment: @moment
})