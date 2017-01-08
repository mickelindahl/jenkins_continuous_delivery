# Jenkins continuous delivey

Instructions for setting up simpe coninuous deleivery for [nodejs](https://nodejs.org/en/) app with
[jenkins](https://jenkins.io/). 

Steps to setup in jenkins
* **Test** node test suit 
* **Deploy test** test deploy in dev/prod server
* **Deploy** deploy to production
* **Teardown** teardown test deploy environment
* **Fallback** fallback if test deploy fails



## Installation

-## Setting up Jenkins to build NodeJS
 -See NodeJS CI tutorial [part 1](https://strongloop.com/strongblog/roll-your-own-node-js-ci-server-with-jenkins-part-1/) and [part 2](https://strongloop.com/strongblog/roll-your-own-node-js-ci-server-with-jenkins-part-2/) 
 -for the inspiration to this.  
 -

### Plugins 
 -
 -Required
 -* GitHub  Plugin
 -* NodeJS Plugin
 -
 -Optional
 -* Clover Plugin (OBS 4.7 broken choose 4.6 instead)
 -* Checkstyle Plug-in
 -* TAP Plugin
 -* Embeddable Build Status PLugin
 -
 -Older versions of plugins can be manually installed.
 -
 -### Security
 -Go to "Manage jenkins" -> "Configure Global Security", choose "Project-based Matrix Authorization Strategy".
 -and then add you user and check admin.
 -
 -### Github webhok
 -Please check [Githu plugin](https://wiki.jenkins-ci.org/display/JENKINS/GitHub+plugin) for 
 -updates to this proceedure.
 -
 -Create personal access token under settings in your github account. It
 -should adleast have the folloing scope so that jenkins can manage creation
 -of repo hooks.
 -* admin:repo_hook - for managing hooks (read, write and delete old ones)
 -* repo - to see private repos
 -* repo:status - to manipulate commit statuses
 -
 -Go to "Manage Jenkins" -> "Configure System". First scroll down to Jenkins locatin and ensure it is the http url of the
 -jenkins server (needs to be http since Lets encryp certidicate at this moment do not pass all githubs tests). 
 -Then scroll down to GitHub and click add GitHub server.  
 -
 -In your github account go to "Settings"->"Personal access tokens", generate an token and copy token.
 -
 -Click "Add credentials" -> "jenkins" (the scope), choose kind  <<sercet text>> and past token value. Type in
 -a suitable ID and description (Credentials can also be 
 -added at main page. There can additional scopes also be created).
 -
 -Test connection. If ok scroll to bottom and hit save.    
 -
 -### Node JS
 -Ensure that Node JS plugin is installed.
 -
 -Under "Manage Jenkins" -> "Global Tool Configuration" scroll down to Node JS.
 -
 -Click add "Add NodeJS", type in name, mark "Install automatically", choose node version and hit save
 -at the bottom of the page.
 -
 -### Build badges
 -Go to Manage jenkins->Configure Global Security and choose Project-based Matrix Authorization Strategy.
 -Under Anonymous user->job check read (view before?!?) status.
 -  
 -## Free-style project Node JS
 -Select "New item", enter a name, choose "Freestyle project" and then hit OK.
 -
 -Go to "Configure" 
 -
 -Under "Source Code Managment" check "Git". Enter git
 -repository url and credentials (credentials need to be a user/password type).
 -
 -Under "Build Triggers" check "Build when a change is pushed to GitHub". OBS if
 -you need to delete the webhook on git to generate a new since you change e.g. the url of the jenins server 
 -just uncheck->apply->check->apply 
 -
 -
 -Under "Build Environment" check "Provide Node & npm bin/folder to PATH and choose your nore installtion. 
 -
 -### TAP build status and Clover coverage report with hapijs lab
 -
 -In your package,json add
 -
 -```js
 -"scripts": {
 -    "test-jenkins": "node_modules/.bin/lab -m 10000 -r tap -o test.tap -r clover -o clover.xml"
 -}
 -```
 -Then in jenkins got to "Configure" -> "Build" -> "Add build step" -> "Excecute in shell" and past:
 -
 -```shell
 -npm install
 -npm run test-jenkins || :
 -```
 -
Then goto "Post-build Actions" -> "Add post-build action" and choose  "Publish TAP Results" and "Publish Clover Coverage Report"
  
 -In "Publish TAP Results" -> "Test results" write test.tap
 +Done :-)
  
 -Hit save and try it out with "Build now"!
