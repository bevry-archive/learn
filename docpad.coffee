# Require
fsUtil = require('fs')
pathUtil = require('path')
moment = require('moment')

# Prepare
appPath = __dirname
websiteVersion = require('./package.json').version
isProduction = process.env.NODE_ENV is 'production'
textData =
	heading: "Bevry's Learning Centre"
	subheading: " &nbsp; doing everything we can to empower developers"
	poweredby: """
		<a class="hover-link" href="http://docpad.org" title="We use DocPad as our Content Management System">
			Created with love and affection using <span class="link">DocPad</span>
		</a>
		"""
	copyright: """
		&copy; <a href="http://bevry.me">Bevry Pty Ltd</a>. <a href="https://github.com/bevry/learn">Some rights reserved.</a>
		"""

	linkNames:
		learn: "Learn"
		email: "Email"
		twitter: "Twitter"
		github: "GitHub"
		support: "Support"
		showcase: "Showcase"

	projectNames:
		docpad: "DocPad"
		node: "Node.js"
		queryengine: "Query Engine"
		taskgroup: "TaskGroup"

	projectDescriptions:
		docpad:
			"""
			Unlike the other documentation links, these DocPad documentation links will take your to the DocPad website.
			"""

	projectLinks:
		docpad: "http://docpad.org"
		node: "http://nodejs.org"
		taskgroup: "https://github.com/bevry/taskgroup"
		joe: "https://github.com/bevry/joe"
		queryengine: "https://github.com/bevry/query-engine"

	categoryNames:
		docs: "Documentation"
		start: "Getting Started"
		community: "Guidelines"
		core: "Core"
		extend: "Extend"
		handsonnode: "Hands on with Node"

	labelNames:
		pro: "Pro"
		training: "Training"

	links:
		historyjs: """
			<a href="http://historyjs.net">History.js</a>
			"""
		docpad: """
			<a href="http://docpad.org">DocPad</a>
			"""
		cclicense: """
			<a href="http://creativecommons.org/licenses/by/3.0/">Creative Commons Attribution License</a>
			"""

		im: """
			<a href="javascript: $zopim.livechat.button.setPosition('bl'); $zopim.livechat.window.show(); false" class="btn btn-im">Instant Message</a>
			"""
		phone:  """
			<a href="callto:+61280062364" class="btn btn-phone">Call +61 (2) 8006 2364</a>
			"""
		email: """
			<a href="mailto:us@bevry.me" class="btn btn-email">Email us@bevry.me</a>
			"""
		booking: """
			<a href="/services" class="btn btn-email show-booking">Make a Booking</a>
			"""
		premiumsupport: """
			<a href="/services" class="btn btn-email show-booking">Purchase Premium Support</a>
			"""

# =================================
# Helpers

# Indexes

# "project" -> "project directory"
projectsIndex = {}
# "project" -> "category" -> category directory"
categoriesIndex = {}

# [projectKey] = projectCollection
projectCollections = {}

# [categoryKey] = categoryCollection
categoryCollections = {}

# Titles
getName = (a,b) ->
	if b is null
		return textData[b] ? humanize(b)
	else
		return textData[a][b] ? humanize(b)
getProjectName = (project) ->
	getName('projectNames', project)
getProjectDescription = (project) ->
	textData.projectDescriptions[project] ? ''
getProjectLink = (project) ->
	textData.projectLinks[project] ? ''
getCategoryName = (category) ->
	getName('categoryNames', category)
getLinkName = (link) ->
	getName('linkNames', link)
getLabelName = (label) ->
	getName('labelNames', label)

# Humanize
humanize = (text) ->
	text ?= ''
	text = text.replace(/[-_]/g, ' ').replace(/\s+/g, ' ')
	text =
		(for piece in text.split(' ')
			piece.substr(0,1).toUpperCase()+piece.substr(1)
		).join(' ')
	return text


# =================================
# Configuration


# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig =

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# -----------------------------
		# Misc

		text: textData
		moment: moment
		nodeVersion: process.version
		nodeMajorMinorVersion: process.version.replace(/^v/,'').split('.')[0...2].join('.')


		# -----------------------------
		# Site Properties

		site:
			# The production url of our website
			url: "http://learn.bevry.me"

			# The default title of our website
			title: "Bevry's Learning Centre"

			# The website keywords (for SEO) separated by commas
			keywords: """
				bevry, bevryme, balupton, benjamin lupton, docpad, history.js, node.js, javascript, coffee-script, query-engine
				"""

			# Services
			services:
				#disqus: 'bevry'
				#gauges: '5077ad8cf5a1f5067b000027'
				googleAnalytics: 'UA-35505181-1'
				#reinvigorate: 'dy05w-88s5zok1o8'
				#zopim: '0tni8T2G7P86SxDwmxCa4HCySsGPRESg'

			# Styles
			styles: [
				'/styles/style.css'
			].map (url) -> "#{url}?websiteVersion=#{websiteVersion}"

			# Scripts
			scripts: [
				# Vendor
				#"/vendor/jquery.js"
				#"/vendor/log.js"
				"/vendor/modernizr.js"
				#"/vendor/jquery.scrollto.js"

				# State Change
				#"/vendor/history.js"
				#"/vendor/historyjsit.js"

				# Scripts
				#"/scripts/bevry.js"
				#"/scripts/script.js"
				"/scripts/refresh.js"
			].map (url) -> "#{url}?websiteVersion=#{websiteVersion}"


		# -----------------------------
		# Helper Functions

		# Names
		getName: getName
		getProjectName: getProjectName
		getProjectDescription: getProjectDescription
		getProjectLink: getProjectLink
		getCategoryName: getCategoryName
		getLinkName: getLinkName
		getLabelName: getLabelName
		getProjects: -> Object.keys(projectsIndex).sort (a,b) -> projectsIndex[a] > projectsIndex[b]
		getCategories: (project) -> Object.keys(categoriesIndex[project]).sort (a,b) -> categoriesIndex[project][a] > categoriesIndex[project][b]
		getProjectCollection: (project) ->
			projectCollection = projectCollections[project] ?= @getCollection('learn').findAllLive({project})
		getCategoryCollection: (project, category) ->
			categoryCollection = categoryCollections[project+'-'+category] ?= @getProjectCollection(project).findAllLive({category})

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our page's title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a title, we should use it suffixed by the site's title
			if @document.pageTitle isnt false and @document.title
				"#{@document.pageTitle or @document.title} | #{@site.title}"
			# if we don't have a title, then we should just use the site's title
			else if @document.pageTitle is false or @document.title? is false
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')

		# Read File
		readFile: (relativePath) ->
			path = @document.fullDirPath+'/'+relativePath
			result = fsUtil.readFileSync(path)
			if result instanceof Error
				throw result
			else
				return result.toString()

		# Code File
		codeFile: (relativePath,language) ->
			language ?= pathUtil.extname(relativePath).substr(1)
			contents = @readFile(relativePath)
			return """<pre><code class="#{language}">#{contents}</code></pre>"""


	# =================================
	# Collections

	collections:

		# Fetch all documents that exist within the learn directory
		# And give them the following meta data based on their file structure
		learn: (database) ->
			query =
				relativePath: $startsWith: 'learn'
				body: $ne: ""
				ignored: false
			sorting = [projectDirectory:1, categoryDirectory:1, filename:1]
			database.findAllLive(query, sorting).on 'add', (document) ->
				# Prepare
				a = document.attributes

				###
				learn/#{organisation}/#{project}/#{category}/#{filename}
				###
				pathDetailsExtractor = ///
					^
					.*?learn/
					(.+?)/        # organisation
					(.+?)/        # project
					(.+?)/        # category
					(.+?)\.       # basename
					(.+?)         # extension
					$
				///

				pathDetails = pathDetailsExtractor.exec(a.relativePath)

				# Properties
				layout = 'doc'
				standalone = true
				organisationDirectory = organisation = organisationName =
					projectDirectory = project = projectName =
					categoryDirectory = category = categoryName =
					title = pageTitle = null

				# Check if we are correctly structured
				if pathDetails?
					organisationDirectory = pathDetails[1]
					projectDirectory = pathDetails[2]
					categoryDirectory = pathDetails[3]
					basename = pathDetails[4]

					organisation = organisationDirectory.replace(/[\-0-9]+/, '')
					organisationName = humanize(project)

					project = projectDirectory.replace(/[\-0-9]+/, '')
					projectName = getProjectName(project)

					category = categoryDirectory.replace(/^[\-0-9]+/, '')
					categoryName = getCategoryName(category)

					name = basename.replace(/^[\-0-9]+/,'')

					title = "#{a.title or humanize name}"
					pageTitle = "#{title} | #{projectName}"

					projectLink = "/##{project}"
					categoryLink = "/##{project}-#{category}"
					urls = [
						"/#{project}/#{name}"
						"/#{project}/#{category}/#{name}"
						"/#{project}-#{name}"
					]

					githubEditUrl = "https://github.com/#{organisationDirectory}/documentation/edit/master/"
					proseEditUrl = "http://prose.io/##{organisationDirectory}/documentation/edit/master/"
					editUrl = githubEditUrl + a.relativePath.replace('learn/bevry/', '')

					projectsIndex[project] ?= projectDirectory
					categoriesIndex[project] ?= {}
					categoriesIndex[project][category] ?= categoryDirectory

					if organisation is 'docpad'
						absoluteLink = "http://docpad.org/docs/#{name}"
						document.set(
							render: false
							write: false
						)
						if category is 'partners'
							document.set(
								ignored: true
							)

					# Apply
					document
						.setMetaDefaults({
							layout
							standalone

							name
							title
							pageTitle

							absoluteLink
							url: urls[0]

							editUrl

							organisationDirectory
							organisation
							organisationName

							projectDirectory
							project
							projectName
							projectLink

							categoryDirectory
							category
							categoryName
							categoryLink
						})
						.addUrl(urls)

					# console.log "Processed the learning document #{a.relativePath}"

				# Otherwise ignore this document
				else
					console.log "The document #{a.relativePath} was at an invalid path, so has been ignored"
					document.setMetaDefaults({
						ignore: true
						render: false
						write: false
					})

		pages: (database) ->
			database.findAllLive({relativeOutDirPath:$startsWith:'pages'},[filename:1])



	# =================================
	# Plugins

	plugins:
		highlightjs:
			aliases:
				stylus: 'css'

		repocloner:
			repos: [
				{
					name: 'Bevry Documentation'
					path: 'src/documents/learn/bevry'
					url: 'https://github.com/bevry/documentation.git'
				}
				{
					name: 'DocPad Documentation'
					path: 'src/documents/learn/docpad/docpad'
					url: 'https://github.com/docpad/documentation.git'
				}
			]

		cleanurls:
			simpleRedirects:
				'/taskgroup/api': 'http://rawgit.com/bevry/taskgroup/master/docs/index.html'

			advancedRedirects: [
				# Old URLs
				[/^https?:\/\/(?:bevry-learn\.herokuapp\.com|bevry\.github\.io\/learn)(.*)$/, 'https://learn.bevry.me$1']

				# /project/PROJECT => /#PROJECT
				[/^\/project\/(.+)$/, '/#$1']

				# legacy
				# /PROJECT => /#PROJECT
				[/^\/(query-engine|joe|taskgroup|community|node)\/?$/, '/#$1']

				# legacy
				# /bevry/* => /community/*
				[/^\/bevry\/(.*)$/, '/community/$1']

				# DocPad Documentation
				[/^\/learn\/docpad\-(.*)$/, 'https://docpad.org/docs/$1']

				# DocPad General
				[/^\/docpad(?:\/(.*))?$/, 'http://docpad.org/$1']
			]

	# =================================
	# Environments

	# Disable analytic services on the development environment
	environments:
		development:
			templateData:
				site:
					services:
						gauges: false
						googleAnalytics: false
						mixpanel: false
						reinvigorate: false



# Export our DocPad Configuration
module.exports = docpadConfig
