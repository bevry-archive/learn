###
layout: page
standalone: true
###

# Prepare
uniq = @uniq
docs = @docs
{getLabelName, getProjectName, getCategoryName, getProjects, getCategories, getCategoryCollection} = @

# Prepare
nav '.reference', ->

	# Projects
	ul ".projects", ->
		for project in @getProjects()
			# Project
			li "##{project}.project.subblock", ->
				h2 -> getProjectName(project)

				# Categories
				categories = @getCategories(project)
				columns = if categories.length > 4 then 4 else categories.length
				ul ".categories.columns-#{columns}", ->
					for category in categories
						pages = @getCategoryCollection(project, category)

						# Category
						li "##{project}-#{category}.category", ->
							h3 -> getCategoryName(category)

							# Pages
							ul ".pages", ->
								pages.forEach (page) ->
									# Page
									li ".page", ->
										h4 '.title', ->
											a href:(page.get('absoluteLink') or page.get('url')), -> page.get('title')
											label = page.get('label')
											if label
												span ".label.label-#{label}", -> getLabelName(label)
