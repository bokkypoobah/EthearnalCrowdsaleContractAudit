#!/bin/sh

cat ../zeppelin-contracts/ownership/Ownable.sol \
    ../zeppelin-contracts/math/SafeMath.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/Ballot.sol \
    ../../contracts/MultiOwnable.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    ../../contracts/Treasury.sol \
    ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../../contracts/LockableToken.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../../contracts/VotingProxy.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    > /tmp/tmp.txt

diff -y ../../flat/RefundInvestorsBallot_flat.sol /tmp/tmp.txt > 04_diff.txt

cat 04_diff.txt