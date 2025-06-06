set -x
HOME="YOUR HOME DIR"
export VLLM_ATTENTION_BACKEND=XFORMERS
train_path=$HOME/data/numia_math/train.parquet
test_path=$HOME/data/numia_math/test.parquet

train_files="['$train_path']"
test_files="['$test_path']"

python3 -m verl.trainer.main_ppo \
    data.train_files="$train_files" \
    data.val_files="$test_files" \
    data.train_batch_size=1024 \
    data.val_batch_size=500 \
    data.max_prompt_length=1000 \
    data.max_response_length=3800 \
    actor_rollout_ref.model.path=1231czx/qwen_self_corr_warmup2_clean_ep1 \
    actor_rollout_ref.actor.optim.lr=1e-6 \
    actor_rollout_ref.model.use_remove_padding=True \
    actor_rollout_ref.actor.ppo_mini_batch_size=256 \
    actor_rollout_ref.actor.ppo_micro_batch_size_per_gpu=16 \
    actor_rollout_ref.model.enable_gradient_checkpointing=True \
    actor_rollout_ref.actor.fsdp_config.param_offload=False \
    actor_rollout_ref.actor.fsdp_config.optimizer_offload=False \
    actor_rollout_ref.rollout.log_prob_micro_batch_size_per_gpu=32 \
    actor_rollout_ref.rollout.tensor_model_parallel_size=1 \
    actor_rollout_ref.rollout.name=vllm \
    actor_rollout_ref.rollout.gpu_memory_utilization=0.6 \
    actor_rollout_ref.ref.log_prob_micro_batch_size_per_gpu=32 \
    actor_rollout_ref.ref.fsdp_config.param_offload=True \
    critic.optim.lr=1e-5 \
    critic.model.use_remove_padding=True \
    critic.model.path=1231czx/qwen_self_corr_warmup2_clean_ep1 \
    critic.model.enable_gradient_checkpointing=True \
    critic.ppo_micro_batch_size_per_gpu=16 \
    critic.model.fsdp_config.param_offload=False \
    critic.model.fsdp_config.optimizer_offload=False \
    algorithm.kl_ctrl.kl_coef=0.001 \
    trainer.critic_warmup=0 \
    trainer.logger=['wandb'] \
    trainer.project_name='verl' \
    trainer.experiment_name='Qwen2.5-7B-math-format-numia' \
    trainer.n_gpus_per_node=8 \
    trainer.nnodes=1 \
    trainer.save_freq=20 \
    trainer.test_freq=999\
    trainer.total_epochs=2 $@
