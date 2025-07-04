terraform {
    source = ""
}

include "root" {
    path = find_in_parent_folders()
}

inputs = {
    namespace                  = "cluster"
    namespace_type      = "private_dns"
    svc_names                 = [
  "ecs-test"
]
}
