### create and update scripts for the app stack.
```
aws cloudformation create-stack --stack-name BeanstalkDemo \
--template-body file:///Users/bswift/src/aws/eb_demo/cloudformation/applicationPipeline.yaml \
--region eu-west-1 --disable-rollback --capabilities="CAPABILITY_IAM" \
--parameters ParameterKey=PipelineName,ParameterValue=BeanstalkDemoPipeline \
ParameterKey=GithubUser,ParameterValue=brettswift \
ParameterKey=GithubToken,ParameterValue=$GITHUB_AWS_TOKEN \
--tags Key=owner,Value=`whoami`
```

```
aws cloudformation update-stack --stack-name BeanstalkDemo \
--template-body file:///Users/bswift/src/aws/eb_demo/cloudformation/applicationPipeline.yaml \
--region eu-west-1 --capabilities="CAPABILITY_IAM" \
--parameters ParameterKey=PipelineName,ParameterValue=BeanstalkDemoPipeline \
ParameterKey=GithubUser,ParameterValue=brettswift \
ParameterKey=GithubToken,ParameterValue=$GITHUB_AWS_TOKEN
```

###Create initial pipeline that creates the stack above.
* Problem: can't pass param from this stack to the child stack (github token).
   * One solution:  use kms. But.. quite a bit of setup, although it could be used by a bunch of stacks.
 `https://ben.fogbutter.com/2016/02/22/using-kms-to-encrypt-cloud-formation-values.html`
```
aws cloudformation create-stack --stack-name MainBeanstalkDemoPipeline \
--template-body file:///Users/bswift/src/aws/eb_demo/cloudformation/main-pipeline.yaml \
--region eu-west-1 --disable-rollback --capabilities="CAPABILITY_IAM" \
--parameters ParameterKey=PipelineName,ParameterValue=MainBeanstalkDemoPipeline \
ParameterKey=GithubUser,ParameterValue=brettswift \
ParameterKey=GithubToken,ParameterValue=$GITHUB_AWS_TOKEN \
ParameterKey=Email,ParameterValue=brettswift@gmail.com \
--tags Key=owner,Value=`whoami`
```
