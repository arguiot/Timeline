const P = new ProType()

class MainView extends P.ViewController {
	preload() {
		CloudKit.configure({
			locale: navigator.language,

			containers: [{

				// Change this to a container identifier you own.
				containerIdentifier: 'iCloud.com.ArthurG.Timeline',

				apiTokenAuth: {
					// And generate a web token through CloudKit Dashboard.
					apiToken: '20623e1dee3c667e7da908dde95734256f9a59383df5960bdca01dde52188a80',

					persist: true, // Sets a cookie.

					signInButton: {
						id: 'sign',
						theme: 'black' // Other options: 'white', 'white-with-outline'.
					},

					signOutButton: {
						id: 'sign',
						theme: 'black'
					}
				},

				environment: 'production'
			}]
		});
		P.workspace = {
			container: CloudKit.getDefaultContainer()
		}
	}
	willShow() {
		P.workspace.interval = []
		document.querySelector(".option").style["background-image"] = "url(\"../img/Add.svg\")";
		this.tdg = this.mountGroup(
			this.view.querySelector(".todos"),
			TodosGroup
		)
		document.querySelector(".option").addEventListener("click", e => {
			// optimizing speed by reducing amount of memory needed
			const el = document.querySelector(".option")
			const newEl = el.cloneNode(true)
			el.parentNode.replaceChild(newEl, el);

			P.performTransition("new", {
				animation: "newVC"
			})
		})
	}
	willDisappear() {
		clearInterval(P.workspace.refresh)
	}
}

class SignGroup extends P.Group {
	init() {
		P.workspace.container.setUpAuth().then(user => {
			if (user) {
				this.gotoAuthenticatedState(user)
			} else {
				this.gotoUnauthenticatedState()
			}
		})
		P.workspace["db"] = P.workspace.container.privateCloudDatabase
	}
	gotoAuthenticatedState(userIdentity) {
		P.workspace.user = userIdentity
		console.log("Signed in")
		P.workspace.container
			.whenUserSignsOut()
			.then(this.reload);
	}
	reload() {
		window.location = ""
	}
	gotoUnauthenticatedState(error) {
		document.querySelector(".todos").innerHTML = "Please sign in."
		if (error && error.ckErrorCode === 'AUTH_PERSIST_ERROR') {
			alert("Persisting error.")
		}
		console.log("Signed out")
		P.workspace.container
			.whenUserSignsIn()
			.then(this.reload)
			.catch(this.gotoUnauthenticatedState.bind(this));
	}
}

