/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
variable "project_id" {
  description = "Project ID to hold GCF"
}

variable "org_id" {
  description = "Organization ID to monitor"
}

variable "billing_id" {
  description = "Billing Account ID to charge"
}

variable "pubsub_topic" {
  description = "Pub/Sub topic name to export logs to"
  default     = "service-activate-topic"
}

variable "export_sink" {
  description = "StackDriver log export sink"
  default     = "service-activate-sd-sink"
}

variable "gcs_bucket" {
  description = "bucket to hold cloud function source"
}

variable "blocked_apis_list" {
  type        = list(string)
  description = "list of APIs to prevent being used"
}
