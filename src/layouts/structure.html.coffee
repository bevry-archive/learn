###
layout: default
###

{getProjectsMapping, getProjectPagesByCategory} = @

div '.container', ->
	header '.topbar', ->
		h1 '.heading.hover-link', 'data-href':'/', ->
			@text['heading']
		h2 '.subheading', @text['subheading']

	div '.sidebar', ->
		if @document.project
			form submit:'/project', method:'query', ->
				select name:'project', ->
					for own projectKey, projectName of getProjectsMapping()
						option value:projectKey, -> projectName
				input '.no-js', {type:'submit', value:'Open Project'}, ->

			for own projectCategory, projectPagesInCategory of getProjectPagesByCategory()
				activeItemURL = '/'+@document.url.split('/')[1]
				activeItem = if activeItemURL isnt '/' then projectPagesInCategory.findOne(url: $startsWith: activeItemURL) else projectPagesInCategory.findOne(url:activeItemURL)
				text @partial('list/menu.html.coffee', {
					classname: "navbar"
					items: projectPagesInCategory
					activeItem: activeItem
					partial: @partial
					moment: @moment
				})

		else
			welcomePage = {
				id: '/'
				url: '/'
				title: 'Welcome'
			}
			projectPages = [welcomePage]
			for projectKey, projectName of getProjectsMapping()
				projectPages.push({
					id: projectKey
					url: '#'+projectKey
					title: projectName
				})
			text @partial('list/menu.html.coffee', {
				classname: "navbar"
				items: projectPages
				activeItem: welcomePage
				partial: @partial
				moment: @moment
			})

	div '.mainbar', ->
		div "#content", -> @content
		footer ".bottombar", ->
			div ".poweredby", @text['poweredby']
			div ".copyright", @text['copyright']
