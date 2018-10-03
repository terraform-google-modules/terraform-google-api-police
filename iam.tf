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
resource "google_pubsub_topic_iam_binding" "publisher" {
  project = "${google_project.api_police_project.project_id}"
  topic   = "${google_pubsub_topic.api_enable_topic.name}"
  role    = "roles/pubsub.publisher"
  members = ["${google_logging_organization_sink.api_sink.writer_identity}"]
}

resource "google_organization_iam_member" "binding" {
  org_id     = "${var.org_id}"
  role       = "roles/editor"
  member     = "serviceAccount:${google_project.api_police_project.project_id}@appspot.gserviceaccount.com"
  depends_on = ["google_cloudfunctions_function.function"]
}
