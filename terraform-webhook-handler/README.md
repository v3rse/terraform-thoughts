# Webhook handler
- install dependencies into src folder: `npm install --prefix src`
- install developer dependencies: `npm install --save-dev`
- lint and build deployment package `webhook-handler.zip`: `npm run build`
- deploy handler lambda: `terraform apply`

# Organization
On developer experience:
- each service should be number of lambdas in this case a webhook handler service
- each lambda has a single responsibility
- to make a change locally:
  - create feature branch: `git checkout -b <feature-branch>`
  - open or create the directory for the function: `lerna create <new-function>` - __Git__
  - write a test for the lambda function: `cd __test__; code <new-function>.test.js` __Jest__
  - write the lambda function: `cd lib; code <new-function>.js` __Node.js/NPM__
  - update infra files to incorporate changes __Terraform__
  - manually test it by deploying to a local or remote test environment using `infra` setup __Terraform+AWS__
  - tear down test environment local test environment __Terraform__
- to review and integrate change:
  - push changes to remote repo __Github/Gitlab__
  - go through review __Github/Gitlab__
  - run `audit` stage: audit, lint, test __Github/Gitlab__
  - merge to master __Github/Gitlab__
- to deploy changes to environments:
  - CI runs packaging code
  - CI runs infra update and pushes deployment packages

N/B: An alternative to having infra file here is to have them in the central infra repo and then have the CI build and upload deployment packages to S3 to be picked up by infra code reference

Using Terraform to create deployment packages:
- use `archive` data source
- create `lambda_layer` resource for node_modules
- crate `lambda` that depends on node_modules in layer
- essentially all lambdas in the service will share a single layer