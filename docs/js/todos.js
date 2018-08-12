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
			console.log(data)
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
					var records = data.records;
					resolve(records);
				}
			})
		});
	}
	render() {
		
	}
}
P.autoMount(MainView)

P.set("main")
