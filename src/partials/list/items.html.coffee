# Prepare
{cssClasses,moment,items,itemCssClasses,activeItem,activeCssClasses,inactiveCssClasses,type,showDate,showDescription,showContent,emptyText,dateFormat} = @
activeCssClasses ?= ['active']
inactiveCssClasses ?= ['inactive']
type or= 'items'
showDate ?= true
showDescription ?= true
showContent ?= false
emptyText or= "empty"
dateFormat or= "YYYY-MM-DD"

# Document List
ul ".list-#{type}"+(if cssClasses then "."+cssClasses.join('.') else ''), "typeof":"dc:collection", ->
	# Empty
	unless items?.length
		div ".list-#{type}-empty", ->
			emptyText
		return

	# Exists
	items.forEach (item) ->  # this is used instead of for in, as this could also be a backbone collection
		# Item
		{id, url,title,date,description,contentRenderedWithoutLayouts} = (item.attributes or item)

		# CssClasses
		_itemCssClasses = ["list-#{type}-item"]
		_itemCssClasses.push(if id is activeItem?.id then activeCssClasses else inactiveCssClasses)
		_itemCssClasses.concat(itemCssClasses)

		# Display
		li "."+_itemCssClasses.join('.'), "typeof":"soic:page", about:url, ->
			# Title Content
			getTitleContent = ->
				# Title
				span ".list-#{type}-title", property:"dc:title", -> title

				# Date
				if showDate and moment
					span ".list-#{type}-date", property:"dc:date", ->
						moment(date).format(dateFormat)

			# Link
			if url
				a ".list-#{type}-link", href:url, getTitleContent
			else
				getTitleContent.call(this)

			# Display the description if it exists
			if showDescription and description
				div ".list-#{type}-description", property:"dc:description", -> description

			# Display the content if it exists
			if showContent and contentRenderedWithoutLayouts
				div ".list-#{type}-content", property:"dc:content", -> contentRenderedWithoutLayouts
