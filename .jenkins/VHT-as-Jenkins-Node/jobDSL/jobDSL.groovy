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

/ ************************************************************************** */
println("Creating VHT jobs ...")
pipelineJob("${vhtFolder.name}/VHT-as-Jenkins-Node") {
    displayName('VHT')
    description('VHT as Jenkins Node')
    logRotator {
        daysToKeep(14)
    }
    disabled(false)
    definition {
        cpsScm {
            lightweight(true)
            // Path for your pipeline. Change it for your need.
            scriptPath('.jenkins/VHT-as-Jenkins-Node/pipeline/Jenkinsfile')
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
