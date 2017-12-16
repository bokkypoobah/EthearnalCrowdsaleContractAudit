# IBallot

Source file [../../contracts/IBallot.sol](../../contracts/IBallot.sol).

<br />

<hr />

```javascript
// BK Ok - Will be replaced
pragma solidity ^0.4.15;

// BK Ok
import "./EthearnalRepToken.sol";
import "./VotingProxy.sol";

// BK Ok
contract IBallot {
    // BK Ok
    using SafeMath for uint256;
    // BK Ok
    EthearnalRepToken public tokenContract;

    // Date when vote has started
    // BK Ok
    uint256 public ballotStarted;

    // Registry of votes
    // BK Ok
    mapping(address => bool) public votesByAddress;

    // Sum of weights of YES votes
    // BK Ok
    uint256 public yesVoteSum = 0;

    // Sum of weights of NO votes
    // BK Ok
    uint256 public noVoteSum = 0;

    // Length of `voters`
    // BK Ok
    uint256 public votersLength = 0;

    // BK Ok
    uint256 public initialQuorumPercent = 51;

    // BK Ok
    VotingProxy public proxyVotingContract;

    // Tells if voting process is active
    // BK OK
    bool public isVotingActive = false;

    // BK Ok - Event
    event FinishBallot(uint256 _time);
    
    // BK Ok
    modifier onlyWhenBallotStarted {
        // BK Ok
        require(ballotStarted != 0);
        // BK Ok
        _;
    }

    // BK Ok - Anyone can vote, but processVote(...) will weight by the account's token balance. No tokens = 0 weight
    function vote(bytes _vote) public onlyWhenBallotStarted {
        // BK Ok
        require(_vote.length > 0);
        // BK Ok
        if (isDataYes(_vote)) {
            // BK Ok
            processVote(true);
        // BK Ok
        } else if (isDataNo(_vote)) {
            // BK Ok
            processVote(false);
        }
    }

    // BK Ok - Constant function
    function isDataYes(bytes data) public constant returns (bool) {
        // compare data with "YES" string
        // BK Ok - web3.toAscii("0x597945655373") => "YyEeSs"
        return (
            data.length == 3 &&
            (data[0] == 0x59 || data[0] == 0x79) &&
            (data[1] == 0x45 || data[1] == 0x65) &&
            (data[2] == 0x53 || data[2] == 0x73)
        );
    }

    // TESTED
    // BK Ok - Constant function
    function isDataNo(bytes data) public constant returns (bool) {
        // compare data with "NO" string
        // BK Ok - web3.toAscii("0x4e6e4f6f") => "NnOo"
        return (
            data.length == 2 &&
            (data[0] == 0x4e || data[0] == 0x6e) &&
            (data[1] == 0x4f || data[1] == 0x6f)
        );
    }
    
    // BK Ok - Anyone can vote, but votes are weighted by the account's token balance. No tokens = 0 weight
    function processVote(bool isYes) internal {
        // BK Ok
        require(isVotingActive);
        // BK Ok
        require(!votesByAddress[msg.sender]);
        // BK Ok
        votersLength = votersLength.add(1);
        // BK Ok
        uint256 voteWeight = tokenContract.balanceOf(msg.sender);
        // BK Ok
        if (isYes) {
            // BK Ok
            yesVoteSum = yesVoteSum.add(voteWeight);
        // BK Ok
        } else {
            // BK Ok
            noVoteSum = noVoteSum.add(voteWeight);
        }
        // BK Ok
        require(getTime().sub(tokenContract.lastMovement(msg.sender)) > 7 days);
        // BK Ok
        uint256 quorumPercent = getQuorumPercent();
        // BK Ok
        if (quorumPercent == 0) {
            // BK Ok
            isVotingActive = false;
        // BK Ok
        } else {
            // BK Ok
            decide();
        }
        // BK Ok
        votesByAddress[msg.sender] = true;
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
            if (percentYes >= initialQuorumPercent) {
                // does not matter if it would be greater than weiRaised
                proxyVotingContract.proxyIncreaseWithdrawalChunk();
                FinishBallot(now);
                // BK Ok
                isVotingActive = false;
            } else {
                // do nothing, just deactivate voting
                // BK Ok
                isVotingActive = false;
                FinishBallot(now);
            }
        }
        
    }

    // BK Ok - Matches implementation
    function getQuorumPercent() public constant returns (uint256);

    // BK Ok - internal function
    function getTime() internal returns (uint256) {
        // Just returns `now` value
        // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
        // to allow testing contract behaviour at different time moments
        // BK Ok
        return now;
    }
    
}
```
