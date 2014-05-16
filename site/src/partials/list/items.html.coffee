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
nav ".list-#{type}"+(if cssClasses then "."+cssClasses.join('.') else ''), "typeof":"dc:collection", ->
	# Empty
	unless items.length
		div ".list-#{type}-empty", ->
			emptyText
		return

	# Exists
	items.forEach (item) ->
		# Item
		{url,title,date,description,contentRenderedWithoutLayouts} = (item.attributes or item)

		# CssClasses
		_itemCssClasses = ["list-#{type}-item"]
		_itemCssClasses.push(if item.id is activeItem?.id then activeCssClasses else inactiveCssClasses)
		_itemCssClasses.concat(itemCssClasses)

		# Display
		li "."+_itemCssClasses.join('.'), "typeof":"soic:page", about:url, ->
			# Link
			a ".list-#{type}-link", href:url, ->
				# Title
				span ".list-#{type}-title", property:"dc:title", -> title

				# Date
				if showDate and moment
					span ".list-#{type}-date", property:"dc:date", ->
						moment(date).format(dateFormat)

			# Display the description if it exists
			if showDescription and description
				div ".list-#{type}-description", property:"dc:description", -> description

			# Display the content if it exists
			if showContent and contentRenderedWithoutLayouts
				div ".list-#{type}-content", property:"dc:content", -> contentRenderedWithoutLayouts
