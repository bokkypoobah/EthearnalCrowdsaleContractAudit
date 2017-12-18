# RefundInvestorsBallot

Source file [../../contracts/RefundInvestorsBallot.sol](../../contracts/RefundInvestorsBallot.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// BK Next 3 Ok
import "./EthearnalRepToken.sol";
import "./VotingProxy.sol";
import "./IBallot.sol";

// BK Ok
contract RefundInvestorsBallot is IBallot {

    // BK Ok
    uint256 public initialQuorumPercent = 51;
    // BK Ok
    uint256 public requiredMajorityPercent = 65;

    // BK Ok - Constructor
    function RefundInvestorsBallot(address _tokenContract) {
        // BK Ok
        tokenContract = EthearnalRepToken(_tokenContract);
        // BK Ok
        proxyVotingContract = VotingProxy(msg.sender);
        // BK Ok
        ballotStarted = getTime();
        // BK Ok
        isVotingActive = true;
    }

    // BK Ok
    function decide() internal {
        // BK Ok
        uint256 quorumPercent = getQuorumPercent();
        // BK Ok
        uint256 quorum = quorumPercent.mul(tokenContract.totalSupply()).div(100);
        // BK Ok
        uint256 soFarVoted = yesVoteSum.add(noVoteSum);
        // BK Ok
        if (soFarVoted >= quorum) {
            // BK Ok
            uint256 percentYes = (100 * yesVoteSum).div(soFarVoted);
            // BK Ok
            if (percentYes >= requiredMajorityPercent) {
                // does not matter if it would be greater than weiRaised
                // BK Ok
                proxyVotingContract.proxyEnableRefunds();
                // BK Ok - Log event
                FinishBallot(now);
                // BK Ok
                isVotingActive = false;
            // BK Ok
            } else {
                // do nothing, just deactivate voting
                // BK Ok
                isVotingActive = false;
            }
        }
    }
    
    // BK Ok - Constant function
    function getQuorumPercent() public constant returns (uint256) {
        // NOTE - Month is 5 weeks
        // BK Ok
        uint256 isMonthPassed = getTime().sub(ballotStarted).div(5 weeks);
        // BK Ok
        if(isMonthPassed == 1){
            // BK Ok
            return 0;
        }
        // BK Ok
        return initialQuorumPercent;
    }
    
}
```
