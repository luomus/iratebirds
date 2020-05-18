brew install awscli jq

source .env

# latest amazon linux 2 image
LINUX2=$( \
  aws ec2 describe-images \
    --owners amazon \
    --filters \
      "Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2" \
      "Name=state,Values=available" \
    --query "reverse(sort_by(Images, &CreationDate))[:1].ImageId" \
    --output text
)

# security group
SECURITY_GROUP_ID=$( \
  aws ec2 create-security-group \
    --group-name $HOST \
    --description "security group for $HOST" | \
  jq -r ".GroupId"
)

# local ip
CIDR=$(echo `curl -s https://checkip.amazonaws.com`/32)

set_sec_grp () {
 aws ec2 authorize-security-group-ingress \
   --group-id $SECURITY_GROUP_ID \
   --protocol tcp \
   --port $1 \
   --cidr $2
}
   
set_sec_grp 22 $CIDR
set_sec_grp 5342 $CIDR
set_sec_grp 80 0.0.0.0/0
set_sec_grp 443 0.0.0.0/0

aws ec2 create-key-pair --key-name $HOST > $KEYPAIR

INSTANCE=$( \
  aws ec2 run-instances \
    --image-id $LINUX2 \
    --instance-type t2.micro \
    --key-name $HOST \
    --security-group-ids $SECURITY_GROUP_ID | \
  jq -r ".Instances[0].InstanceId"
)

ALLOCATION=$(aws ec2 allocate-address --domain vpc | jq -r ".AllocationId")

aws ec2 associate-address --instance-id $INSTANCE --allocation-id $ALLOCATION

ELASTICIP=$( \
  aws ec2 describe-addresses \
    --allocation-ids $ALLOCATION | \
  jq -r ".Addresses[0].PublicIp"
)

curl -X POST \
  https://api.gandi.net/v5/livedns/domains/$DOMAIN/records/$HOST/A \
  -H "Authorization: Apikey $GANDIKEY" \
  -H "content-type: application/json" \
  -d "{\"rrset_values\":[\"$ELASTICIP\"]}"

PUBLIC_DNS_NAME=$(
  aws ec2 describe-instances \
    --instance-ids $INSTANCE | \
  jq -r ".Reservations[0].Instances[0].PublicDnsName"
)

alias ec2exec="ssh -i $KEYPAIR -t ec2-user@$PUBLIC_DNS_NAME"

ec2exec "sudo yum update -y"
ec2exec "sudo yum install git -y"
ec2exec "sudo amazon-linux-extras install docker"
ec2exec "sudo service docker start"
ec2exec "sudo usermod -a -G docker ec2-user"
ec2exec "sudo curl -L \"https://github.com/docker/compose/latest/download/docker-compose-`uname -s`-`uname -m`\" -o /usr/local/bin/docker-compose"
ec2exec "sudo chmod +x /usr/local/bin/docker-compose"
ec2exec "git clone https://github.com/$GITHUBUSER/$HOST.git"
scp -i $KEYPAIR .env ec2-user@$PUBLIC_DNS_NAME:/$HOST
ec2exec "docker-compose -f $HOST/docker-compose.yml up -d"
