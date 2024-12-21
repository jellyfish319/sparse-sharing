MODE=$1
INIT_WEIGHTS=$2
NAME=exp1
INIT_MASKS=exp/conll03/single/cp/1/16_15.85.th  # 마스크 파일 추가

DIR=exp/conll03
MASK=$DIR/mtl/mask
DATA=data/conll03.pkl

if [ "$MODE" = "single" ]; then
  args="  --data_path $DATA
          --seed 2019
          --arch cnn-lstm
          --pruning_iter 20
          --final_rate 0.1
          --epochs 100
          --optim \"sgd(lr=0.1, momentum=0.9)\"
          --hidden_size 200
          --n_layer 2
          --dropout 0.5
          --batch_size 10
          --save_dir $DIR/single
          "
  # --init_weights
  if [ -n "$INIT_WEIGHTS" ]; then
      args=$args" --init_weights $INIT_WEIGHTS"
  fi

  cmd1="CUDA_VISIBLE_DEVICES=0 python train_single.py
      $args
      --task_id 1
      --exp_name 1
      --init_masks $INIT_MASKS
      "
  echo $cmd1 && eval $cmd1

else
  echo "please choose single or mtl, not: $MODE"
fi