# GCP-API-Police-CF-tf

This module is a way to deploy a custom Cloud Function that monitors and disables unapproved Google APIs within a GCP Organization. Upon detection that an unapproved API has been enabled, the Cloud Function will actively and automatically disable the API in violation of this policy. This is accomplished by exporting Cloud Audit logs looking for the enablement of APIs under an organization. Those logs are then exported via a Stackdriver Organizational Aggregated Export sink to a Pub/Sub topic, which will then trigger the Cloud Function. This module will provision and connect all the necessary pieces to accomplish this.

## Usage

```hcl
module "gcf_api_police" {
  source = "github.com/terraform-google-modules/terraform-google-api-police"
  project_id = "reechar-gcp-api-police"              #Change to unique project ID
  org_id     = "1234567890"                          #Change to org id for Organization to be monitored
  billing_id = "ABCDEF-ABCDEF-ABCDEF"                #Change to your billing account
  gcs_bucket = "reechar-gcf"                         #Change to unique GCS bucket name
  blocked_api_list = ["translate.googleapis.com"]    #List of Google APIs to block, Translate API used as example
}
```

## Test and Verify

If you deployed the Cloud Function without modifying the list `translate.googleapis.com` should be blocked. 
```shell
$ gcloud config set project <project_id that you used in step 4>
$ gcloud services list #list currently enabled APIs in project
$ gcloud services enable translate.googleapis.com #try to enable blocked translate API
$ gcloud services enable vision.googleapis.com #enable not blocked API
$ gcloud services list #verify that vision.googleapis is enabled, but translate.googleapis is not
```
## Defense in Depth

As a word of caution, this module is not meant to be a standalone set it and forget it solution. I recommend the practice of [defense in depth](https://en.wikipedia.org/wiki/Defense_in_depth_(computing)) and to have multiple tiers of defense towards addressing this security issue. This solution complements well with a policy scanning tool like [Forseti Security](https://forsetisecurity.org/).


