#!/usr/bin/env bash

# Create a security group for load balancer. In this group, allow port 80 on inbound.
aws ec2 create-security-group --group-name '<LoadBalancerSecurityGroupName>' --description 'application load balancer security group'
aws ec2 authorize-security-group-ingress --group-name '<LoadBalancerSecurityGroupName>' --protocol tcp --port 80 --cidr 0.0.0.0/0

# Create a security group for ecs. In this group, allow all ports from the load balancer security group.
aws ec2 create-security-group --group-name '<ContainerServiceSecurityGroupName>' --description 'container service security group'
aws ec2 authorize-security-group-ingress --group-name '<ContainerServiceSecurityGroupName>' --protocol tcp --port 1-65535 --source-group '<LoadBalancerSecurityGroupName>'

# Create an application load balancer that listens on port 80.
# You can use "aws ec2 describe-subnets" to list all subnets
aws elbv2 create-load-balancer --name ecs-load-balancer --subnets '<SubnetOneId>' '<SubnetTwoId>'

# Create target groups for each ecs service (In this example we are creating two target groups)
aws elbv2 create-target-group \
          --name '<TargetGroupOne>' \
          --protocol HTTP \
          --port 80 \
          --vpc-id '<VPCId>' \
          --health-check-interval-seconds 5 \
          --health-check-timeout-seconds 2 \
          --port 80
aws elbv2 create-target-group \
          --name '<TargetGroupTwo>' \
          --protocol HTTP \
          --port 80 \
          --vpc-id '<VPCId>' \
          --health-check-interval-seconds 5 \
          --health-check-timeout-seconds 2 \
          --port 80 \
          --health-check-path '/actuator/health'

# Create an ECS cluster. We will name our cluster '<ClusterName>'.
aws ecs create-cluster --cluster-name '<ClusterName>'

# Create an IAM role for the container instances
aws iam create-instance-profile --instance-profile-name '<InstanceProfileName>'
aws iam add-role-to-instance-profile --role-name '<RoleName>' --instance-profile-name '<InstanceProfileName>'

# Since we named the cluster, we need to pass that value to the ECS agent.
echo $'#!/bin/bash\necho ECS_CLUSTER=<ClusterName> >> /etc/ecs/ecs.config\n' >ecs-bootstrap.txt

# Add EC2 instances to ECS cluster.
# get the latest AMI id in http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI_launch_latest.html
aws ec2 run-instances \
        --image-id ami-5253c32d \
        --key-name '<KeyPairName>' \
        --security-group-ids '<ContainerServiceSecurityGroupName>' \
        --instance-type t2.micro \
        --iam-instance-profile Name='<InstanceProfileName>' \
        --user-data file://ecs-bootstrap.txt \
        --count 2
