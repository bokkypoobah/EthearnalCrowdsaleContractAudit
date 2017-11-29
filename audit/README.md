# Ethearnal Crowdsale Contract Audit

Status: Work in progress

## Summary


## Table Of Contents

<br />

<hr />

## Code Review

### Original Source Files

* [ ] [code-review/IBallot.md](code-review/IBallot.md)
  * [ ] contract IBallot
* [ ] [code-review/Ballot.md](code-review/Ballot.md)
  * [ ] contract Ballot is IBallot
* [ ] [code-review/EthearnalRepToken.md](code-review/EthearnalRepToken.md)
  * [ ] contract EthearnalRepToken is MintableToken, LockableToken
* [ ] [code-review/EthearnalRepTokenCrowdsale.md](code-review/EthearnalRepTokenCrowdsale.md)
  * [ ] contract EthearnalRepTokenCrowdsale is MultiOwnable
* [ ] [code-review/LockableToken.md](code-review/LockableToken.md)
  * [ ] contract LockableToken is StandardToken, Ownable
* [ ] [code-review/MultiOwnable.md](code-review/MultiOwnable.md)
  * [ ] contract MultiOwnable
* [ ] [code-review/RefundInvestorsBallot.md](code-review/RefundInvestorsBallot.md)
  * [ ] contract RefundInvestorsBallot is IBallot
* [ ] [code-review/Treasury.md](code-review/Treasury.md)
  * [ ] contract Treasury is MultiOwnable
* [ ] [code-review/VotingProxy.md](code-review/VotingProxy.md)
  * [ ] contract VotingProxy is Ownable

<br />

# OpenZeppelin Included Files

From https://github.com/OpenZeppelin/zeppelin-solidity/commit/725ed40a57e8973b3ae6e2f39f9c887d0056ca39

* [ ] [code-review-zeppelin/math/SafeMath.md](code-review-zeppelin/math/SafeMath.md)
  * [ ] library SafeMath
* [ ] [code-review-zeppelin/ownership/Ownable.md](code-review-zeppelin/ownership/Ownable.md)
  * [ ] contract Ownable
* [ ] [code-review-zeppelin/token/BasicToken.md](code-review-zeppelin/token/BasicToken.md)
  * [ ] contract BasicToken is ERC20Basic
* [ ] [code-review-zeppelin/token/ERC20.md](code-review-zeppelin/token/ERC20.md)
  * [ ] contract ERC20 is ERC20Basic
* [ ] [code-review-zeppelin/token/ERC20Basic.md](code-review-zeppelin/token/ERC20Basic.md)
  * [ ] contract ERC20Basic
* [ ] [code-review-zeppelin/token/MintableToken.md](code-review-zeppelin/token/MintableToken.md)
  * [ ] contract MintableToken is StandardToken, Ownable
* [ ] [code-review-zeppelin/token/StandardToken.md](code-review-zeppelin/token/StandardToken.md)
  * [ ] contract StandardToken is ERC20, BasicToken

<br />

Excluded as this is used for testing:

* [ ] [code-review/Migrations.md](code-review/Migrations.md)
  * [ ] contract Migrations

<br />

### Flattened Files

* [ ] [code-review-flat/EthearnalRepToken_flat.md](code-review-flat/EthearnalRepToken_flat.md)
  * [ ] library SafeMath
  * [ ] contract Ownable
  * [ ] contract ERC20Basic
  * [ ] contract ERC20 is ERC20Basic
  * [ ] contract BasicToken is ERC20Basic
  * [ ] contract StandardToken is ERC20, BasicToken
  * [ ] contract LockableToken is StandardToken, Ownable
  * [ ] contract MintableToken is StandardToken, Ownable
  * [ ] contract EthearnalRepToken is MintableToken, LockableToken
  * Comparison of source files to flattened files using script [flatten/01_EthearnalRepToken.sh](flatten/01_EthearnalRepToken.sh) with
    output in [flatten/01_diff.txt](flatten/01_diff.txt)
* [ ] [code-review-flat/EthearnalRepTokenCrowdsale_flat.md](code-review-flat/EthearnalRepTokenCrowdsale_flat.md)
  * [ ] library SafeMath
  * [ ] contract MultiOwnable
  * [ ] contract Treasury is MultiOwnable
  * [ ] contract IBallot
  * [ ] contract Ballot is IBallot
  * [ ] contract EthearnalRepTokenCrowdsale is MultiOwnable
  * [ ] contract ERC20Basic
  * [ ] contract ERC20 is ERC20Basic
  * [ ] contract Ownable
  * [ ] contract VotingProxy is Ownable
  * [ ] contract BasicToken is ERC20Basic
  * [ ] contract RefundInvestorsBallot is IBallot
  * [ ] contract StandardToken is ERC20, BasicToken
  * [ ] contract LockableToken is StandardToken, Ownable
  * [ ] contract MintableToken is StandardToken, Ownable
  * [ ] contract EthearnalRepToken is MintableToken, LockableToken
  * Comparison of source files to flattened files using script [flatten/02_EthearnalRepTokenCrowdsale.sh](flatten/02_EthearnalRepTokenCrowdsale.sh) with
    output in [flatten/02_diff.txt](flatten/02_diff.txt)
