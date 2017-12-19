# Ballot

Source file [../../contracts/Ballot.sol](../../contracts/Ballot.sol).

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
contract Ballot is IBallot {

    // BK Ok
    uint256 public initialQuorumPercent = 51;

    // BK Ok - Constructor, called by VotingProxy
    function Ballot(address _tokenContract) {
        // BK Ok
        tokenContract = EthearnalRepToken(_tokenContract);
        // BK Ok
        proxyVotingContract = VotingProxy(msg.sender);
        // BK Ok
        ballotStarted = getTime();
        // BK Ok
        isVotingActive = true;
    }
    
    // BK Ok - Constant function
    function getQuorumPercent() public constant returns (uint256) {
        // BK Ok
        require(isVotingActive);
        // find number of full weeks alapsed since voting started
        // BK Ok
        uint256 weeksNumber = getTime().sub(ballotStarted).div(1 weeks);
        // BK Ok
        if(weeksNumber == 0) {
            // BK Ok
            return initialQuorumPercent;
        }
        // BK Ok
        if (initialQuorumPercent < weeksNumber * 10) {
            // BK Ok
            return 0;
        // BK Ok
        } else {
            // BK Ok
            return initialQuorumPercent.sub(weeksNumber * 10);
        }
    }
    
}
```
