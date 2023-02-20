[Home](https://github.com/swmannepalli/Azure-Data-Factory-CI-CD)

🤔 Prerequisites
---------------------------------------------------------------------------------------------------------------------------------------------------------

+ Account and Organization created in Azure Devops. 
+ If not, follow [this](https://learn.microsoft.com/en-us/azure/devops/user-guide/sign-up-invite-teammates?view=azure-devops) tutorial to sign up (Click on Start free). Organization name is automatically populated, click on create.

---------------------------------------------------------------------------------------------------------------------------------------------------------

## :dart: Objectives
---------------------------------------------------------------------------------------------------------------------------------------------------------

1. Creating Azure DevOps project
2. Create ARM Service connection to Prod subscription - A Service Connection is required for Azure DevOps Continuous Build and Continuous Release Pipelines to talk to external and remote services and execute tasks. If you want to understand what happens when you create an ARM serice connection, check [this](https://learn.microsoft.com/en-us/azure/devops/pipelines/release/azure-rm-endpoint?view=azure-devops#what-happens-when-you-create-an-arm-service-connection)
3. Check if your ogranization has free tier Microsoft hosted parallel jobs assigned, if not submit a request. Refer [this](https://microsoft.seismic.com/share/PTVT8mQ8WgGGHWTWJVHhHq3DbVD) link to understand more on parallel jobs.

---------------------------------------------------------------------------------------------------------------------------------------------------------
**Step 1: Create Azure DevOps Project**
---------------------------------------------------------------------------------------------------------------------------------------------------------
+ Login to https://dev.azure.com to open Azure DevOps. Make sure your organization is selected on top left side. Click on New project.

<img width="940" alt="image" src="https://user-images.githubusercontent.com/84516667/198498295-2eb40fe9-ec3c-43fb-a846-e2f47d65a29d.png">

+ Provide project name that will be used for this workshop and check other settings in screenshot below. Click on Create.

<img width="322" alt="image" src="https://user-images.githubusercontent.com/84516667/198498472-db51107b-79bd-474f-bb94-976fffe66e2f.png">


**Step 2: Create ARM Service connection to Prod subscription** 
---------------------------------------------------------------------------------------------------------------------------------------------------------

+ Go to the project created above, and select Project settings.

<img width="149" alt="image" src="https://user-images.githubusercontent.com/84516667/198499277-9d01c1e0-e001-4642-b6bd-cf2989be15a5.png">

+ Under Pipelines, select Service connections --> New service connection/ Create Service Connection

<img width="908" alt="image" src="https://user-images.githubusercontent.com/84516667/198499398-eb353a36-274d-4cbe-86c4-8b3647e217a2.png">

+ Select Azure Resource Manager, clcik on Next at the bottom. Select Service principal (automatic) and click on Next.

<img width="290" alt="image" src="https://user-images.githubusercontent.com/84516667/198656134-4b64be39-299a-423a-b75b-7610125c6c54.png">

+ Select Scope level as Subscription, select your Prod subscription. Leave Resource group value as empty as we don't want to limit this connection to one single resource group.
+ Provide Service connection name (For Example, youralias_Prod) and click on Save.

<img width="248" alt="image" src="https://user-images.githubusercontent.com/84516667/198500438-ee545df0-f98e-4bbe-9715-7bf2026cd9a3.png">


Step 3: Checking Microsoft hosted Parallel jobs (Free tier)
---------------------------------------------------------------------------------------------------------------------------------------------------------

1. Login to https://dev.azure.com to open Azure DevOps. Select your Organization and click on Organization Settings. 

<img width="208" alt="image" src="https://user-images.githubusercontent.com/84516667/201188357-27fcb1c7-3e4b-4daf-868b-333572957d90.png">

2. Select Parallel jobs under pipelines and check if you see Microsoft-hosted Free tier parallel jobs as shown in the screenshot below,

<img width="698" alt="image" src="https://user-images.githubusercontent.com/84516667/201190398-8385360f-9c55-48d5-9d69-e7c2a922bceb.png">

If you don't have a free tier, you can request this grant by submitting a [request](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR63mUWPlq7NEsFZhkyH8jChUMlM3QzdDMFZOMkVBWU5BWFM3SDI2QlRBSC4u)

Note: You can select either Public or Private project depending on your usage.

<img width="924" alt="image" src="https://user-images.githubusercontent.com/84516667/201203577-98b94d93-4034-49c2-8796-c74af07a5092.png">

[Home](https://github.com/swmannepalli/Azure-Data-Factory-CI-CD)