* [ ] [code-review-flat/IncreaseWithdrawalBallot_flat.md](code-review-flat/IncreaseWithdrawalBallot_flat.md)
  * [ ] contract ERC20Basic
  * [ ] contract ERC20 is ERC20Basic
  * [ ] contract Ownable
  * [ ] library SafeMath
  * [ ] contract BasicToken is ERC20Basic
  * [ ] contract StandardToken is ERC20, BasicToken
  * [ ] contract LockableToken is StandardToken, Ownable
  * [ ] contract VotingProxy is Ownable
  * [ ] contract IBallot
  * [ ] contract Ballot is IBallot
  * [ ] contract RefundInvestorsBallot is IBallot
  * [ ] contract MintableToken is StandardToken, Ownable
  * [ ] contract EthearnalRepToken is MintableToken, LockableToken
  * [ ] contract MultiOwnable
  * [ ] contract Treasury is MultiOwnable
  * [ ] contract EthearnalRepTokenCrowdsale is MultiOwnable
  * Comparison of source files to flattened files using script [flatten/03_IncreaseWithdrawalBallot.sh](flatten/03_IncreaseWithdrawalBallot.sh) with
    output in [flatten/03_diff.txt](flatten/03_diff.txt)
* [ ] [code-review-flat/RefundInvestorsBallot_flat.md](code-review-flat/RefundInvestorsBallot_flat.md)
  * [ ] contract Ownable
  * [ ] library SafeMath
  * [ ] contract IBallot
  * [ ] contract Ballot is IBallot
  * [ ] contract MultiOwnable
  * [ ] contract EthearnalRepTokenCrowdsale is MultiOwnable
  * [ ] contract Treasury is MultiOwnable
  * [ ] contract ERC20Basic
  * [ ] contract ERC20 is ERC20Basic
  * [ ] contract BasicToken is ERC20Basic
  * [ ] contract StandardToken is ERC20, BasicToken
  * [ ] contract LockableToken is StandardToken, Ownable
  * [ ] contract RefundInvestorsBallot is IBallot
  * [ ] contract VotingProxy is Ownable
  * [ ] contract MintableToken is StandardToken, Ownable
  * [ ] contract EthearnalRepToken is MintableToken, LockableToken
  * Comparison of source files to flattened files using script [flatten/04_RefundInvestorsBallot.sh](flatten/04_RefundInvestorsBallot.sh) with
    output in [flatten/04_diff.txt](flatten/04_diff.txt)
* [ ] [code-review-flat/Treasury_flat.md](code-review-flat/Treasury_flat.md)
  * [ ] contract ERC20Basic
  * [ ] contract MultiOwnable
  * [ ] library SafeMath
  * [ ] contract EthearnalRepTokenCrowdsale is MultiOwnable
  * [ ] contract BasicToken is ERC20Basic
  * [ ] contract Ownable
  * [ ] contract VotingProxy is Ownable
  * [ ] contract IBallot
  * [ ] contract RefundInvestorsBallot is IBallot
  * [ ] contract ERC20 is ERC20Basic
  * [ ] contract StandardToken is ERC20, BasicToken
  * [ ] contract LockableToken is StandardToken, Ownable
  * [ ] contract MintableToken is StandardToken, Ownable
  * [ ] contract EthearnalRepToken is MintableToken, LockableToken
  * [ ] contract Ballot is IBallot
  * [ ] contract Treasury is MultiOwnable
  * Comparison of source files to flattened files using script [flatten/05_Treasury.sh](flatten/05_Treasury.sh) with
    output in [flatten/05_diff.txt](flatten/05_diff.txt)
* [ ] [code-review-flat/VotingProxy_flat.md](code-review-flat/VotingProxy_flat.md)
  * [ ] contract MultiOwnable
  * [ ] library SafeMath
  * [ ] contract IBallot
  * [ ] contract RefundInvestorsBallot is IBallot
  * [ ] contract Treasury is MultiOwnable
  * [ ] contract Ballot is IBallot
  * [ ] contract ERC20Basic
  * [ ] contract ERC20 is ERC20Basic
  * [ ] contract BasicToken is ERC20Basic
  * [ ] contract StandardToken is ERC20, BasicToken
  * [ ] contract Ownable
  * [ ] contract VotingProxy is Ownable
  * [ ] contract EthearnalRepTokenCrowdsale is MultiOwnable
  * [ ] contract MintableToken is StandardToken, Ownable
  * [ ] contract LockableToken is StandardToken, Ownable
  * [ ] contract EthearnalRepToken is MintableToken, LockableToken
  * Comparison of source files to flattened files using script [flatten/06_VotingProxy.sh](flatten/06_VotingProxy.sh) with
    output in [flatten/06_diff.txt](flatten/06_diff.txt)
