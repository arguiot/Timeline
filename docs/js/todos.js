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
		this.mountGroup(
			this.view.querySelector("#sign"),
			SignGroup
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
	}
	gotoAuthenticatedState(userIdentity) {
		const name = userIdentity.nameComponents;
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
P.autoMount(MainView)

P.set("main")
