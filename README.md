# Sparse Sharing Architectures for Multiple Tasks

## 패키지

- pytorch == 1.12.0 
- fastNLP == 0.5.0
- conda == 12.0

## 데이터 준비 - 모든 데이터는 data folder 안에 있음
[데이터 준비](https://nlp.stanford.edu/projects/glove/)
이 링크에서 glove.68.100d.txt파일을 받아야할 것
```shell script
python prepare-data.py \
  --type conll03 \
  --pos /path/to/pos \
  --chunk /path/to/chunk \
  --ner /path/to/ner
```

## 학습

- `single`: 태스크 별 학습 실행
- `mtl`: Multitask Learning 실행

#### Single task pruning

각각의 Task 별 mask 생성
```shell script
bash run_conll03.sh single
```
체크포인트 이용
```shell script
bash run_conll03.sh single /path/to/mtl-checkpoints
```

`./exp/conll03/single/cp/`에 mask 생성
`[#pruning]_[nonzero param percent].th` 꼴로 저장됨
`prepare-masks.sh`에 있는 값을 조정하여 필요한 마스크를 선택할 수 있음

이후 마스크를 준비하는 단계
```shell script
bash prepare-masks.sh conll03
```

#### MTL training

MTL 수행
```shell script
bash run_conll03.sh mtl
```

## 해당 소스코드의 깃헙 주소소
[original](https://github.com/choosewhatulike/sparse-sharing)