class TodosGroup extends P.Group {
	init() {
		this.group.innerHTML = "Loading...";
		if (P.workspace.todos) {
			this.render(P.workspace.todos)
		} else {
			this.fetch()
		}
		P.workspace.refresh = setInterval(this.fetch.bind(this), 5000)
	}
	fetch() {
		console.log("Fetching...")
		this.query().then(data => {
			P.workspace.todos = data
			this.render(data)
		})
	}
	query() {
		return new Promise((resolve, reject) => {
			let query = {
				recordType: "ToDos",
				sortBy: [{
					fieldName: "initDate",
					ascending: false
				}]
			}
			P.workspace.db.performQuery(query).then(data => {
				if (data.hasErrors) {

					// Handle them in your app.
					reject(data.errors[0])

				} else {
					const records = data.records;
					resolve(records);
				}
			})
		});
	}
	render(todos = []) {
		this.group.innerHTML = "";
		for (let i = 0; i < todos.length; i++) {
			const fields = todos[i].fields

			const date = new Date(fields.date.value)
			const initDate = new Date(fields.initDate.value)

			const d1d2 = Math.abs(date.getTime() - initDate.getTime());
			const nowd1 = Math.abs(new Date().getTime() - initDate.getTime())
			const progress = (nowd1 / d1d2) * 100

			const model = `
			<div class="todo">
				<div class="date">${this.dateFormat(date, "D, dd MMM HH:mm")}</div>
				<h1>${fields.name.value}</h1>
				<p>${fields.desc.value}</p>
				<div class="progress"><div class="bar" style="width: ${progress}%"></div></div>
				<div class="hud">
					<div class="done item">
						<svg width="34" height="26" viewBox="0 0 34 26" fill="none" xmlns="http://www.w3.org/2000/svg">
							<rect width="30" height="20.625" fill="black" fill-opacity="0" transform="translate(2 2)"/>
							<path d="M2 13.25L11.375 22.625L32 2" stroke="black" stroke-width="5" stroke-linejoin="round"/>
						</svg>
					</div>
					<div class="delete item">
						<svg width="34" height="34" viewBox="0 0 34 34" fill="none" xmlns="http://www.w3.org/2000/svg">
							<path d="M2 32L32 2M2 2L32 32L2 2Z" stroke="black" stroke-width="5"/>
						</svg>
					</div>
					<div class="edit item">
						<svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
							<path d="M3 33L4.03448 25.7586L26.7931 3L33 9.2069L10.2414 31.9655L3 33Z" stroke="black" stroke-width="5" stroke-linejoin="round"/>
						</svg>
					</div>
				</div>
			</div>
			`
			this.group.insertAdjacentHTML("beforeend", model);
			const todosList = this.group.querySelectorAll(".todo");
			const last = todosList[todosList.length - 1];

			this.todoClick(todos[i], last)

			P.workspace.interval.push(setInterval(() => {
				const nowd1 = Math.abs(new Date().getTime() - initDate.getTime())
				const progress = (nowd1 / d1d2) * 100
				last.querySelector(".bar").style.width = `${progress}%`
				if (progress > 100 && last) {
					const i = [...last.parentElement.children].indexOf(last);
					clearInterval(P.workspace.interval[i])
					this.deleteTodo(P.workspace.todos[i])
				}
			}, 500))
		}
	}
	todoClick(todo, el) {
		el.addEventListener("click", e => {
			const hud = el.querySelector(".hud")
			if (getComputedStyle(hud).getPropertyValue("display") == "none") {
				clearInterval(P.workspace.refresh)
				hud.style.display = "flex"
			} else {
				hud.style.display = "none"
				P.workspace.refresh = setInterval(this.fetch.bind(this), 5000)
			}
		})
		el.querySelector(".delete").addEventListener("click", e => { this.deleteTodo(todo) })
		el.querySelector(".done").addEventListener("click", e => { this.deleteTodo(todo) })
		el.querySelector(".edit").addEventListener("click", e => { this.editTodo(todo) })
	}
	deleteTodo(record) {
		const i = P.workspace.todos.indexOf(record)
		if (i !== -1) P.workspace.todos.splice(i, 1);
		this.render(P.workspace.todos)
		P.workspace.db.deleteRecords(record).then(x => {
			this.query().then(data => {
				P.workspace.todos = data
				this.render(data)
			})
		})
	}
	editTodo(record) {
		P.workspace.edit = {
			edit: true,
			record: record
		}
		P.performTransition("new", {
			animation: "newVC"
		})
	}
	dateFormat(date, format) {
		var monthNames = [
			"January", "February", "March",
			"April", "May", "June", "July",
			"August", "September", "October",
			"November", "December"
		];

		var Days = [
			"Sunday", "Monday", "Tuesday", "Wednesday",
			"Thursday", "Friday", "Saturday"
		];

		function formatDate(dt, format) {
			format = format.replace('ss', pad(dt.getSeconds(), 2));
			format = format.replace('s', dt.getSeconds());
			format = format.replace('dd', pad(dt.getDate(), 2));
			format = format.replace('d', dt.getDate());
			format = format.replace('mm', pad(dt.getMinutes(), 2));
			format = format.replace('m', dt.getMinutes());
			format = format.replace('MMMM', monthNames[dt.getMonth()]);
			format = format.replace('MMM', monthNames[dt.getMonth()].substring(0, 3));
			format = format.replace('MM', pad(dt.getMonth() + 1, 2));
			format = format.replace(/M(?![ao])/, dt.getMonth() + 1);
			format = format.replace('DD', Days[dt.getDay()]);
			format = format.replace(/D(?!e)/, Days[dt.getDay()].substring(0, 3));
			format = format.replace('yyyy', dt.getFullYear());
			format = format.replace('YYYY', dt.getFullYear());
			format = format.replace('yy', (dt.getFullYear() + "").substring(2));
			format = format.replace('YY', (dt.getFullYear() + "").substring(2));
			format = format.replace('HH', pad(dt.getHours(), 2));
			format = format.replace('H', dt.getHours());
			return format;
		}

		function pad(n, width, z) {
			z = z || '0';
			n = n + '';
			return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
		}
		return formatDate(date, format)
	}
}

