[
  {
    "name": "${container}",
    "image": "${image}",
    "portMappings": [
      {
        "name" : "${port_name}",
        "containerPort": ${container_port},
        "appProtocol": "http"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-create-group": "true",
        "awslogs-region": "${region}",
        "awslogs-group": "${loggroup}", 
        "awslogs-stream-prefix": "ecs"
      },
      "secretOptions": []
    },
    "environment": [],
    "environmentFiles": [],
    "ulimits": []
  }
]