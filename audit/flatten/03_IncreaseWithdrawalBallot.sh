#!/bin/sh

cat ../zeppelin-contracts/math/SafeMath.sol \
    ../../contracts/MultiOwnable.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    ../../contracts/Treasury.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../zeppelin-contracts/ownership/Ownable.sol \
    ../../contracts/VotingProxy.sol \
    ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../../contracts/LockableToken.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/Ballot.sol \
    ../../contracts/EthearnalRepToken.sol \
    > /tmp/tmp.txt

diff -W 180 -y ../../flat/IncreaseWithdrawalBallot_flat.sol /tmp/tmp.txt > 03_diff.txt

cat 03_diff.txt