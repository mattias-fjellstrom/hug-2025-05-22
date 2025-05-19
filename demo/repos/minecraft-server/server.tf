locals {
  rcon_cli_config = <<-EOF
  password: ${hcp_vault_secrets_secret.minecraft_password.secret_value}
  EOF

  hcp_credentials = jsonencode({
    scheme = "workload"
    workload = {
      provider_resource_name = "iam/project/${data.hcp_project.current.resource_id}/service-principal/hug-aws/workload-identity-provider/aws"
      aws = {
        imds_v2 = true
      }
    }
  })

  hcp_profile = <<-EOF
  name            = "default"
  organization_id = "${data.hcp_organization.current.resource_id}"
  project_id      = "${data.hcp_project.current.resource_id}"
  EOF

  hcp_active_profile = <<-EOF
  name = "default"
  EOF

  server_properties = <<-EOF
  accepts-transfers=false
  allow-flight=false
  allow-nether=true
  broadcast-console-to-ops=true
  broadcast-rcon-to-ops=true
  bug-report-link=
  difficulty=easy
  enable-command-block=false
  enable-jmx-monitoring=false
  enable-query=false
  enable-rcon=true
  enable-status=true
  enforce-secure-profile=true
  enforce-whitelist=false
  entity-broadcast-range-percentage=100
  force-gamemode=true
  function-permission-level=2
  gamemode=creative
  generate-structures=true
  generator-settings={}
  hardcore=false
  hide-online-players=false
  initial-disabled-packs=
  initial-enabled-packs=vanilla
  level-name=world
  level-seed=12384898975268864
  level-type=minecraft\:normal
  log-ips=true
  max-chained-neighbor-updates=1000000
  max-players=20
  max-tick-time=60000
  max-world-size=29999984
  motd=A Minecraft Server
  network-compression-threshold=256
  online-mode=true
  op-permission-level=4
  player-idle-timeout=0
  prevent-proxy-connections=false
  pvp=true
  query.port=25565
  rate-limit=0
  rcon.password=${hcp_vault_secrets_secret.minecraft_password.secret_value}
  rcon.port=25575
  region-file-compression=deflate
  require-resource-pack=false
  resource-pack=
  resource-pack-id=
  resource-pack-prompt=
  resource-pack-sha1=
  server-ip=
  server-port=25565
  simulation-distance=10
  spawn-animals=true
  spawn-monsters=true
  spawn-npcs=true
  spawn-protection=16
  sync-chunk-writes=true
  text-filtering-config=
  use-native-transport=true
  view-distance=10
  white-list=false
  reducedDebugInfo=false
  EOF

  cloudinit_files_1 = {
    write_files = [
      {
        content = local.rcon_cli_config
        path    = "/home/mcserver/.rcon-cli.yaml"
      },
      {
        content = local.hcp_credentials
        path    = "/home/mcserver/.config/hcp/credentials/credentials.json"
      },
      {
        content = local.hcp_profile
        path    = "/home/mcserver/.config/hcp/profiles/default.hcl"
      },
      {
        content = local.hcp_active_profile
        path    = "/home/mcserver/.config/hcp/active_profile.hcl"
      },
      {
        content = file("${path.module}/files/waypoint/start_agent.sh")
        path    = "/home/mcserver/start_agent.sh"
      },
      {
        content     = file("${path.module}/files/waypoint/backup.sh")
        path        = "/home/mcserver/backup.sh"
        permissions = "0755"
      },
      {
        content = file("${path.module}/files/waypoint/agent.hcl")
        path    = "/home/mcserver/agent.hcl"
      },
      {
        content = file("${path.module}/files/waypoint/waypoint.service")
        path    = "/etc/systemd/system/waypoint.service"
      },
      {
        content = file("${path.module}/files/minecraft/start_server.sh")
        path    = "/home/mcserver/minecraft_java/start_server.sh"
      },
      {
        content = file("${path.module}/files/minecraft/stop_server.sh")
        path    = "/home/mcserver/minecraft_java/stop_server.sh"
      },
      {
        content = file("${path.module}/files/minecraft/mcjava.service")
        path    = "/etc/systemd/system/mcjava.service"
      },
      {
        content = file("${path.module}/files/minecraft/eula.txt")
        path    = "/home/mcserver/minecraft_java/eula.txt"
      },
      {
        content = file("${path.module}/files/minecraft/ops.json")
        path    = "/home/mcserver/minecraft_java/ops.json"
      },
      {
        content = local.server_properties
        path    = "/home/mcserver/minecraft_java/server.properties"
      },
    ]
  }
}

data "cloudinit_config" "server" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get clean
    EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      useradd -m mcserver
      usermod -a -G mcserver $USER
      mkdir -p /home/mcserver/minecraft_java
    EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get -y install gpg coreutils
      wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
      apt-get update
      apt-get -y install hcp
    EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      LAUNCHER_META_URL=https://launchermeta.mojang.com/mc/game/version_manifest.json
      DATA=$(curl -s "$LAUNCHER_META_URL" | jq .)
      LATEST_RELEASE=$(echo "$DATA" | jq -r .latest.release)
      RELEASE_META_URL=$(echo "$DATA" | jq -r --arg LATEST_RELEASE "$LATEST_RELEASE" '.versions[] | select(.id == $LATEST_RELEASE) | .url')
      DOWNLOAD_URL=$(curl -s "$RELEASE_META_URL" | jq -r .downloads.server.url)
      wget "$DOWNLOAD_URL" -O /home/mcserver/minecraft_java/server.jar
      chown -R mcserver: /home/mcserver/
    EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      # install JRE
      add-apt-repository ppa:openjdk-r/ppa
      apt-get update
      apt-get -y install openjdk-21-jdk

      # install AWS CLI
      snap install aws-cli --classic

      # install rcon-cli
      DOWNLOAD_URL=https://github.com/itzg/rcon-cli/releases/download/1.7.0/rcon-cli_1.7.0_linux_amd64.tar.gz
      wget $DOWNLOAD_URL -O rcon.tar.gz
      tar -xvf rcon.tar.gz
      mv rcon-cli /usr/local/bin
    EOF
  }

  part {
    content_type = "text/cloud-config"
    content      = yamlencode(local.cloudinit_files_1)
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      systemctl enable mcjava
      systemctl start mcjava
    EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
      #!/bin/bash
      systemctl enable waypoint
      systemctl start waypoint
    EOF
  }
}

data "aws_ami" "ubuntu" {
  filter {
    name   = "name"
    values = ["ubuntu/images/*ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  most_recent = true
  owners      = ["099720109477"]
}

resource "aws_instance" "server" {
  ami              = data.aws_ami.ubuntu.id
  instance_type    = "t3.xlarge"
  subnet_id        = aws_subnet.public.id
  user_data_base64 = data.cloudinit_config.server.rendered

  # this key must exist, it is set up in the demo folder
  key_name = "hug-waypoint"

  iam_instance_profile = aws_iam_instance_profile.server.name

  vpc_security_group_ids = [
    aws_security_group.server.id,
  ]

  lifecycle {
    ignore_changes = [user_data_base64]
  }
}
