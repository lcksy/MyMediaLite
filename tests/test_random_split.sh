#!/bin/bash -e

PROGRAM="mono --debug RatingPrediction.exe"
DATA_DIR=../../../../../data/ml-100k
LANG=C

cd src/Programs/RatingPrediction/bin/Debug/

echo "MyMediaLite random splitting test script"
echo "This will take about 1 minute ..."

echo
echo "rating predictors"
echo "-----------------"

echo $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=GlobalAverage --data-dir=$DATA_DIR --random-seed=1 --prediction-file=pred1
     $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=GlobalAverage --data-dir=$DATA_DIR --random-seed=1 --prediction-file=pred1

echo $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=MatrixFactorization --data-dir=$DATA_DIR --random-seed=1 --prediction-file=pred2
     $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=MatrixFactorization --data-dir=$DATA_DIR --random-seed=1 --prediction-file=pred2

cut -f 1,2 pred1 > pred1.cut
cut -f 1,2 pred2 > pred2.cut

diff pred1.cut pred2.cut

rm pred1 pred2 pred1.cut pred2.cut

echo
echo "item recommenders"
echo "-----------------"

PROGRAM="mono --debug ItemRecommendation.exe"

cd ../../../ItemRecommendation/bin/Debug/

echo $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=MostPopular --data-dir=$DATA_DIR --random-seed=1 > log1
     $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=MostPopular --data-dir=$DATA_DIR --random-seed=1 > log1

echo $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=WRMF --data-dir=$DATA_DIR --random-seed=1 > log2
     $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=WRMF --data-dir=$DATA_DIR --random-seed=1 > log2

grep "test data" log1 > log1.grep
grep "test data" log2 > log2.grep

diff log1.grep log2.grep

rm log1 log2 log1.grep log2.grep

echo $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=MostPopular --data-dir=$DATA_DIR --random-seed=1 --num-test-users=100 > log1
     $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=MostPopular --data-dir=$DATA_DIR --random-seed=1 --num-test-users=100 > log1

echo $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=WRMF --data-dir=$DATA_DIR --random-seed=1 --num-test-users=100 > log2
     $PROGRAM --training-file=u.data --test-ratio=0.1 --recommender=WRMF --data-dir=$DATA_DIR --random-seed=1 --num-test-users=100 > log2

grep "100 users" log1 > log1.grep
grep "100 users" log2 > log2.grep

diff log1.grep log2.grep

rm log1 log2 log1.grep log2.grep


cd ../../../../..
