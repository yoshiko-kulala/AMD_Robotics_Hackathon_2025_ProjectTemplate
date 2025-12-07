#!/bin/bash

if [ $# -le 5 ]; then
    echo "Usage: $0 <JOB_NAME> <ROBOT_LEFT_PORT> <ROBOT_RIGHT_PORT> <CAMERA_FRONT_PORT> <CAMERA_TOP_PORT> <MODEL_DIR>" >&2
    exit 1
fi

JOB_NAME=$1
ROBOT_LEFT_PORT=$2
ROBOT_RIGHT_PORT=$3
CAMERA_FRONT_PORT=$4
CAMERA_TOP_PORT=$5
MODEL_DIR=$6


# rm -rf /home/amddemo/.cache/huggingface/lerobot/yoshikokulala/eval*

sudo chmod 777 /dev/ttyACM*
sudo chmod 777 /dev/video*

cd ${MODEL_DIR}
git lfs install
git lfs pull

lerobot-record    --robot.type=bi_so100_follower \
 --robot.left_arm_port=${ROBOT_LEFT_PORT} \
 --robot.right_arm_port=${ROBOT_RIGHT_PORT} \
 --robot.id=my_awesome_follower_arm_bi \
 --robot.cameras='{ front: { "type": "opencv", "index_or_path": '${CAMERA_FRONT_PORT}', "width": 640, "height": 480, "fps": 30 }, top: {type: opencv, index_or_path: '${CAMERA_TOP_PORT}', width: 640, height: 480, fps: 30}   }' \
  --display_data=true \
  --dataset.repo_id=yoshikokulala/eval_${JOB_NAME} \
  --dataset.single_task="${JOB_NAME}" \
 --dataset.num_episodes=20 \
 --dataset.episode_time_s=120 \
  --dataset.reset_time_s=20 \
 --dataset.push_to_hub=false \
 --policy.path="${MODEL_DIR}"
