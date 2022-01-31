# Jenkins
There are two examples provided: `Using-VHT-Module` which uses VHT Python module and `VHT-as-Jenkins-Node` which creates a Jenkins node from VHT AMI.

## Using VHT-Module
In this approach, it is used VHT Python module, which is build on top of AWS SDK, to drive the VHT process. The Jenkins node is just a caller for it. The actual work is done by an EC2 instance created by the VHT Python module. In other words, the Jenkins pipeline is just a light-weight front end having enough code to run the VHT Python module.

### Content of Using-VHT-Module
* jobDSL: Jenkins configuration as code to create the VHT Jenkins Job.
* pipeline: Example of running VHT using VHT Python Module.

### Dependencies
#### AWS Account
* AWS IAM User is needed to be created in your AWS Account. [See item 1 and 2](https://arm-software.github.io/VHT/main/infrastructure/html/run_ami_github.html#github_hosted1).
* A S3 Bucket is needed to store temporary files. No special requirement is needed.
* Security Group with Ingress SSH port allowed.
* IAM Instance Profile to be associated with the VHT EC2 instances. [See item 3](https://arm-software.github.io/VHT/main/infrastructure/html/run_ami_github.html#github_hosted1)
* `Optional` SSH Key is needed if you would like to debug on EC2.
* Subnet Id needs to be informed with EC2 instance.

**It is provided a Cloudformation (AWS Infrastructure as Code) yaml file which can create the required AWS Resources for VHT, please go to ./infrastructure/cloudformation folder**

#### Jenkins plugins
* [CloudBees AWS Credentials](https://plugins.jenkins.io/aws-credentials/) - Tested on v1.29
* [Pyenv-pipeline](https://plugins.jenkins.io/pyenv-pipeline/) - Tested on v2.1.2
* [JobDSL - needed if the JobDSL code is used](https://plugins.jenkins.io/job-dsl/) - Tested on v1.77

#### Jenkins Credentials
* AWS Credential for IAM User (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`)
* AWS SSH Private Key to be associated with the EC2 instance.

## VHT-as-Jenkins-Node
In this example, it is created a Jenkins node from the VHT AMI. Jenkins node is connected by SSH in Jenkins Controller and the commands are executed directly to the EC2 instance (as a Jenkins Node in this case).

### Content of Using-VHT-Module
* configuration-as-code: Example of Amazon EC2 plugin code.
* jobDSL: Jenkins configuration as code to create the VHT as Jenkins Node job.
* pipeline: Example of running VHT as Jenkins Node.

### Dependencies
#### AWS Account
* AWS IAM User is needed to be created in your AWS Account. [See item 1 and 2](https://arm-software.github.io/VHT/main/infrastructure/html/run_ami_github.html#github_hosted1).
* Security Group with Ingress SSH port allowed.
* SSH Keys are needed to communicate with EC2 instance as Jenkins Nodes.
* Subnet Id needs to be informed with EC2 instance.

**It is provided a Cloudformation (AWS Infrastructure as Code) yaml file which can create the required AWS Resources for VHT, please go to ./infrastructure/cloudformation folder**

#### Jenkins plugins
* [Amazon EC2](https://plugins.jenkins.io/ec2/) - Tested on v1.57
* [JobDSL - needed if the JobDSL code is used](https://plugins.jenkins.io/job-dsl/) - Tested on v1.77

#### Jenkins Credentials
* AWS Credential for IAM User (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`)
* AWS SSH Private Key to be associated with the EC2 instance.
