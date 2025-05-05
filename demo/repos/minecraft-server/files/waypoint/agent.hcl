group "minecraft" {
  action "say" {
    run {
      command = ["rcon-cli", "--", "say", "${var.message}"]
    }
  }

  action "weather" {
    run {
      command = ["rcon-cli", "--", "weather", "${var.weather}", "${var.duration}"]
    }
  }

  action "time" {
    run {
      command = ["rcon-cli", "--", "time", "set", "${var.time}"]
    }
  }

  action "backup" {
    operation {
      run {
        command = ["rcon-cli", "--", "say", "A server backup will be performed in 3 minutes!"]
      }
    }

    operation {
      run {
        command = ["sleep", "120"]
      }
    }

    operation {
      run {
        command = ["rcon-cli", "--", "say", "A server backup will be performed in 1 minute!"]
      }
    }

    operation {
      run {
        command = ["sleep", "60"]
      }
    }

    operation {
      run {
        command = ["rcon-cli", "--", "save-all", "flush"]
      }
    }

    operation {
      run {
        command = ["./backup.sh", "${ application.outputs.bucket }"]
      }
    }

    operation {
      run {
        command = ["rcon-cli", "--", "say", "Backup complete!"]
      }
    }
  }
}