class NewView extends P.ViewController {
	willShow() {
		if (P.workspace.edit && P.workspace.edit.edit === true) {
			this.fill(P.workspace.edit.record)
		} else {
			this.emptyEverything()
		}
		document.querySelector(".option").style["background-image"] = "url(\"../img/Back.svg\")";
		document.querySelector(".option").addEventListener("click", e => {
			// optimizing speed by reducing amount of memory needed
			const el = document.querySelector(".option")
			const newEl = el.cloneNode(true)
			el.parentNode.replaceChild(newEl, el);

			P.performTransition("main", {
				animation: "newVC"
			})
		})

		flatpickr(".new .date", {
			minDate: "today",
			defaultHour: new Date().getHours(),
			defaultMinute: new Date().getMinutes(),
			enableTime: true,
			dateFormat: "Z",
			altInput: true,
			time_24hr: true
		})

		this.view.querySelector(".done").addEventListener("click", this.submitTodo.bind(this))
	}
	fill(record) {
		this.view.querySelector(".name").value = record.fields.name.value
		this.view.querySelector(".desc").value = record.fields.desc.value
		this.view.querySelector(".date").value = new Date(record.fields.date.value).toString()
	}
	emptyEverything() {
		this.view.querySelector(".name").value = ""
		this.view.querySelector(".desc").value = ""
		this.view.querySelector(".date").value = ""
	}
	submitTodo() {
		const name = this.view.querySelector(".name").value
		const desc = this.view.querySelector(".desc").value
		const date = new Date(this.view.querySelector(".date").value)

		const record = {
			recordType: "ToDos",
			fields: {
				name: {
					value: name
				},
				desc: {
					value: desc
				},
				initDate: {
					value: new Date().getTime()
				},
				date: {
					value: date.getTime()
				}
			}
		}
		if (P.workspace.edit && P.workspace.edit.edit === true) {
			record.fields.initDate = {
				value: P.workspace.edit.record.fields.initDate.value
			}
			record.recordName = P.workspace.edit.record.recordName
			record.recordChangeTag = P.workspace.edit.record.recordChangeTag
		}
		P.workspace.db.saveRecords(record).then(response => {
			if (response.hasErrors) {
				const ckError = response.errors[0];
				// Insert error handling or throw the error and handle it using catch() later
				alert(ckError)
			} else {
				if (P.workspace.edit && P.workspace.edit.edit === true) {
					const i = P.workspace.todos.indexOf(P.workspace.edit.record)
					if (i !== -1) P.workspace.todos[i] = response.records[0]
					P.workspace.edit.edit = false
				} else {
					P.workspace.todos.unshift(response.records[0])
				}
				P.performTransition("main", {
					animation: "newVC"
				})
			}
		})
	}
	willDisappear() {
		const node = document.querySelectorAll(".flatpickr-calendar")
		node.forEach(element => {
			element.parentNode.removeChild(element);
		});
		const inputs = document.querySelectorAll("input.form-control")
		inputs.forEach(element => {
			element.parentNode.removeChild(element);
		});
	}
}

P.workspace.todos = []

P.autoMount(MainView, NewView)

P.set("main")

// Sign group
P.workspace.sign = P.mountExternalGroup(
	document.body.querySelector("#sign"),
	SignGroup
)
