#!/bin/sh

cat ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/ownership/Ownable.sol \
    ../zeppelin-contracts/math/SafeMath.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../../contracts/LockableToken.sol \
    ../../contracts/VotingProxy.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/Ballot.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    ../../contracts/MultiOwnable.sol \
    ../../contracts/Treasury.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    > /tmp/tmp.txt

diff -y ../../flat/IncreaseWithdrawalBallot_flat.sol /tmp/tmp.txt > 03_diff.txt

cat 03_diff.txt