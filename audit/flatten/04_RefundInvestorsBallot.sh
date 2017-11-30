#!/bin/sh

cat ../zeppelin-contracts/ownership/Ownable.sol \
    ../zeppelin-contracts/math/SafeMath.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/VotingProxy.sol \
    ../../contracts/Ballot.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../../contracts/LockableToken.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    ../../contracts/MultiOwnable.sol \
    ../../contracts/Treasury.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    > /tmp/tmp.txt

diff -W 180 -y ../../flat/RefundInvestorsBallot_flat.sol /tmp/tmp.txt > 04_diff.txt

cat 04_diff.txt