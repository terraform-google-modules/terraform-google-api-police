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
resource "google_project_service" "pubsub" {
  project = "${google_project.api_police_project.project_id}"
  service = "pubsub.googleapis.com"
}

resource "google_project_service" "servicemanagement" {
  project = "${google_project.api_police_project.project_id}"
  service = "servicemanagement.googleapis.com"
}

resource "google_project_service" "cloudfunctions" {
  project = "${google_project.api_police_project.project_id}"
  service = "cloudfunctions.googleapis.com"
}
