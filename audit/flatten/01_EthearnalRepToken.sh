#!/bin/sh

cat ../zeppelin-contracts/math/SafeMath.sol \
    ../zeppelin-contracts/ownership/Ownable.sol \
    ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../../contracts/LockableToken.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    > /tmp/tmp.txt

diff -y ../../flat/EthearnalRepToken_flat.sol /tmp/tmp.txt > 01_diff.txt

cat 01_diff.txt
