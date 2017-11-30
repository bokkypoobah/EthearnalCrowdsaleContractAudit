#!/bin/sh

cat ../zeppelin-contracts/ownership/Ownable.sol \
    ../../contracts/MultiOwnable.sol \
    ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/math/SafeMath.sol \
    ../../contracts/Treasury.sol \
    ../../contracts/VotingProxy.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/Ballot.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/LockableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    > /tmp/tmp.txt

diff -W 180 -y ../../flat/VotingProxy_flat.sol /tmp/tmp.txt > 06_diff.txt

cat 06_diff.txt
