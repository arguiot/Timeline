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
		this.sign = this.mountGroup(
			this.view.querySelector("#sign"),
			SignGroup
		)
		this.tdg = this.mountGroup(
			this.view.querySelector(".todos"),
			TodosGroup
		)
	}
	willDisappear() {

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
		console.log("Fetching...")
		this.query().then(data => {
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
		for (let i = 0; i < todos.length; i++) {
			const fields = todos[i].fields

			const date = new Date(fields.date.value)
			const model = `
			<div class="todo">
				<div class="date">${this.dateFormat(date, "D, dd MMM HH:mm")}</div>
				<h1>${fields.name.value}</h1>
				<p>${fields.desc.value}</p>
				<div class="progress"><div class="bar"></div></div>
			</div>
			`
			this.group.insertAdjacentHTML("beforeend", model);
		}
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

		function pad (n, width, z) {
			z = z || '0';
			n = n + '';
			return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
		}
		return formatDate(date, format)
	}
}
P.autoMount(MainView)

P.set("main")
