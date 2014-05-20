###
layout: structure
###

{document} = @

pagesInProject = @getProjectCollection(@document.project)
for item,index in pagesInProject.models
	if item.id is @document.id
		break

prevModel = pagesInProject.models[index-1] ? null
nextModel = pagesInProject.models[index+1] ? null


pagesInCategory = @getCategoryCollection(@document.project, @document.category)
siblings = pagesInProject.models.filter (item) -> item.id isnt document.id
siblings = siblings.map (item) ->
	{
		url: item.get('url')
		name: item.get('title')
	}
parents = [
	{
		url: @document.projectLink
		name: @document.projectName
	},
	{
		url: @document.categoryLink
		name: @document.categoryName
	}
]

text @partial('content/block.html.coffee', false, {
	cssClasses: ["doc"].concat(@document.cssClasses or [])
	permalink: @document.url
	heading: @document.title
	subheading: @document.subheading
	editUrl: @document.editUrl
	content: @content
	document: @document
	partial: @partial
	siblings: siblings
	parents: parents
	prev:
		if prevModel
			url: prevModel.attributes.url
			title: prevModel.attributes.title
	next:
		if nextModel
			url: nextModel.attributes.url
			title: nextModel.attributes.title
	up:
		url: @document.categoryLink or '/'
		title: @document.projectName
})
