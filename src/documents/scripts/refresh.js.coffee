query = (".block-content h#{i}[id]" for i in [1...7]).join(', ')

for element in document.querySelectorAll?(query)
	href = '#'+element.getAttribute('id')
	element.setAttribute('data-href', href)
	element.classList.add('hover-link')
	element.classList.add('anchor-link')

Array.prototype.forEach.call document.querySelectorAll?('[data-href]'), (element) ->
	element.addEventListener('click', (e) ->
		document.location.href = element.getAttribute('data-href')
		element.classList.add('current')
		setTimeout(
			-> element.classList.remove('current')
			1000
		)
	)