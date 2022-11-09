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

def main():
    with open("jenkins-deployment.yaml", mode="rb") as file:
        jenkins_yaml = yaml.safe_load(file)
    jenkins_yaml["spec"]["template"]["spec"].update(AFFINITY_TEMPLATE)
    
    with open("jenkins_yaml.yaml", mode="w") as file:
        yaml.safe_dump(jenkins_yaml, file)


if __name__ == '__main__':
    main()