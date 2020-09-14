def SHORT_COMMIT
def SCM_REPO

podTemplate(
    imagePullSecrets: ['dockerhub-imagepull'],
    containers: [
        containerTemplate(
            name: 'build-tools',
            image: 'docker.io/numtechnology/build-tools:gradle-5.1.1-jdk8-docker',
            ttyEnabled: true,
            command: 'cat',
            resourceRequestCpu: '50m',
            resourceLimitCpu: '50m',
            resourceRequestMemory: '256Mi',
            resourceLimitMemory: '256Mi'),
        ],
    volumes: [
        hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
    ]) {


    node(POD_LABEL) {

        SCM_REPO = checkout scm
        SHORT_COMMIT = "${SCM_REPO.GIT_COMMIT[0..6]}"

        try {

            stage('Test MODL') {
                container('build-tools') {
                    sh "./run-tests.sh"
                }
            }

            stage('Build Container') {
                container('build-tools') {
                    sh "docker build --network=host --build-arg IMG_NAME=${env.BRANCH_NAME}-${SHORT_COMMIT} -t modules-files-${SHORT_COMMIT} ."
                }
            }

            stage('Tag Latest') {
                container('build-tools') {
                   sh "docker tag modules-files-${SHORT_COMMIT} numtechnology/modules-files:${env.BRANCH_NAME}-${SHORT_COMMIT}"
                   if(env.BRANCH_NAME == 'master') {
                       sh "docker tag modules-files-${SHORT_COMMIT} numtechnology/modules-files:latest"
                   }
                }
            }

            stage('Push Container') {
                container('build-tools') {
                    script {
                        withDockerRegistry([credentialsId: "docker", url: ""]) {
                            sh "docker push numtechnology/modules-files:${env.BRANCH_NAME}-${SHORT_COMMIT}"
                            if(env.BRANCH_NAME == 'master') {
                                sh "docker push numtechnology/modules-files:latest"
                            }
                        }
                    }
                }
            }

        } catch (e) {
            slackSend (
                color: '#FF0000',
                message: '`modules-files` build has failed on branch `' + env.BRANCH_NAME + '`\n' + \
                         'more info on ' + env.BUILD_URL,
                channel: '#_modules')
            throw e
        }
    }
}