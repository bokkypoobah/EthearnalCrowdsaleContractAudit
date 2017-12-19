# Ethearnal Crowdsale Contract Audit

Status: Work in progress, waiting for developer's updates

## Summary

Commits
[d60e2fc](https://github.com/Ethearnal/SmartContracts/commit/d60e2fca5e5e0a48f37be8170f08773b5c0d99d4) and
[323eb08](https://github.com/Ethearnal/SmartContracts/commit/323eb0842cb701bbf516473b6129315745550757)

## Table Of Contents

<br />

<hr />

## Recommendations

* **LOW IMPORTANCE** In *IBallot*, the `FinishBallot` event is only logged if the voting results in a Yes vote. No event
  is logged if the voting results in a No vote
  * [x] Fixed in [323eb08](https://github.com/Ethearnal/SmartContracts/commit/323eb0842cb701bbf516473b6129315745550757)
* **LOW IMPORTANCE** In *IBallot*, `getQuorumPercent()` is defined with an empty body. It seems that this function should be
  overriden in the implementation of this function. Consider defining this function as an interface, e.g.,
  `function getQuorumPercent() public constant returns (uint256);`
  * [x] Fixed in [323eb08](https://github.com/Ethearnal/SmartContracts/commit/323eb0842cb701bbf516473b6129315745550757)
* **LOW IMPORTANCE** In *EthearnalRepToken*, `decimals` should be defined as `uint8` instead of `uint256` as recommended in the
  recently finalised [ERC20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
  * [x] Fixed in [323eb08](https://github.com/Ethearnal/SmartContracts/commit/323eb0842cb701bbf516473b6129315745550757)
* **LOW IMPORTANCE** In *MultiOwnable*, `getOwners()` should be declared constant
* **LOW IMPORTANCE** In *Treasury*, consider making `teamWallet` public
* **MEDIUM IMPORTANCE** The variable `IBallot.initialQuorumPercent` is shadowed by `Ballot.initialQuorumPercent`. See
  [Oracles PoA Network Consensus Contracts Audit - Recommendation](https://github.com/bokkypoobah/OraclesPoANetworkConsensusContractsAudit/tree/master/audit#recommendations)
  for a similar issue and [Oracles PoA Network Consensus Contracts Audit - Example To Demonstrate The Shadowing Of Variables](https://github.com/bokkypoobah/OraclesPoANetworkConsensusContractsAudit/tree/master/audit#example-to-demonstrate-the-shadowing-of-variables)
  for an example. Same with `RefundInvestorsBallot.initialQuorumPercent`
* **MEDIUM IMPORTANCE** The percentage of refund an investor can withdraw in *Treasury* depends on the ETH balance of the
  *Treasury* contract at the time of withdrawal. The first refund withdrawal will get the highest percentage refund and
  the last withdrawal will get the lowest percentage refund
* **LOW IMPORTANCE** In *MultiOwnable*, consider making `owners` and `multiOwnableCreator` public
* **LOW IMPORTANCE** The tokens generated for the team is 33% of the crowdsale raised tokens. When worked out on the total tokens
  the team tokens amount to 24.98% of the total tokens. Please confirm this is the expected percentage
  * [x] Dec 20 2017 - Team confirmed that the expected team token percentage is 25%
* **LOW IMPORTANCE** `MultiOwnable.setupOwners(...)` should be marked `public`
* **LOW IMPORTANCE** The `address` parameter in `Treasury.RefundedInvestor(...)`, `EthearnalRepTokenCrowdsale.ChangeReturn(...)` and 
  `TokenPurchase.ChangeReturn(...)` should be marked `indexed`. There are a few more events in the other .sol files as well
* **VERY LOW IMPORTANCE** The second `require(weiToBuy > 0);` statement in `EthearnalRepTokenCrowdsale.buyTokens()` is redundant as
  the first `require(weiToBuy > 0);` is followed by a `min(weiToBuy, ...)` statement

<br />

<hr />

## Testing

Details of the testing environment can be found in [test](test).

The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [x] Deploy token contract
* [x] Deploy treasury contract
* [x] Deploy votingProxy contract
* [x] Link treasury contract with the token and votingProxy contracts
* [x] Deploy crowdsale contract
* [x] Link treasury contract with the crowdsale contract
* [x] Transfer token contract ownership to the crowdsale contract
* [x] Link the crowdsale contract to the token contract
* [x] Send contributions to the cap
* [x] Finalise the crowdsale
* [x] Withdraw team funds (10%)
* [x] Vote to refund
* [x] Withdraw refunds

<br />

<hr />

## Code Review

### Original Source Files

* [x] [code-review/IBallot.md](code-review/IBallot.md)
  * [x] contract IBallot
* [x] [code-review/Ballot.md](code-review/Ballot.md)
  * [x] contract Ballot is IBallot
    * [ ] Issue - `Ballot.initialQuorumPercent` shadows `IBallot.initialQuorumPercent`
* [x] [code-review/EthearnalRepToken.md](code-review/EthearnalRepToken.md)
  * [x] contract EthearnalRepToken is MintableToken, LockableToken
* [x] [code-review/EthearnalRepTokenCrowdsale.md](code-review/EthearnalRepTokenCrowdsale.md)
  * [x] contract EthearnalRepTokenCrowdsale is MultiOwnable
* [x] [code-review/LockableToken.md](code-review/LockableToken.md)
  * [x] contract LockableToken is StandardToken, Ownable
* [x] [code-review/MultiOwnable.md](code-review/MultiOwnable.md)
  * [x] contract MultiOwnable
* [x] [code-review/RefundInvestorsBallot.md](code-review/RefundInvestorsBallot.md)
  * [x] contract RefundInvestorsBallot is IBallot
    * NOTE A month is 5 weeks
* [x] [code-review/Treasury.md](code-review/Treasury.md)
  * [x] contract Treasury is MultiOwnable
    * [ ] Issue - Refund percentage depends on the current balance
* [x] [code-review/VotingProxy.md](code-review/VotingProxy.md)
  * [x] contract VotingProxy is Ownable

<br />

# OpenZeppelin Included Files

From https://github.com/OpenZeppelin/zeppelin-solidity/commit/725ed40a57e8973b3ae6e2f39f9c887d0056ca39

* [x] [code-review-zeppelin/math/SafeMath.md](code-review-zeppelin/math/SafeMath.md)
  * [x] library SafeMath
* [x] [code-review-zeppelin/ownership/Ownable.md](code-review-zeppelin/ownership/Ownable.md)
  * [x] contract Ownable
* [x] [code-review-zeppelin/token/BasicToken.md](code-review-zeppelin/token/BasicToken.md)
  * [x] contract BasicToken is ERC20Basic
* [x] [code-review-zeppelin/token/ERC20.md](code-review-zeppelin/token/ERC20.md)
  * [x] contract ERC20 is ERC20Basic
* [x] [code-review-zeppelin/token/ERC20Basic.md](code-review-zeppelin/token/ERC20Basic.md)
  * [x] contract ERC20Basic
* [x] [code-review-zeppelin/token/StandardToken.md](code-review-zeppelin/token/StandardToken.md)
  * [x] contract StandardToken is ERC20, BasicToken
* [x] [code-review-zeppelin/token/MintableToken.md](code-review-zeppelin/token/MintableToken.md)
  * [x] contract MintableToken is StandardToken, Ownable

<br />

Excluded as this is used for testing:

* [../contracts/Migrations.sol](../contracts/Migrations.sol)

<br />

<br />

