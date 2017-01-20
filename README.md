# Jenkins continuous delivey

Instructions for setting up simpe continuous delivery for [nodejs](https://nodejs.org/en/) app with
[jenkins (2.3.1)](https://jenkins.io/). 

Steps to setup in jenkins
* **Test** node test suit 
* **Deploy test** test deploy in dev/prod server
* **Deploy** deploy to production
* **Teardown** teardown test deploy environment
* **Fallback** fallback if test deploy fails

This is done with two freestyle scripts deply and fallback.

Below is a graph of the continuous delivery flow that we will 
implement here


![](https://github.com/mickelindahl/jenkins_continuous_delivery/blob/master/flow.png)

## Installation

Make sure these jenkins plugins are installed.Older versions of plugins
can be installed manually.

* [Clover Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Clover+Plugin) (OBS 4.7 broken choose 4.6 instead)
* [Checkstyle Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Checkstyle+Plugin)
* [Git Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Git+Plugin)
* [GitHub Plugin](https://wiki.jenkins-ci.org/display/JENKINS/GitHub+Plugin)
* [Environment Injector Plugin](https://wiki.jenkins-ci.org/display/JENKINS/EnvInject+Plugin) (to show environmet variables for builds)
* [Embeddable Build Status PLugin](https://wiki.jenkins-ci.org/display/JENKINS/Embeddable+Build+Status+Plugin)
* [HTTP Request](https://wiki.jenkins-ci.org/display/JENKINS/HTTP+Request+Plugin) (to test that server is responding to requests)
* [Slack Notification plugin](https://wiki.jenkins-ci.org/display/JENKINS/Slack+Plugin)
* [NodeJS Plugin](https://wiki.jenkins-ci.org/display/JENKINS/NodeJS+Plugin)
* [Parameterized Trigger plugin](https://wiki.jenkins-ci.org/display/JENKINS/Parameterized+Trigger+Plugin)
* [TAP Plugin](https://wiki.jenkins-ci.org/display/JENKINS/TAP+Plugin)
* [SSH2Easy plugin](https://wiki.jenkins-ci.org/display/JENKINS/SSH2Easy+Plugin)

Copy `jenkins.env.sh`   to your soruce directory and open it and set the environment variables in it

Create two freestyle jobs {project-name}-deploy.sh and {project-name}-fallback.sh

For both:

* Go into the job and click **Configure**

* In **General** section click **This project is parameterized -> Add Parameter -> String parameter**. 
  Add tow parameters `CD_PATH` and `PROJECT_PATH`. Enter default values for deploy job and leave blank
  for fallback job

### Fallback job

If ssh have not been configured save project and to that now (see section **SSH remote shell access**

In **Build** section click **Add build step -> Remote shell** and past the code below
```sh
cd $CD_PATH
. ./teardown.sh $PROJECT_PATH

cd $CD_PATH
. ./fallback.sh $PROJECT_PATH
```

Save job

### Deploy job

In **Source Code Management** section click **Git**. Enter project repository ulr and user/password credentials
for the repository. 

If you have not configure a Github webhook save project and do that now (see section **Github webhook** below). Then go back.

In **Build Triggers** click **GitHub hook trigger for GITScm polling**

If you have not configured node save project and do that now (see section **Nodejs integration** below. Then go back

In **Build Environment** section choose **Provide Node & npm/bin folder** and choose prefered node installation

In **Build** section click **Add build step -> Execute shell** and pased the code below.

OBS for node-gyp, add node-gyp as global package and also ensure that
make is installed in jenkins container. Enter container as root 
`docker exec -it jenkins --user root /bin/bash` and run`apt-get install build-essential`



```
npm install
npm run test-jenkins

# Get npm exit status and exit shell accordingly
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
```

Alos ensure your project has this entry in `package.json`

```js
 "scripts": {
    "test-jenkins": "node_modules/.bin/lab -l -r tap -o test.tap -r clover -o clover.xml test"
  },
```

In **Build** section click **Add build step -> Remote shell** and past the code below

```sh
cd $CD_PATH
. ./deploy-test.sh $PROJECT_PATH

cd $CD_PATH
. ./teardown.sh $PROJECT_PATH

cd $CD_PATH
. ./deploy.sh $PROJECT_PATH

# Wait for server to get online
sleep 10
```
In **Build** sectopm click **HTTP Request**. Enter url for site page to test request against.

In **Post-build Actions** section click **Add post-build action -> Publish TAP result**. Enter `test.tap`
in **Test results**

In **Post-build Actions** section click **Add post-build action -> Publish Clover Coverage Report**. Enter `clover.xml`
in **Clover report file name**.

In **Post-build Actions** section click **Add post-build action -> Trigger parameterized build on other projects**. 
Enter `{fallback job name}`in **Projects to build**. Select Failed in**Trigger wen build is**. Click
**Add Parameters -> Current build parameters**.

If slack account is missing create one.

If there is no channel on slack to push notifications create one

Create integration in slack to channel. Goto slack apps in your account and search for jenkns. Click install 
abd follow instructions.

In **Post-build Actions** section click **Add post-build action -> Slack Notifications**. Click in 
perfered notifications. Clicke **Advance**  enter your slackteam in **Team Subdomain**. Add token
in credentials as secret key. Set your channel in **Project Channel**. Click **Test Connectin**

Save job

### Build badges

Go to Manage jenkins->Configure Global Security and choose Project-based Matrix Authorization Strategy. Under Anonymous user->job check read (view before?!?) status.

In project that you want badge from click **Embeddable Build Status** and copy markdown
to README.md

## Github webhook
Please check [Githu plugin](https://wiki.jenkins-ci.org/display/JENKINS/GitHub+plugin) for 
updates to this proceedure.

From main page goto **Manage Jenkins -> Configure System**. 

In **Jenkins Location** section and ensure it is the **http** url of the jenkins server (needs to be http since Lets encryp certidicate at this moment do not pass all githubs tests).

In **GitHub** sectin and click **add GitHub server**. 

Goto github and in your account go to **Settings"->"Personal access tokens**. Generate an token and copy token.

Create personal access token under settings in your github account. It
should adleast have the folloing scope so that jenkins can manage creation
of repo hooks.
* admin:repo_hook - for managing hooks (read, write and delete old ones)
* repo - to see private repos
* repo:status - to manipulate commit statuses
If private one need to also add
* admin:public_key
* admin:org_hook

Choose/add credentials with secret thext that equals the personal access.

Test connection. If ok scroll to bottom and hit save.   

## Nodejs integration
Ensure that Node JS plugin is installed.

From main page goto **Manage Jenkins -> Global Tool Configuration**. 

In **Node JS** section click add "Add NodeJS", type in name, mark **Install automatically**, 
click **Add installer -> Install from nodejs.com** choose node version and hit save
at the bottom of the page.

## SSH remote shell access
From main page goto **Manage Jenkins -> Configure System**. 

In **Server Groups Center** section click **add** for **Server Group list**. Enter a groupname, ssh port, user name and
password. Then click **add** for **Server List** and select the server group from above a server name and 
enter server url. 

Save configuration and you are done!
