# Ethearnal Crowdsale Contract Audit

## Summary

Ethernal intends to run a crowdsale in the near future.

Bok Consulting Pty Ltd was commissioned to perform an audit on the Ethereum smart contracts for Ethearnal's crowdsale.

This audit has been conducted on Ethearnal's source code in commits
[d60e2fc](https://github.com/Ethearnal/SmartContracts/commit/d60e2fca5e5e0a48f37be8170f08773b5c0d99d4),
[323eb08](https://github.com/Ethearnal/SmartContracts/commit/323eb0842cb701bbf516473b6129315745550757) and
[d1bf698](https://github.com/Ethearnal/SmartContracts/commit/d1bf6983695fffef1e6bc1b2fa821e085bdda753).

No potential vulnerabilities have been identified in the crowdsale, token, treasury and voting contracts.

<br />

<hr />

## Table Of Contents

* [Summary](#summary)
* [Recommendations](#recommendations)
* [Potential Vulnerabilities](#potential-vulnerabilities)
* [Scope](#scope)
* [Limitations](#limitations)
* [Due Diligence](#due-diligence)
* [Risks](#risks)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

The following recommendations have been addressed:

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
* **MEDIUM IMPORTANCE** The variable `IBallot.initialQuorumPercent` is shadowed by `Ballot.initialQuorumPercent`. See
  [Oracles PoA Network Consensus Contracts Audit - Recommendation](https://github.com/bokkypoobah/OraclesPoANetworkConsensusContractsAudit/tree/master/audit#recommendations)
  for a similar issue and [Oracles PoA Network Consensus Contracts Audit - Example To Demonstrate The Shadowing Of Variables](https://github.com/bokkypoobah/OraclesPoANetworkConsensusContractsAudit/tree/master/audit#example-to-demonstrate-the-shadowing-of-variables)
  for an example. Same with `RefundInvestorsBallot.initialQuorumPercent`
  * [x] Fixed in [d1bf698](https://github.com/Ethearnal/SmartContracts/commit/d1bf6983695fffef1e6bc1b2fa821e085bdda753)
* **MEDIUM IMPORTANCE** The percentage of refund an investor can withdraw in *Treasury* depends on the ETH balance of the
  *Treasury* contract at the time of withdrawal. The first refund withdrawal will get the highest percentage refund and
  the last withdrawal will get the lowest percentage refund
  * [x] Fixed in [d1bf698](https://github.com/Ethearnal/SmartContracts/commit/d1bf6983695fffef1e6bc1b2fa821e085bdda753)
* **LOW IMPORTANCE** In *MultiOwnable*, consider making `owners` and `multiOwnableCreator` public
  * [x] `multiOwnableCreator` made public, not `owners` in [d1bf698](https://github.com/Ethearnal/SmartContracts/commit/d1bf6983695fffef1e6bc1b2fa821e085bdda753)
* **LOW IMPORTANCE** The tokens generated for the team is 33% of the crowdsale raised tokens. When worked out on the total tokens
  the team tokens amount to 24.98% of the total tokens. Please confirm this is the expected percentage
  * [x] Dec 20 2017 - Team confirmed that the expected team token percentage is 25%
* **LOW IMPORTANCE** `MultiOwnable.setupOwners(...)` should be marked `public`
  * [x] Fixed in [d1bf698](https://github.com/Ethearnal/SmartContracts/commit/d1bf6983695fffef1e6bc1b2fa821e085bdda753)
* **LOW IMPORTANCE** The `address` parameter in `Treasury.RefundedInvestor(...)`, `EthearnalRepTokenCrowdsale.ChangeReturn(...)` and 
  `TokenPurchase.ChangeReturn(...)` should be marked `indexed`. There are a few more events in the other .sol files as well
  * [x] Fixed in [d1bf698](https://github.com/Ethearnal/SmartContracts/commit/d1bf6983695fffef1e6bc1b2fa821e085bdda753)
* **VERY LOW IMPORTANCE** The second `require(weiToBuy > 0);` statement in `EthearnalRepTokenCrowdsale.buyTokens()` is redundant as
  the first `require(weiToBuy > 0);` is followed by a `min(weiToBuy, ...)` statement
  * [x] Developer pointed out that the second statement is not redundant

And the following recommendations are of low importance:

* **LOW IMPORTANCE** In *MultiOwnable*, `getOwners()` should be declared constant
* **LOW IMPORTANCE** In *Treasury*, consider making `teamWallet` public

<br />

<hr />

## Potential Vulnerabilities

No potential vulnerabilities have been identified in the crowdsale, token, treasury and voting contracts.

<br />

<hr />

## Scope

This audit is into the technical aspects of the crowdsale contracts. The primary aim of this audit is to ensure that funds
contributed to these contracts are not easily attacked or stolen by third parties. The secondary aim of this audit is that
ensure the coded algorithms work as expected. This audit does not guarantee that that the code is bugfree, but intends to
highlight any areas of weaknesses.

<br />

<hr />

## Limitations

This audit makes no statements or warranties about the viability of the Ethearnal's business proposition, the individuals
involved in this business or the regulatory regime for the business model.

<br />

<hr />

## Due Diligence

As always, potential participants in any crowdsale are encouraged to perform their due diligence on the business proposition
before funding any crowdsales.

Potential participants are also encouraged to only send their funds to the official crowdsale Ethereum address, published on
the crowdsale beneficiary's official communication channel.

Scammers have been publishing phishing address in the forums, twitter and other communication channels, and some go as far as
duplicating crowdsale websites. Potential participants should NOT just click on any links received through these messages.
Scammers have also hacked the crowdsale website to replace the crowdsale contract address with their scam address.
 
Potential participants should also confirm that the verified source code on EtherScan.io for the published crowdsale address
matches the audited source code, and that the deployment parameters are correctly set, including the constant parameters.

<br />

<hr />

## Risks

* ETH contributions to the crowdsale are transferred to the *Treasury* contract and are held there until released to the
  crowdsale project on a schedule. In non-refund mode, only the crowdsale contract owner(s) can withdraw the ETH. In
  refund mode, any contributor is able to withdraw their refunds by calling the `refundInvestor(...)` function
  * [x] Fixed issue where the refund percentage depends on the current balance

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

* [x] [code-review/Ballot.md](code-review/Ballot.md)
  * [x] contract Ballot
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
    * [x] Fixed issue where the refund percentage depends on the current balance
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

(c) BokkyPooBah / Bok Consulting Pty Ltd for Ethearnal - Dec 27 2017. The MIT Licence.