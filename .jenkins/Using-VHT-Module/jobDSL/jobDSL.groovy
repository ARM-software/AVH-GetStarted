// Developed and tested using jobDSL plugin v1.77
// https://plugins.jenkins.io/job-dsl/
//
// This is just a example, change it for your need


/* ************************************************************************* */
println("Adding folder...")
def vhtFolder = folder('VHT') {
    displayName('VHT')
    description('')
}

/ * ************************************************************************* */
println("Creating VHT job ...")
pipelineJob("${vhtFolder.name}/VHT") {
    displayName('VHT')
    description('VHT pipeline')
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
            name('instance_id')
            defaultValue('')
            description('Optional - Instance ID, if blank Jenkins will create a new EC2 instance')
            trim(true)
        }
        stringParam {
            name('instance_type')
            defaultValue('t2.micro')
            description('Optional - Instance Type')
            trim(true)
        }
        stringParam {
            name('security_group_id')
            defaultValue('sg-04022e04e91197ce3')
            description('Your Security Group ID e.g. sg-04022e04e91197ce3 in this example. You must change it.')
            trim(true)
        }
        stringParam {
            name('iam_profile')
            defaultValue('VHTRole')
            description('This is the name proposed on the Cloudformation example')
            trim(true)
        }
        stringParam {
            name('s3_bucket_name')
            defaultValue('gh-orta-vht')
            description('Your S3 Bucket Name e.g. gh-orta-vht in this example. You must change it')
            trim(true)
        }
        stringParam {
            name('ssh_key_name')
            defaultValue('SSH-Key-Name')
            description('Optional -- Inject SSH Key -- only for debug reasons')
            trim(true)
        }
        stringParam {
            name('subnet_id')
            defaultValue('subnet-00455495b268076f0')
            description('Your Subnet ID e.g. subnet-00455495b268076f0 in this example. You must change it.')
            trim(true)
        }
        stringParam {
            name('terminate_ec2_instance')
            defaultValue('true')
            description('`true` or `false`')
            trim(true)
        }
        stringParam {
            name('ami_version')
            defaultValue('1.1.0')
            description('VHT AMI Version')
            trim(true)
        }
        stringParam {
            name('vht_in')
            defaultValue('./basic/')
            description('')
            trim(true)
        }
    }
    definition {
        cpsScm {
            lightweight(true)
            // Path for your pipeline. Change it for your need.
            scriptPath('.jenkins/Using-VHT-Module/pipeline/Jenkinsfile')
            scm {
                git {
                    remote {
                        url('https://github.com/ARM-software/VHT-GetStarted.git')
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
