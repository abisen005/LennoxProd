import { LightningElement, track } from 'lwc';
import authenticateUser from '@salesforce/apex/CommunityLoginController.authenticateUser';
import communityURL from '@salesforce/apex/CommunityLoginController.getCommunityURL';
import { NavigationMixin } from 'lightning/navigation';

const REMEMBER_ME_KEY = 'community-remember-me';
const USERNAME_KEY = 'community-username';
const PASSWORD_KEY = 'community-password';

export default class CustomCommunityLogin extends NavigationMixin(LightningElement) {
@track siteUrl = '';
@track username;
@track password;
 @track rememberMe = false;
@track error;
@track isLoading = false; // Initialize to true or false based on your initial state
@track isInvalidEmail = false;


connectedCallback() {
    this.loadRememberMe();
    console.log('Connected callback executed');

    this.getCommunityURL();
     if (localStorage.getItem(REMEMBER_ME_KEY) === 'true') {
            this.username = localStorage.getItem(USERNAME_KEY) || '';
            this.password = localStorage.getItem(PASSWORD_KEY) || '';
            this.rememberMe = true;
        }

}



handleUsernameChange(event) {
    this.username = event.target.value;
}

handlePasswordChange(event) {
    this.password = event.target.value;
}

handleRememberMeChange(event) {
    this.rememberMe = event.target.checked;
}



loadRememberMe() {
    const rememberMeValue = localStorage.getItem(REMEMBER_ME_KEY);
    this.rememberMe = rememberMeValue === 'true';
    if (this.rememberMe) {
        this.username = localStorage.getItem('community-username');
    }
}

 handleKeyPress(event) {
        if (event.key === 'Enter') {
            this.handleLogin();
        }
    }

getCommunityURL() {
    communityURL()
        .then(result => {
            if (result !== 'error') {
                this.siteUrl = result;
                console.log(' this.siteUrl', this.siteUrl);

            }
        })
}

saveRememberMe() {
    if (this.rememberMe) {
        localStorage.setItem(REMEMBER_ME_KEY, 'true');
        localStorage.setItem('community-username', this.username);
        localStorage.setItem('community-password', this.password); // Add this line to save the password

    } else {
        localStorage.removeItem(REMEMBER_ME_KEY);
        localStorage.removeItem('community-username');
            localStorage.removeItem('community-password'); 
    }
}

handleLogin() {
    console.log('Check1');
    // Save "Remember Me" preference
    this.saveRememberMe();
    console.log(' this.password', this.password);
    if (!this.username || !this.password) {
        if (!this.username) {
            return this.error = 'Enter a value in the User Name field.';
        } else {
            console.log('passwordnullcheck');
            return this.error = 'Enter a value in the Password field.';
        }
    }
else    if (!this.username.match('.+@.+\..+')) {
return this.error = 'Enter a valid email address in the User Name field.';    }
        
else {
    console.log('BOOM');
        // Perform login actions here
        authenticateUser({ username: this.username, password: this.password })
            .then(result => {
                // Check if login was successful
                if (result !== 'error') {
                    console.log('Check2');
                    // Redirect user to a home page or desired location
                    window.location.href = result;
                } else {
                    console.log('Check3');
                    // Display error message
                    this.error = 'Your login attempt has failed. Make sure the username and password are correct.';
                }
            })
            .catch(error => {
                console.error('Error authenticating user:', error);
                this.error = 'An error occurred while logging in';
            });
        
}
}


/* handleForgotPassword(){
        console.log('BOOM',this.siteUrl+'/secur/forgotpassword.jsp?startURL=/feelthelove/s/')
    window.location.href = this.siteUrl+'/secur/forgotpassword.jsp?startURL=/feelthelove/s/';

    }*/

handleForgotPassword() {
    console.log('handleSomeAction called');
    this.isLoading = true;

    // Add a short delay to allow the spinner to render before rerouting
    setTimeout(() => {
        // Set window location to the desired URL
        window.location.href = this.siteUrl + '/secur/forgotpassword.jsp?startURL=/feelthelove/s/';

        // Optional: Hide spinner after a short delay
        setTimeout(() => {
            this.isLoading = true;
        }, 100); // Adjust timeout as needed
    }, 0); // Add a minimal delay to ensure spinner rendering
}




handleDealerSignup() {
    // Replace 'https://example.com' with the URL you want to open
    window.location.href = this.siteUrl + '/s/login/SelfRegister';
}


navigateToPage() {
    // Implement navigation logic here
    // Example: Use NavigationMixin to navigate to another page
}
}