# Stratified Feature Sampling for SemiSupervised Ensemble-Clustering


## Requirements

The code was implemented using Matlab. Matlab 2016 and later versions are recommended.

## Datasets

The repository contains datasets as following:

```
AustralianCredit, Biodeg, brain, CNAE-9, colon, Iris, ORL-32x32, Protein, TwoLeadECG, Yale-32x32
```

## Experiments

To run the code, please use Matlab to open **code** folder, then execute following instruction:

```bash
parallel_evaluation([1,2,3,4,5,6,7,8,9,10])
```

Note: [1,2,3,4,5,6,7,8,9,10] means to run code in all datasets. 

The results are saved as **result.csv**.

More details can be seen in **parallel_evaluation.m**.

## Bibtex

```
@article{tian2019stratified,
  title={Stratified feature sampling for semi-supervised ensemble clustering},
  author={Tian, Jialin and Ren, Yazhou and Cheng, Xiang},
  journal={IEEE Access},
  volume={7},
  pages={128669--128675},
  year={2019},
  publisher={IEEE}
}
```

