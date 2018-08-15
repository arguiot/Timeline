const P = new ProType()

class MainView extends P.ViewController {
	preload() {
		CloudKit.configure({
			locale: 'en-us',

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
			.then(this.gotoUnauthenticatedState.bind(this));
	}

	gotoUnauthenticatedState(error) {

		if (error && error.ckErrorCode === 'AUTH_PERSIST_ERROR') {
			alert("Persisting error.")
		}
		console.log("Signed out")
		container
			.whenUserSignsIn()
			.then(this.gotoAuthenticatedState.bind(this))
			.catch(this.gotoUnauthenticatedState.bind(this));
	}
}

class TodosGroup extends P.Group {
	init() {
		this.group.innerHTML = "Loading...";
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
	render(todos) {
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
			</div>
			`
			this.group.insertAdjacentHTML("beforeend", model);
			const todosList = this.group.querySelectorAll(".todo");
			const last = todosList[todosList.length - 1];
			P.workspace.interval.push(setInterval(() => {
				const nowd1 = Math.abs(new Date().getTime() - initDate.getTime())
				const progress = (nowd1 / d1d2) * 100
				last.querySelector(".bar").style.width = `${progress}%`
				if (progress > 100) {
					const i = [...last.parentElement.children].indexOf(last);
					clearInterval(P.workspace.interval[i])
					this.deleteTodo(P.workspace.todos[i])
				}
			}, 500))
		}
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
			enableTime: true,
			dateFormat: "Z",
			altInput: true
		})

		this.view.querySelector(".done").addEventListener("click", this.submitTodo.bind(this))
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
		P.workspace.db.saveRecords(record).then(response => {
			if (response.hasErrors) {
				const ckError = response.errors[0];
				// Insert error handling or throw the error and handle it using catch() later
				alert(ckError)
			} else {
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

P.autoMount(MainView, NewView)

P.set("main")

// Sign group
P.workspace.sign = P.mountExternalGroup(
	document.body.querySelector("#sign"),
	SignGroup
)
