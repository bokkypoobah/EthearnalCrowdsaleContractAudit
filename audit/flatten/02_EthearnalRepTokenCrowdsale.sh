#!/bin/sh

cat ../zeppelin-contracts/math/SafeMath.sol \
    ../../contracts/MultiOwnable.sol \
    ../../contracts/Treasury.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/Ballot.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/ownership/Ownable.sol \
    ../../contracts/VotingProxy.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../../contracts/LockableToken.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    > /tmp/tmp.txt

diff -y ../../flat/EthearnalRepTokenCrowdsale_flat.sol /tmp/tmp.txt > 02_diff.txt

cat 02_diff.txt
