#!/bin/sh

cat ../../contracts/MultiOwnable.sol \
    ../zeppelin-contracts/math/SafeMath.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../../contracts/Treasury.sol \
    ../../contracts/Ballot.sol \
    ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../zeppelin-contracts/ownership/Ownable.sol \
    ../../contracts/VotingProxy.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/LockableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    > /tmp/tmp.txt

diff -y ../../flat/VotingProxy_flat.sol /tmp/tmp.txt > 06_diff.txt

cat 06_diff.txt
