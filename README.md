# ReviewTrackers DevOps Code Challenge

The goal with this challenge is to evaluate your ability to use infrastructure as code to design and deploy well-thought-out, secure infrastructure.  While this challenge does have simple requirements, there is a lot of room for displaying knowledge of best practices and creativity.  Security, reliability, and ease of deployment will all be looked upon favorably when evaluating the end result.

When finished, please respond to the email from ReviewTrackers indicating that you have completed the challenge, and invite the GitHub users [`nvreynolds`](https://github.com/nvreynolds) and [`zopz`](https://github.com/zopz) as collaborators to the GitHub repository with read access. **Please keep this in a private GitHub repository**

## The Challenge

- Create a Dockerfile for running this repository's Python server in Docker
  - When you navigate to the `/status` endpoint, it should respond with `{"result": "success"}`
- Create Terraform file(s) for spinning up the needed infrastructure via a cloud provider
  - There should be a publicly accessible `/status` endpoint that responds with `{"result": "success"}`

### Requirements
  - All infrastructure must be provisioned via Terraform
  - You are free to use any third party providers or libraries you wish

### Deployment
**Note: You should not be creating any infrastructure/resources manually - aside from code that you write and the cloud account that you create, everything you make should be able to be created and destroyed through the Terraform files.**

You can deploy the infrastructure onto any cloud provider you like, most providers offer either free tier usage or a bucket of credits for new users. Because you do not need to keep these instances running, all of this should be able to be done within any platform, for free.  Here are some popular ones:
- https://aws.amazon.com/free/
- https://cloud.google.com/free/
- https://try.digitalocean.com/freetrialoffer/

Regardless of the provider that you choose, we should be able to deploy the infrastructure into our own account simply by entering our own access keys as Terraform variables.

### Stretch Goals
Feel free to do one or all of the below optional goals - show us where you shine!

- Build and push container image via CI
  - You can use either GitHub actions or Travis
  - Use any container repository that you like, public or private
- Write tests for the your code and run them via CI
  - You can use GitHub actions or Travis
  - Tests should run automatically when a pull request is created against the main branch
  - Grant `zopz` write access to the repository to test
- Write Kubernetes manifests or Helm charts to deploy the container into a Kubernetes cluster
  - You do not need to provide Terraform code for provisioning the cluster, you can assume an existing cluster
  - The application should be exposed as a service such that it can be accessed from a browser (local IP is fine)
- Create a `/ip` endpoint that returns the city and state of the IP requesting the page
  - You are free to use any third party software/services to convert the IP to location data
  - The response should be returned as a json result matching the following model:
    ```
    {
    "ip": "string",
    "city": "string",
    "state": "string"
    }
    ```

### Bonus Points
- Quality documentation
- DRY code
