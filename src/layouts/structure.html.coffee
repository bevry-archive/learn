###
layout: default
###


div '.container', ->
	a '.main-website', href:'https://bevry.me', -> 'About Bevry'

	header '.topbar', ->
		a href:'/', ->
			h1 '.heading', ->
				@text['heading']
		h2 '.subheading', @text['subheading']

	div '.innerbar', ->

		div '.mainbar', ->
			div '.page', @content

			footer ".bottombar", ->
				div ".poweredby", @text['poweredby']
				div ".copyright", @text['copyright']

		if @document.projectId and @document.categoryId
			aside '.sidebar', ->
				div '.sidebar-nav', ->
					text @renderMenu({render: 'category'})