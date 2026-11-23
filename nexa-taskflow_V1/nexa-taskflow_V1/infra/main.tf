# Infrastructure de TaskFlow (AWS) — volontairement mal configurée.
# Ce code n'a pas vocation à être appliqué : il sert uniquement à l'analyse.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_s3_bucket" "exports" {
  bucket = "taskflow-exports-demo"
}

resource "aws_s3_bucket_acl" "exports" {
  bucket = aws_s3_bucket.exports.id
  acl    = "public-read"
}

resource "aws_security_group" "web" {
  name        = "taskflow-web"
  description = "Acces a l'API TaskFlow"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8085
    to_port     = 8085
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "api" {
  ami                    = "ami-0123456789abcdef0"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_size = 20
    encrypted   = false
  }

  tags = {
    Name = "taskflow-api"
  }
}

resource "aws_db_instance" "tasks" {
  identifier          = "taskflow-db"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "taskflow"
  password            = "ChangeMe123!"
  publicly_accessible = true
  storage_encrypted   = false
  skip_final_snapshot = true
}
