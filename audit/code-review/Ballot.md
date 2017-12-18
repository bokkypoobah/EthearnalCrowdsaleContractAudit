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
    
    function getQuorumPercent() public constant returns (uint256) {
        require(isVotingActive);
        // find number of full weeks alapsed since voting started
        uint256 weeksNumber = getTime().sub(ballotStarted).div(1 weeks);
        if(weeksNumber == 0) {
            return initialQuorumPercent;
        }
        if (initialQuorumPercent < weeksNumber * 10) {
            return 0;
        } else {
            return initialQuorumPercent.sub(weeksNumber * 10);
        }
    }
    
}
```
