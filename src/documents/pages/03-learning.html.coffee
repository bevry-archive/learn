---
title: Learning
layout: page
---

# Prepare
_ = @underscore
docs = @docs
learnCollection = @getCollection('learn')
getTitle = @getTitle


# Reference
projects = _.uniq learnCollection.pluck('project')
for project in  _.uniq learnCollection.pluck('project')
	pagesInProject = learnCollection.findAll({'project':project},{categoryDirectory:1})
	categoriesInProject = _.uniq pagesInProject.pluck('category')

	nav ".project-"+project, ->
		h2 -> text "<t>text.project#{project}</t>"
		section '.reference', ->
			ul ->

				for projectCategory in categoriesInProject
					pagesInProjectCategory = pagesInProject.findAll({'category':projectCategory},[filename:1])

					li ->
						h3 -> text "<t>text.category#{projectCategory}</t>"
						ul ->
							pagesInProjectCategory.forEach (page) ->
								li ->
									h4 '.title', ->
										a href:page.get('url'), -> getTitle(page)


# Reference
h2 "Reference"
text @partial "content/subblock.html.coffee", {
	avatar: '/images/book.gif'
	heading: """
		<a href="/reference">Reference Manual</a>
		"""
	#subheading: "Stackoverflow owns &amp; manages, Bevry participates"
	content: """
		<t render="markdown">
		The official and comprehensive **man pages** that are included in the Git package itself.
		</t>
		"""
}
text """
	<t render="markdown">
	Quick Reference guides:
	[Heroku Cheat Sheet](/) (PDF)
	</t>
	"""


# Videos
h2 "Videos"