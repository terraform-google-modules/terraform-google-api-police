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

data "template_file" "cf" {
  template = "${file("${path.module}/index.js.tftemplate")}"

  vars {
    blockedList = "${jsonencode(var.blocked_apis_list)}"
  }
}

data "archive_file" "gcf_zip_file" {
  type        = "zip"
  output_path = "gcf.zip"

  source {
    content  = "${data.template_file.cf.rendered}"
    filename = "index.js"
  }

  source {
    content  = "${file("${path.module}/package.json")}"
    filename = "package.json"
  }
}

resource "google_storage_bucket" "gcf_source_bucket" {
  name    = "${var.gcs_bucket}"
  project = "${google_project.api_police_project.project_id}"
}

resource "google_storage_bucket_object" "gcf_zip_gcs_object" {
  name   = "gcf.zip"
  bucket = "${google_storage_bucket.gcf_source_bucket.name}"
  source = "${data.archive_file.gcf_zip_file.output_path}"
}
