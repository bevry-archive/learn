###
layout: default
###

{getProjectName, getCategoryName, getProjectPagesByCategory} = @
projects = @getProjects()

div '.container', ->
	header '.topbar', ->
		a href:'/', ->
			h1 '.heading', ->
				@text['heading']
		h2 '.subheading', @text['subheading']

	div '.mainbar', ->
		div "#content", -> @content
		footer ".bottombar", ->
			div ".poweredby", @text['poweredby']
			div ".copyright", @text['copyright']
