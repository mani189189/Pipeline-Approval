pipeline {
agent any 
stages {

stage('Build') {
steps {
sh 'ant -f build.xml -v'
echo 'Building..'
}
}


 stage('Unit Tests') {
        steps {
            sh 'ant -f test.xml -v'
            junit 'reports/result.xml'
                }
}

 stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                 echo 'make publish'
            }
        }
       }                     

post {
	always {
        
          archiveArtifacts artifacts: 'dist/*.jar', fingerprint: true
        }
      }
    }


