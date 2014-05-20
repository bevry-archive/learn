###
layout: default
###


a '.main-website', href:'http://bevry.me', -> 'About Bevry'

div '.container', ->
	header '.topbar', ->
		a href:'/', ->
			h1 '.heading', ->
				@text['heading']
		h2 '.subheading', @text['subheading']

	div '.innerbar', ->

		div '.mainbar', ->
			div "#content", -> @content
			footer ".bottombar", ->
				div ".poweredby", @text['poweredby']
				div ".copyright", @text['copyright']

		if @document.category
			nav '.sidebar', ->
				items = [].concat @getCategoryCollection(@document.project, @document.category).models
				text @partial('list/items.html.coffee', false, {
					items: items
					partial: @partial
					moment: @moment
					showDescription: false
					showDate: false
					showContent: false
					activeItem: @document
				})
