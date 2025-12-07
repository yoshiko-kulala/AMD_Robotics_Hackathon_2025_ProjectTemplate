<div align="center">

<h1>AMD_Open_Robotics_Hackathon_2025_PackingMan</h1>

<h3>Dual-Arm Packing with Imitation Learning on AMD Instinct™ GPUs</h3>

**Team Nyap IV**  
Masakazu Sueyoshi · Hiroki Kyono  · Kosuke Tokuda

<br>

<sup>AMD Open Robotics Hackathon 2025</sup>

<br><br>

<!-- 🔗 ここだけ各自のものに差し替えてください -->
<a href="https://huggingface.co/datasets/<HF_USERNAME>/<MISSION1_DATASET_ID>">
  <img src="https://img.shields.io/badge/HuggingFace-Mission1_Dataset-orange" alt="Mission1 Dataset">
</a>
<a href="https://huggingface.co/datasets/<HF_USERNAME>/<MISSION2_DATASET_ID>">
  <img src="https://img.shields.io/badge/HuggingFace-Mission2_Dataset-orange" alt="Mission2 Dataset">
</a>
<a href="https://huggingface.co/<HF_USERNAME>/<MISSION1_MODEL_ID>">
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
# 📝 Summary

**PackingMan is an automatic packing system that targets the “last human step” in modern e-commerce logistics: putting items into cardboard boxes.**

### Background

### Problem

While companies like Amazon already automate storage, transport, labeling, and sorting, a large portion of actual box packing is still performed by human workers. PackingMan explores how far we can push imitation learning–based manipulation to close this gap.
In this project, we use a real robot arm and LeRobot to record human demonstrations of simple packing tasks (such as placing objects into a box and closing the lid), train a policy on an AMD GPU, and then deploy the learned policy back to the real robot. The result is a compact “robot packer” prototype that can repeatedly execute a packing motion learned from humans, demonstrating a practical path toward scalable, flexible packing automation for small to mid-scale warehouses.


---

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
git clone https://github.com/<YOUR_GITHUB_ACCOUNT>/AMD_Robotics_Hackathon_2025_PackingMan.git
cd AMD_Robotics_Hackathon_2025_PackingMan
```

---

## 🧪 Mission 1 – Unified Task

### 1-1. Data Collection

```bash
lerobot-record \
  --robot.type=so101_follower \
  --robot.port=/dev/ttyACM1 \
  --robot.cameras="{ front: {type: opencv, index_or_path: 0, width: 1280, height: 720, fps: 10} }" \
  --robot.id=mission1_follower_arm \
  --teleop.type=so101_leader \
  --teleop.port=/dev/ttyACM0 \
  --teleop.id=mission1_leader_arm \
  --dataset.repo_id=<HF_USERNAME>/<MISSION1_DATASET_ID> \
  --dataset.single_task='Mission1 Unified Task' \
  --display_data=false
```

This will:

- Stream images from the `front` camera.
- Use the leader arm as teleoperation input.
- Record demonstrations into a Hugging Face dataset `<HF_USERNAME>/<MISSION1_DATASET_ID>`.

---

### 1-2. Training

```bash
lerobot-train \
  --dataset.repo_id=<HF_USERNAME>/<MISSION1_DATASET_ID> \
  --batch_size=128 \
  --steps=5000 \
  --output_dir=outputs/train/mission1 \
  --job_name=mission1_packingman \
  --policy.type=act \
  --policy.device=cuda \
  --policy.push_to_hub=true \
  --policy.repo_id=<HF_USERNAME>/<MISSION1_MODEL_ID> \
  --wandb.enable=true
```

- `batch_size` and `steps` are set for MI300X-class GPUs.  
  You can increase either if you have more data or want longer training.
- The final trained policy is uploaded to **Hugging Face** under `<MISSION1_MODEL_ID>`.

Copy the corresponding W&B `run-XXXX` directory into:

```text
mission1/wandb/
```

---

### 1-3. Inference / Evaluation

```bash
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
https://huggingface.co/datasets/<HF_USERNAME>/<MISSION1_DATASET_ID>

Dataset (Mission 2 – PackingMan):
https://huggingface.co/datasets/<HF_USERNAME>/<MISSION2_DATASET_ID>

Model (Mission 1):
https://huggingface.co/<HF_USERNAME>/<MISSION1_MODEL_ID>

Model (Mission 2 – PackingMan):
https://huggingface.co/<HF_USERNAME>/<MISSION2_MODEL_ID>
```


---

# 🙏 Acknowledgement

- This work was conducted as part of **AMD Open Robotics Hackathon 2025**.
- We use:
  - **LeRobot** (Hugging Face) for imitation learning infrastructure.
  - **Hugging Face Hub** for hosting datasets and models.
  - **Weights & Biases** for experiment tracking.
- Special thanks to the organizers and supporting engineers for providing hardware, software templates, and technical guidance.

---

# 📜 License

Please choose and declare a license appropriate for your project (e.g., MIT, Apache-2.0):

```text
MIT License
```

*(必要に応じて他のライセンスに変更してください)*

---
