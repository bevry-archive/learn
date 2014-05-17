###
layout: default
###

{getProjectName, getCategoryName, getProjectPagesByCategory} = @
projects = @getProjects()

div '.container', ->
	header '.topbar', ->
		h1 '.heading.hover-link', 'data-href':'/', ->
			@text['heading']
		h2 '.subheading', @text['subheading']

	nav '.sidebar', ->
		form submit:'/project', method:'query', ->
			select name:'project', ->
				for project in ['home'].concat(projects)
					option value:project, -> getProjectName(project)
			input '.no-js', {type:'submit', value:'Open Project'}, ->

		if @document.project
			learnCollection = @getCollection('learn')
			activeItemURL = '/'+(@document.url.split('/')[1] or '')
			activeItem =
				if activeItemURL isnt '/'
					learnCollection.findOne(url: $startsWith: activeItemURL)
				else
					learnCollection.findOne(url: activeItemURL)

			projectPagesByCategory = @getProjectPagesByCategory(project)

			projectCategoryItems = (
				for own projectCategory, projectPagesInCategory of projectPagesByCategory
					{
						id: projectCategory
						title: getCategoryName(projectCategory)
						contentRenderedWithoutLayouts: @partial('list/items.html.coffee', false, {
							classname: "category-pages"
							items: projectPagesInCategory
							activeItem: activeItem
							partial: @partial
							moment: @moment
							showDescription: false
							showDate: false
							showContent: false
						})
					}
			)

			text @partial('list/items.html.coffee', false, {
				classname: "category"
				items: projectCategoryItems
				partial: @partial
				moment: @moment
				showDescription: false
				showDate: false
				showContent: true
			})

		else
			projectPages = (
				for project in projects
					{
						id: project
						url: '#'+project
						title: getProjectName(project)
					}
			)

			text @partial('list/items.html.coffee', false, {
				classname: "projects"
				items: projectPages
				partial: @partial
				moment: @moment
				showDescription: false
				showDate: false
				showContent: false
			})

	div '.mainbar', ->
		div "#content", -> @content
		footer ".bottombar", ->
			div ".poweredby", @text['poweredby']
			div ".copyright", @text['copyright']
