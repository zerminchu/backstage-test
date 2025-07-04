terraform {
  source = "git::git@sgts.gitlab-dedicated.com:wog/mha/ica-e-services/ica_common_services/app/aws_tg.git//tg-modules//s3"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  bucket_list = {
    "0" = ["na", "s3logs", false, 0, false, true, false, null, false, true]
  }
}
