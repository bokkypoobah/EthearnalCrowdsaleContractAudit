#!/bin/sh

cat ../zeppelin-contracts/token/ERC20Basic.sol \
    ../../contracts/MultiOwnable.sol \
    ../zeppelin-contracts/math/SafeMath.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/ownership/Ownable.sol \
    ../../contracts/VotingProxy.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../../contracts/LockableToken.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    ../../contracts/Ballot.sol \
    ../../contracts/Treasury.sol \
    > /tmp/tmp.txt

diff -y ../../flat/Treasury_flat.sol /tmp/tmp.txt > 05_diff.txt

cat 05_diff.txt