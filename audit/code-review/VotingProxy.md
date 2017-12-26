# VotingProxy

Source file [../../contracts/VotingProxy.sol](../../contracts/VotingProxy.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// BK Next 7 Ok
import './Treasury.sol';
import './Ballot.sol';
import './RefundInvestorsBallot.sol';
import "./EthearnalRepToken.sol";
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import "zeppelin-solidity/contracts/token/ERC20Basic.sol";

// BK Ok
contract VotingProxy is Ownable {
    // BK Ok
    using SafeMath for uint256;
    // BK Ok    
    Treasury public treasuryContract;
    // BK Ok
    EthearnalRepToken public tokenContract;
    // BK Ok
    Ballot public currentIncreaseWithdrawalTeamBallot;
    // BK Ok
    RefundInvestorsBallot public currentRefundInvestorsBallot;

    // BK Ok - Constructor
    function  VotingProxy(address _treasuryContract, address _tokenContract) {
        // BK Ok
        treasuryContract = Treasury(_treasuryContract);
        // BK Ok
        tokenContract = EthearnalRepToken(_tokenContract);
    }

    // BK Ok - Only owner can execute
    function startincreaseWithdrawalTeam() onlyOwner {
        // BK Ok
        require(treasuryContract.isCrowdsaleFinished());
        // BK Ok
        require(address(currentRefundInvestorsBallot) == 0x0 || currentRefundInvestorsBallot.isVotingActive() == false);
        // BK Ok
        if(address(currentIncreaseWithdrawalTeamBallot) == 0x0) {
            // BK Ok
            currentIncreaseWithdrawalTeamBallot =  new Ballot(tokenContract);
        } else {
            // BK Ok
            require(getDaysPassedSinceLastTeamFundsBallot() > 2);
            // BK Ok
            currentIncreaseWithdrawalTeamBallot =  new Ballot(tokenContract);
        }
    }

    // BK Ok - Anyone can call this function
    function startRefundInvestorsBallot() public {
        // BK Ok
        require(treasuryContract.isCrowdsaleFinished());
        // BK Ok
        require(address(currentIncreaseWithdrawalTeamBallot) == 0x0 || currentIncreaseWithdrawalTeamBallot.isVotingActive() == false);
        // BK Ok
        if(address(currentRefundInvestorsBallot) == 0x0) {
            // BK Ok
            currentRefundInvestorsBallot =  new RefundInvestorsBallot(tokenContract);
        // BK Ok
        } else {
            // BK Ok
            require(getDaysPassedSinceLastRefundBallot() > 2);
            // BK Ok
            currentRefundInvestorsBallot =  new RefundInvestorsBallot(tokenContract);
        }
    }

    // BK Ok - Constant function
    function getDaysPassedSinceLastRefundBallot() public constant returns(uint256) {
        // BK Ok
        return getTime().sub(currentRefundInvestorsBallot.ballotStarted()).div(1 days);
    }

    // BK Ok - Constant function
    function getDaysPassedSinceLastTeamFundsBallot() public constant returns(uint256) {
        // BK Ok
        return getTime().sub(currentIncreaseWithdrawalTeamBallot.ballotStarted()).div(1 days);
    }

    // BK Ok - Called by IBallot.decide()
    function proxyIncreaseWithdrawalChunk() public {
        // BK Ok
        require(msg.sender == address(currentIncreaseWithdrawalTeamBallot));
        // BK Ok
        treasuryContract.increaseWithdrawalChunk();
    }

    // BK Ok - Called by RefundInvestorsBallot.decide()
    function proxyEnableRefunds() public {
        // BK Ok
        require(msg.sender == address(currentRefundInvestorsBallot));
        // BK Ok
        treasuryContract.enableRefunds();
    }

    // BK Ok
    function() {
        // BK Ok
        revert();
    }

    // BK Ok
    function getTime() internal returns (uint256) {
        // Just returns `now` value
        // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
        // to allow testing contract behaviour at different time moments
        // BK Ok
        return now;
    }

    // BK Ok - Only owner can execute
    function claimTokens(address _token) public onlyOwner {
        // BK Ok
        if (_token == 0x0) {
            // BK Ok
            owner.transfer(this.balance);
            // BK Ok
            return;
        }
    
        // BK Ok
        ERC20Basic token = ERC20Basic(_token);
        // BK Ok
        uint256 balance = token.balanceOf(this);
        // BK Ok
        token.transfer(owner, balance);
    }

}
```
