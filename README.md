# Overview

The purpose of this project is to set up a Azure DevOps pipeline: 

(1) to instantiate an infrastructure with a virtual machine, an application service, and associated networking; 

(2) to deploy the virtual machine to a test environment, 

(3) to perform testing on a number of application components using selenium for UI testing, jmeter for stress and endurance testing, and postman for regression and data validation testing, 

(4) to capture test results within the Azure DevOps environment and Azure Log Analytics Workspace, and 

(5) to trigger an alert during stress testing.

## Instantiation of Infrastructure

The infrastructure is created by Terraform scripts, triggered by an Azure DevOps Pipeline.  The following resources are created: a resource group, a virtual network, a network security group, an app service, a public IP address, a network interface, and a Linux virtual machine.  Private parameters regarding the Azure identity are conveyed through variables in the Azure DevOps pipeline.

The following screenshot shows a successful automated run of the Terraform scripts in the Azure DevOps Pipeline:

![Terraform apply in pipeline](/screenshots/terraform-apply-in-pipeline.png)


## Deploying the Virtual Machine to a Test Environment

To deploy the Linux virtual machine to the TEST environment, the Azure DevOps Environment for TEST needs to include the VM created in the previous step.  This involves going to Environment > TEST > Add Resource > Virtual Machines > Linux.  Copy the script to the Azure Linux VM and run it to install an Azure DevOps agent.  The login_ssh.sh script will retrieve the IP address of the virtual machine and log into the machine for installation of the agent in the Azure Portal CLI.

## Create a Log Analytics Workspace

To create a Log Analytics Workspace in your Azure subscription, download the template json file () for the creation and run the following command:

	az deployment group create --resource-group <resource group) --name <law name> --template-file <json file>

Provide your workspace name when prompted.

## Install the OMS agent on the VM

Next, log into the virtual machine from which logs will be gathered with the following command:

        ssh -i <ssh-key> azureuser@<Public IP of VM>

Next, in the Azure Portal, go to Log Analytics > \<workspace created\> > Agents Management > Linux servers to copy the script to install the OMS monitoring agent on the virtual machine.  Run the script on the VM.

After the script is run, ensure that the virtual machine is connected to your workspace by going to Log Analytics > Virtual Machines > \<your VM\> > Connect.

## Create an email alert for the condition that the CPU Time on the App Service deployed earlier exceeds 5 seconds

In the Azure Portal, go to App Services > <your App Service> > Alerts > New alert rule, to create a new rule.  Add the condition for alerting, by going to Add condition > CPU Time.  Use a threshold of 5 seconds.  Click Done.

Add an action group by clicking Add action groups > Create action group.  Enter Action group name and display name.  Select Next: Notifications.  Choose Email/SMS message/Push/Voice, a name for the notification, and an email address to send the alert to.  Click OK.  Click Review + create, then Create to add the action group.

To specify the alert rule details, provide the Alert rule name, Description, and Severity.  Click on Create alert rule to enable the email alert.

## Linking custom log file to Log Analytics Workspace

In the Azure Portal, to add the importing of the selenium test log, go to Log Analytics > \<your workspace\> > Custom Logs.  Add the name of the custom log and the log file path name.  The screenshot below shows the custom log setup.

![law custom log setup](/screenshots/law-custom-log-setup.png)

Proceed to the Azure DevOps Pipeline to run stage 2, Deploy VM to the test environment.  Rerun failed jobs to deploy the VM to the TEST environment and begin testing.

The tests will be run automatically from test scripts.

### Postman testing

Two types of Postman tests are run: (1) a regression test, which tests the API, and (2) a data validation test, which tests the data returned by the API.  The target of the testing was APIs supplied by the website, http://dummy.restapiexample.com/.  Screenshots for these tests are below.

![Postman regression test](/screenshots/postman-regression-test.png)

![Postman data validation test](/screenshots/postman-data-validation-test.png)

### Postman test results

The Postman tests were also published as artifacts in Azure DevOps.  To see the test results in Azure DevOps, proceed to Test Plans > Runs.  Click on results for regression test and data validation tests.  Screenshots are shown below.

![Postman regression test results](/screenshots/postman-regression-test-results.png)

![Postman regression test](/screenshots/postman-data-validation-test-results.png)

### Selenium testing

Selenium tests the user interface of a service.  In this case, the target test site was https://www.saucedemo.com.  The tests logged into the site, added six shopping items to the shopping cart, and removed them.  

Selenium testing in the Azure DevOps Pipeline is shown in the screenshot below.

![Selenium testing in pipeline](/screenshots/selenium-testing-in-pipeline.png)

### Selenium test results

The logs were published to the Log Analytics Workspace created earlier.  The screenshot below shows the published results in the workspace.

![Selenium testing in pipeline](/screenshots/selenium-testing-in-pipeline.png)

### Jmeter testing

Two types of jmeter tests were performed: (1) stress testing, and (2) endurance testing.  Jmeter testing in the Azure DevOps Pipeline is schown in the screenshots below.

![jmeter endurance test in pipeline](/screenshots/jmeter-endurance-test-in-pipeline.png)

![jmeter stress test in pipeline](/screenshots/jmeter-stress-test-in-pipeline.png)

### Jmeter test results

The jmeter testing results are summarized in HTML reports that are downloadable from artifacts of the Azure DevOps Pipeline.  The screenshots below show these test results.

![html report for jmeter endurance test](/screenshots/html-report-for-jmeter-endurance-test.png)

![html report for jmeter stress test](/screenshots/html-report-for-jmeter-stress-test.png)

## Triggering an Alert during Jmeter Stress Testing

During the jmeter stress testing, the alert on CPU time greater than 5 seconds is triggered and sent via email.  The screenshot below shows the alert.

![email showing alert](/screenshots/email-showing-alert.png)
