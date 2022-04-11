// Developed and tested using jobDSL plugin v1.77
// https://plugins.jenkins.io/job-dsl/
//
// This is just a example, change it for your need
/* ************************************************************************* */
println("Adding folder...")
def AVHFolder = folder('AVH') {
    displayName('AVH')
    description('')
}

/ ************************************************************************** */
println("Creating AVH jobs ...")
pipelineJob("${AVHFolder.name}/AVH-as-Jenkins-Node") {
    displayName('AVH')
    description('AVH as Jenkins Node')
    logRotator {
        daysToKeep(14)
    }
    disabled(false)
    definition {
        cpsScm {
            lightweight(true)
            // Path for your pipeline. Change it for your need.
            scriptPath('.jenkins/AVH-as-Jenkins-Node/pipeline/Jenkinsfile')
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
