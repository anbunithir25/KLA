source "docker" "fibonacci_image" {
  from_image = "python:3.9-slim"

  # Image Name of the docker container
  image_tag = "fibonacci:latest"
}

# Docker Build process
build {
  sources = [
    "source.docker.fibonacci_image"
  ]

  # Packer Provisioner to copy the python script to the container location
  provisioner "file" {
    source      = "./fibonacci.py"
    destination = "/app/fibonacci.py"
  }

  # Packer shell Provisioner to run shell commands
  provisioner "shell" {
    inline = [
      "chmod +x /app/fibonacci.py"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'ENTRYPOINT [\"python\", \"/app/fibonacci.py\"]' > /app/Dockerfile"
    ]
  }
}

