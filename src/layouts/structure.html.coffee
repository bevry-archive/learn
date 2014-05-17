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

	nav '.sidebar', ->
		form submit:'/project', method:'query', ->
			select name:'project', ->
				for project in ['home'].concat(projects)
					option value:project, -> getProjectName(project)
			input '.no-js', {type:'submit', value:'Open Project'}, ->

		if @document.project
			learnCollection = @getCollection('learn')

			projectPagesByCategory = @getProjectPagesByCategory(project)

			projectCategoryItems = (
				for own projectCategory, projectPagesInCategory of projectPagesByCategory
					{
						id: projectCategory
						title: getCategoryName(projectCategory)
						contentRenderedWithoutLayouts: @partial('list/items.html.coffee', false, {
							classname: "category-pages"
							items: projectPagesInCategory
							activeItem: @document
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
						url: '/#'+project
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
