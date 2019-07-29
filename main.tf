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
resource "google_project" "api_police_project" {
  name                = "GCP API Police"
  project_id          = "${var.project_id}"
  org_id              = "${var.org_id}"
  billing_account     = "${var.billing_id}"
  auto_create_network = false
}

resource "google_pubsub_topic" "api_enable_topic" {
  name       = "${var.pubsub_topic}"
  project    = "${google_project.api_police_project.project_id}"
  depends_on = ["google_project_service.pubsub"]
}

resource "google_logging_organization_sink" "api_sink" {
  name             = "${var.export_sink}"
  org_id           = "${var.org_id}"
  include_children = true
  destination      = "pubsub.googleapis.com/projects/${google_project.api_police_project.project_id}/topics/${var.pubsub_topic}"
  filter           = "(protoPayload.methodName:\"google.api.serviceusage\" AND protoPayload.methodName:EnableService) OR (protoPayload.methodName:\"google.api.servicemanagement\" AND protoPayload.methodName:ActivateServices)"
}

resource "google_cloudfunctions_function" "function" {
  project               = "${google_project.api_police_project.project_id}"
  region                = "us-central1"
  name                  = "apiPolice"
  source_archive_bucket = "${google_storage_bucket.gcf_source_bucket.name}"
  source_archive_object = "${google_storage_bucket_object.gcf_zip_gcs_object.name}"
  trigger_topic         = "${google_pubsub_topic.api_enable_topic.name}"
  retry_on_failure      = true
  depends_on            = ["google_project_service.cloudfunctions", "google_project_service.servicemanagement"]
}
