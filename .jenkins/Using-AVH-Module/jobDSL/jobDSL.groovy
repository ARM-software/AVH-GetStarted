// Developed and tested using jobDSL plugin v1.77
// https://plugins.jenkins.io/job-dsl/
//
// This is just a example, change it for your need


/* ************************************************************************* */
println("Adding folder...")
def avhFolder = folder('AVH') {
    displayName('AVH')
    description('')
}

/ * ************************************************************************* */
println("Creating AVH job ...")
pipelineJob("${avhFolder.name}/AVH_GetStarted") {
    displayName('AVH GetStarted Example')
    description('AVH Example Pipeline')
    logRotator {
        daysToKeep(14)
    }
    disabled(false)
    parameters {
        stringParam {
            name('AWS_DEFAULT_REGION')
            defaultValue('eu-west-1')
            description('')
            trim(true)
        }
        stringParam {
            name('AWS_S3_BUCKET_NAME')
            defaultValue('gh-orta-vht')
            description('Your S3 Bucket Name e.g. gh-orta-vht in this example. You must change it')
            trim(true)
        }
        stringParam {
            name('AWS_IAM_PROFILE')
            defaultValue('VHTRole')
            description('This is the name proposed on the Cloudformation example')
            trim(true)
        }
        stringParam {
            name('AWS_SECURITY_GROUP_ID')
            defaultValue('sg-04022e04e91197ce3')
            description('Your Security Group ID e.g. sg-04022e04e91197ce3 in this example. You must change it.')
            trim(true)
        }
        stringParam {
            name('AWS_SUBNET_ID')
            defaultValue('subnet-00455495b268076f0')
            description('Your Subnet ID e.g. subnet-00455495b268076f0 in this example. You must change it.')
            trim(true)
        }
    }
    definition {
        cpsScm {
            lightweight(true)
            // Path for your pipeline. Change it for your need.
            scriptPath('.jenkins/Using-AVH-Module/pipeline/Jenkinsfile')
            scm {
                git {
                    remote {
                        url('https://github.com/ARM-software/AVH-GetStarted.git')
                    }
                    branches('main')
                    extensions {
                        wipeWorkspace()
                        cloneOptions {
                            honorRefspec(true)
                            noTags(true)
                            shallow(true)
                            depth(1)
                        }
                    }
                }
            }
        }
    }
}
