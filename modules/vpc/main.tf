# modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  prevent_destroy = true
}

resource "aws_subnet" "public" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(["ap-south-1a", "ap-south-1b"], count.index)
  prevent_destroy = true
}

resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Security group for Redis"
  vpc_id      = aws_vpc.main.id

  prevent_destroy = true

  ingress {
    from_port   = 6379
    to_port     = 6379
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
