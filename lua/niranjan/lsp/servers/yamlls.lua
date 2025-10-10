return {
  settings = {
    yaml = {
      schemas = {
        kubernetes = "/*.k8s.yaml",
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/*docker-compose*.yml",
        ["https://raw.githubusercontent.com/ansible/schemas/main/f/ansible-playbook.json"] = "/*playbook*.yml",
        ["https://raw.githubusercontent.com/ansible/schemas/main/f/ansible-tasks.json"] = "/tasks/*.yml",
        ["https://raw.githubusercontent.com/ansible/schemas/main/f/ansible-vars.json"] = "/vars/*.yml",
      },
    },
  },
}
