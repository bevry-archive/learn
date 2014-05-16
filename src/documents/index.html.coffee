###
layout: page
standalone: true
###

# Prepare
uniq = @uniq
docs = @docs
learnCollection = @getCollection('learn')
return  unless learnCollection
{getLabelName, getProjectName, getCategoryName, getProjectPagesByCategory} = @

# Prepare
section '.reference', ->

	# Projects
	nav ".projects", ->
		projects = uniq learnCollection.pluck('project')
		for project in projects
			projectPagesByCategory = getProjectPagesByCategory(project)
			projectCategories = Object.keys(projectPagesByCategory)

			# Project
			li "##{project}.project.subblock", ->
				h2 -> getProjectName(project)

				# Categories
				columns = if projectCategories.length > 4 then 4 else projectCategories.length
				nav ".categories.columns-#{columns}", ->
					for own projectCategory, pagesInProjectCategory of projectPagesByCategory

						# Category
						li "##{project}-#{projectCategory}.category", ->
							h3 -> getCategoryName(projectCategory)

							# Pages
							nav ".pages", ->
								pagesInProjectCategory.forEach (page) ->

									# Page
									li ".page", ->
										h4 '.title', ->
											a href:(page.get('absoluteLink') or page.get('url')), -> page.get('title')
											label = page.get('label')
											if label
												span ".label.label-#{label}", -> getLabelName(label)
