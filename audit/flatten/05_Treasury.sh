-W 180 #!/bin/sh

cat ../zeppelin-contracts/math/SafeMath.sol \
    ../zeppelin-contracts/ownership/Ownable.sol \
    ../../contracts/VotingProxy.sol \
    ../../contracts/MultiOwnable.sol \
    ../../contracts/Treasury.sol \
    ../../contracts/EthearnalRepTokenCrowdsale.sol \
    ../../contracts/IBallot.sol \
    ../../contracts/Ballot.sol \
    ../../contracts/RefundInvestorsBallot.sol \
    ../zeppelin-contracts/token/ERC20Basic.sol \
    ../zeppelin-contracts/token/ERC20.sol \
    ../zeppelin-contracts/token/BasicToken.sol \
    ../zeppelin-contracts/token/StandardToken.sol \
    ../zeppelin-contracts/token/MintableToken.sol \
    ../../contracts/LockableToken.sol \
    ../../contracts/EthearnalRepToken.sol \
    > /tmp/tmp.txt

diff -W 180 -y ../../flat/Treasury_flat.sol /tmp/tmp.txt > 05_diff.txt

cat 05_diff.txt