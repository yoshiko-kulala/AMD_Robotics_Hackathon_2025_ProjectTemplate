#!/bin/bash

if [ $# -le 2 ]; then
    echo "Usage: $0 <JOB_NAME> <ROBOT_PORT> <CAMERA_PORT>" >&2
    exit 1
fi

JOB_NAME=$1
ROBOT_PORT=$2
CAMERA_PORT=$3


rm -rf /home/amddemo/.cache/huggingface/lerobot/yoshikokulala/eval*

sudo chmod 777 /dev/ttyACM*
sudo chmod 777 /dev/video*

cd /home/amddemo/${JOB_NAME}
git lfs install
git lfs pull

lerobot-record    --robot.type=so101_follower \
 --robot.port=${ROBOT_PORT} \
 --robot.id=my_awesome_follower_arm \
 --robot.cameras='{ top: {type: opencv, index_or_path: '${CAMERA_PORT}', width: 640, height: 480, fps: 30}   }' \
  --display_data=true \
  --dataset.repo_id=yoshikokulala/eval_${JOB_NAME} \
  --dataset.single_task="${JOB_NAME}" \
 --dataset.num_episodes=10 \
 --dataset.episode_time_s=20 \
  --dataset.reset_time_s=10 \
 --dataset.push_to_hub=false \
 --policy.path="/home/amddemo/${JOB_NAME}"


