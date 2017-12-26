# Ballot

Source file [../../contracts/Ballot.sol](../../contracts/Ballot.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// BK Next 2 Ok
import "./EthearnalRepToken.sol";
import "./VotingProxy.sol";

// BK Ok
contract Ballot {
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
    // BK Ok
    bool public isVotingActive = false;

    // BK Next 2 Ok - Events
    event FinishBallot(uint256 _time);
    event Vote(address indexed sender, bytes vote);
    
    // BK Ok
    modifier onlyWhenBallotStarted {
        // BK Ok
        require(ballotStarted != 0);
        // BK Ok
        _;
    }

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
        // BK Ok - Log event
        Vote(msg.sender, _vote);
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
                // BK Ok
                proxyVotingContract.proxyIncreaseWithdrawalChunk();
                // BK Ok - Log event
                FinishBallot(now);
                // BK Ok
                isVotingActive = false;
            // BK Ok
            } else {
                // do nothing, just deactivate voting
                // BK Ok
                isVotingActive = false;
                // BK Ok - Log event
                FinishBallot(now);
            }
        }
        
    }

    // BK Ok
    function getTime() internal returns (uint256) {
        // Just returns `now` value
        // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
        // to allow testing contract behaviour at different time moments
        // BK Ok
        return now;
    }
    
}
```
