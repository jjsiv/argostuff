import yaml

AFFINITY_TEMPLATE = {
  "affinity": {
    "nodeAffinity": {
      "preferredDuringSchedulingIgnoredDuringExecution": [
        {
          "weight": 1,
          "preference": {
            "matchExpressions": [
              {
                "key": "node/type",
                "operator": "NotIn",
                "values": [
                  "manager"
                ]
              }
            ]
          }
        }
      ]
    }
  }
}

def update_vars(crd_vars: dict, deployment_vars: dict):
    with open("output.yaml", "w") as file_out:
        yaml.safe_dump(crd_templates, file_out)
        yaml.safe_dump(deployment_templates, file_out)


def main():
    crd_templates = {"crd_templates": []}
    deployment_templates = {"deployment_templates": []}

    with open("setup.yaml", mode="r") as file:
        setup_yaml = yaml.safe_load_all(file)

        for doc in setup_yaml:
            if doc["kind"] == "CustomResourceDefinition":
                crd_templates["crd_templates"].append(doc["spec"]["names"]["kind"])
            else:
                deployment_templates["deployment_templates"].append(doc["kind"])


if __name__ == '__main__':
    main()