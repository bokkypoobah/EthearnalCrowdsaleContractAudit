#!/bin/sh

cat ../zeppelin-contracts/token/ERC20Basic.sol \
    ../../contracts/MultiOwnable.sol \
    ../zeppelin-contracts/math/SafeMath.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    ../zeppelin-contracts/ownership/Ownable.sol \
    ../../contracts/VotingProxy.sol \
    ../../contracts/Treasury.sol \
    ../../contracts/Ballot.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/LockableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    > /tmp/tmp.txt

diff -W 180 -y ../../flat/EthearnalRepTokenCrowdsale_flat.sol /tmp/tmp.txt > 02_diff.txt

cat 02_diff.txt
