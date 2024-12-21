TASK=$1
MASK_LIST=(
  10
  10
  10
)

SINGLE_DIR=exp/conll03$TASK/single
MTL_DIR=exp/conll03$TASK/mtl
len=${#MASK_LIST[@]}

mkdir -p $MTL_DIR/mask_dense
for((i=0; i<len; i++)) do
    mask_id=${MASK_LIST[$i]}
    cp -v $SINGLE_DIR/cp/$i/${mask_id}_* $MTL_DIR/mask_dense/${i}_$mask_id
done
cp -v $SINGLE_DIR/cp/0/init_weights.th $MTL_DIR/mask_dense/init_weights