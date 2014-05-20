###
layout: default
###


div '.container', ->
	a '.main-website', href:'http://bevry.me', -> 'About Bevry'

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
			div '.sidebar', ->
				nav '.sidebar-nav.category-pages', ->
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
