# The elastic beanstalk application
resource "aws_elastic_beanstalk_application" "adapt-webapp" {
  name = "Test Application"
  description = "Test Application"
}

# The test environment
resource "aws_elastic_beanstalk_environment" "testenv" {
  name                  = "testenv"
  application           = "${aws_elastic_beanstalk_application.adapt-webapp.name}"
  solution_stack_name   = "64bit Amazon Linux 2016.03 v2.1.0 running Docker 1.9.1"
  tier                  = "WebServer"

  # This is the VPC that the instances will use.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.default.id}"
  }

  # This is the subnet of the ELB
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${aws_subnet.default.id}"
  }

  # This is the subnets for the instances.
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${aws_subnet.default.id}"
  }

  # You can set the environment type, single or LoadBalanced
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  # Example of setting environment variables
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "AWS_ENVIRONMENT"
    value     = "test"
  }

  # Are the load balancers multizone?
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }

  # Enable connection draining.
  setting {
    namespace = "aws:elb:policies"
    name      = "ConnectionDrainingEnabled"
    value     = "true"
  }
}
