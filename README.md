<div align="center">

<h1>AMD_Open_Robotics_Hackathon_2025_PackingMan</h1>

<h3>Dual-Arm Packing with Imitation Learning on AMD Instinct™ GPUs</h3>

**Team Nyap IV**  
Masakazu Sueyoshi · Hiroki Kyono  · Kosuke Tokuda

<br>

<sup>AMD Open Robotics Hackathon 2025</sup>

<br><br>

<a href="https://huggingface.co/datasets/yoshikokulala/simple_cola4">
  <img src="https://img.shields.io/badge/HuggingFace-Mission1_Dataset-orange" alt="Mission1 Dataset">
</a>
<a href="https://huggingface.co/datasets/<HF_USERNAME>/<MISSION2_DATASET_ID>">
  <img src="https://img.shields.io/badge/HuggingFace-Mission2_Dataset-orange" alt="Mission2 Dataset">
</a>
<a href="git clone https://huggingface.co/yoshikokulala/simple_cola4">
  <img src="https://img.shields.io/badge/HuggingFace-Mission1_Model-blue" alt="Mission1 Model">
</a>
<a href="https://huggingface.co/<HF_USERNAME>/<MISSION2_MODEL_ID>">
  <img src="https://img.shields.io/badge/HuggingFace-Mission2_Model-blue" alt="Mission2 Model">
</a>

</div>

---

# 🧾 Title
**AMD_RoboticHackathon2025-PackingMan**

---

# 👥 Team

**Team Name:** Nyap IV  

**Members:**

- Masakazu Sueyoshi  
- Kosuke Tokuda  
- Hiroki Kyono  

---
# Mission Description


This project is a robotic system that autonomously performs cardboard box packing, a task that logistics sites still heavily rely on manual labor for, by using imitation learning.

The target task consists of real, practical operations such as:
 - Inserting the workpiece into the box
 - Placing cushioning material
 - Closing the lid
 - Applying packing tape

Each of these is a process that strongly depends on human skill, including:
 - Exception handling
 - Fine adjustments
 - Differences in material properties
 - Handling deformed or non-ideal shapes

By introducing our robot, we can help solve the problem of labor shortage in on-site logistics operations.

## Real-world applications
 - E-commerce logistics warehouses
 - Online shipping / fulfillment processes
 - Factory shipping / packing lines
 - Automation solutions for logistics sites suffering from severe labor shortages
 - As a “skill transfer” system that performs exemplar motions as a reference for human workers

## Concrete mission details
1. A workpiece (either a snack or a cup) is placed at a specific position in the field, and the robot places it into a box.
2. Only when a cup is placed, the robot additionally puts cushioning material into the box.
3. The robot inserts the box lid flap into the slit and closes the box.
4. The robot receives a piece of tape from a person standing in front of it and applies the tape onto the box.

# Creativity
The originality of this work lies in the following points:
 - Integrating multiple tasks with a single imitation learning policy
   - A single policy switches between behaviors such as putting an item into a box, closing the box, and applying tape in order to complete the mission.
 - Using tools
   - By using tools, we broaden the range of tasks the robot can execute.
 - Control using only RGB images
   - The system performs the task using only RGB camera images, without relying on point clouds, CAD models, or rigid body models, thus succeeding with minimal input information.
 - Learning fine contact-rich adjustment motions
   - Inserting the cardboard flap into the slit requires very precise, contact-rich motion. We show that the robot can acquire this behavior through imitation learning.
 - Learning to receive tape from a human
   - The system is designed to execute tasks under the assumption of human–robot collaboration.
   - It can cope with variations in the position and angle of the tape during handover.
 - Switching behavior depending on the workpiece
   - The robot learns selective behavior: When the workpiece is a cup, it places cushioning material together with it. When the workpiece is a snack, it does not place cushioning material.

# Technical Implementations
## Teleoperation / Dataset Capture:

 - Use two arm
 - Use two camera: top and front
 - A human operator performs the real task using a dual-arm teleoperation setup.
 - Recording work divided into individual steps and a series of steps.

We intentionally introduce variations into the data, assuming that such “noisy” data contributes to acquiring robustness:
 - Varying how widely the cardboard box is opened
 - Variations in position, angle, and timing during tape handover
 - Variations in the position and orientation of the workpiece
 - Switching the workpiece between a snack and a cup

