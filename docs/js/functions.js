window.addEventListener("scroll", e => {
	let logo = document.querySelector(".logo")
	if (window.scrollY > 10) {
		logo.style.position = "fixed"
		logo.style.top = "12.5px"
		logo.style.left = "10px"
		logo.style.width = "50px"
		logo.style.height = "50px"
		document.querySelector("nav").style.opacity = "1"
	} else {
		logo.style.position = "absolute"
		logo.style.top = "60px"
		logo.style.left = "calc(50vw - 50px)"
		logo.style.width = "100px"
		logo.style.height = "100px"
		document.querySelector("nav").style.opacity = "0"
	}
})
