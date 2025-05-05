#!/usr/bin/env bash

hcp auth login --cred-file=/home/mcserver/.config/hcp/credentials/credentials.json
hcp waypoint agent run --config=/home/mcserver/agent.hcl