[teleoperation video1 link](https://drive.google.com/file/d/1JmgPFNL6MkHbD0EpL2dB57tLXZtd_hem/view?usp=drive_link)

[teleoperation video2 link](https://drive.google.com/file/d/1byd6sLCAH1fsUYkJxQuajqRNR_79s2lb/view?usp=drive_link)

## Training:
To prevent overfitting and underfitting, we adjusted the step number parameter so that the total loss and l1 loss would not become too small.

## Inference:

### Result of sequence operations (the original goal):

Video: inserting the cup and cushioning material into the box and then applying tape
[inference video link](https://drive.google.com/file/d/12RBoRQTYOQR4K_vKIBg7dE6VhmHZ8O2b/view?usp=drive_link)

Video: inserting the snuck into the box and then applying tape
[inference video link](https://drive.google.com/file/d/1JSh6CabghTNvpY4dD-8XheDwHwjyRdHf/view?usp=drive_link)

### Results when training the model on only a subset of tasks:
The results are poor and the video is long, so saved video as 5x speed.

[inference video link](https://drive.google.com/file/d/12RBoRQTYOQR4K_vKIBg7dE6VhmHZ8O2b/view?usp=drive_link)
#### Video: putting a snack into the box and applying tape
[inference video link](https://drive.google.com/file/d/1UUb9FRC8vHp2tcHILT6AVFDTYaBPpZTi/view?usp=drive_link)

#### Video: applying tape only
[inference video link](https://drive.google.com/file/d/1eACJFKnUP5iZNEYRY0kMXcVH_K7o6hfB/view?usp=drive_link)

# Ease of Use

## Task generalization
 - Directly applicable to similar packing and boxing tasks.
 - Sensor requirements
 　　- Requires only an RGB camera; hardware dependency is extremely low.
 - Robustness to variation in target objects
   - Can handle differences in shape and errors in object position and orientation.
 - Interaction
   - Generalizes to tasks that include handover with humans and the use of tools.
 - Engineering cost
   - No rule-based logic or optimization is required; the system is composed purely of imitation learning.
 - Operation interface
   - Only simple “Start” and “Stop” commands are needed.
   - The system configuration is kept minimal with actual on-site deployment in mind.

# 🚀 How to Reproduce

Below is a minimal, end-to-end workflow.  
You can literally copy–paste this section and only change IDs / ports / camera configs as needed.

## 0. Environment Setup

We use Python 3.11, LeRobot, and AMD Instinct™ MI300X (CUDA-compatible interface).

```bash
# Create environment (example; adjust to your preference)
conda create -n amd_packingman python=3.11
conda activate amd_packingman

# Install LeRobot with π0 / ACT support
git clone https://github.com/huggingface/lerobot.git
cd lerobot
git checkout -b v0.4.1 v0.4.1
pip install -e ".[pi]"   # includes π0 dependencies

cd ..
```

You can then place this repository anywhere, e.g.:

```bash
git clone https://github.com/yoshiko-kulala/AMD_Robotics_Hackathon_2025_PackingMan.git
cd AMD_Robotics_Hackathon_2025_PackingMan
```

---

## 🧪 Mission 1 – Unified Task

### 1-1 Create Environment
This task needs devices below,
 - one SO-101
 - one Camera

Arrange your devices as shown in the image.

![alt text](images/mission1_arrangement.png)

The camera image should look like this:

![alt text](images/mission1_camera_top.png)


### 1-2. Inference / Evaluation

```bash
cd AMD_Robotics_Hackathon_2025_PackingMan

lerobot-act \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 1280, height: 720, fps: 10} }" \
  --robot.id=mission1_follower_arm \
  --policy.repo_id=<HF_USERNAME>/<MISSION1_MODEL_ID> \
  --policy.device=cuda
```

This will load the trained Mission 1 policy from Hugging Face and execute it on the real robot.

---

## 📦 Mission 2 – PackingMan (Custom Task)

PackingMan focuses on **picking multiple objects and packing them into a box**, potentially with **dual-arm coordination**.

### 2-1. Data Collection (Teleoperation)

```bash
lerobot-record \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.cameras="{ front: {type: opencv, index_or_path: 4, width: 1280, height: 720, fps: 10} }" \
  --robot.id=packingman_follower_arm \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM0 \
  --teleop.id=packingman_leader_arm \
  --dataset.repo_id=<HF_USERNAME>/<MISSION2_DATASET_ID> \
  --dataset.single_task='PackingMan – Packing Objects into Box' \
  --display_data=false
```

If you extend to **dual-arm control**, you can follow the hackathon’s dual-arm teleop configuration (left/right leader and follower arms) and log a combined state/action vector in the dataset.

---

### 2-2. Training on AMD Instinct™ GPU

```bash
lerobot-train \
  --dataset.repo_id=<HF_USERNAME>/<MISSION2_DATASET_ID> \
  --batch_size=128 \
  --steps=5000 \
  --output_dir=outputs/train/packingman \
  --job_name=packingman_dualarm \
  --policy.type=act \
  --policy.device=cuda \
  --policy.push_to_hub=true \
  --policy.repo_id=<HF_USERNAME>/<MISSION2_MODEL_ID> \
  --wandb.enable=true
```

- For dual-arm policies, the **action dimension** corresponds to the concatenation of both arms’ joint commands.
- Since MI300X has plenty of memory, you can experiment with **larger batch sizes** or **more steps** if time allows.

Copy the W&B `run-XXXX` directory of the **last successful training** into:

```text
mission2/wandb/
```

---

### 2-3. Running PackingMan Policy

```bash
lerobot-act \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.cameras="{ front: {type: opencv, index_or_path: 4, width: 1280, height: 720, fps: 10} }" \
  --robot.id=packingman_follower_arm \
  --policy.repo_id=<HF_USERNAME>/<MISSION2_MODEL_ID> \
  --policy.device=cuda
```

This command:

- Loads the trained PackingMan policy from Hugging Face.
- Runs it on your follower arm with the same camera setup used during recording.
- Allows you to reproduce the **final demo** shown during the hackathon.

---

# 🌐 Delivery URLs

Please fill in these URLs when everything is uploaded (structureはそのままコピペでOKです):

```text
Dataset (Mission 1):
https://huggingface.co/datasets/yoshikokulala/simple_cola4

Dataset (Mission 2 – PackingMan):
https://huggingface.co/datasets/yoshikokulala/hakoccoacup2

Model (Mission 1):
https://huggingface.co/yoshikokulala/simple_cola4

Model (Mission 2 – PackingMan):
https://huggingface.co/yoshikokulala/hakoccoacup2_ft
```


---

# 🙏 Acknowledgement

- This work was conducted as part of **AMD Open Robotics Hackathon 2025**.
- We use:
  - **LeRobot** (Hugging Face) for imitation learning infrastructure.
  - **Hugging Face Hub** for hosting datasets and models.
  - **Weights & Biases** for experiment tracking.
- Special thanks to the organizers and supporting engineers for providing hardware, software templates, and technical guidance.


