# RefundInvestorsBallot

Source file [../../contracts/RefundInvestorsBallot.sol](../../contracts/RefundInvestorsBallot.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// BK Next 2 Ok
import "./EthearnalRepToken.sol";
import "./VotingProxy.sol";

// BK Ok
contract RefundInvestorsBallot {
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
    // BK Ok
    uint256 public requiredMajorityPercent = 65;

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
        // BK OK
        require(isVotingActive);
        // BK OK
        require(!votesByAddress[msg.sender]);
        // BK OK
        votersLength = votersLength.add(1);
        // BK OK
        uint256 voteWeight = tokenContract.balanceOf(msg.sender);
        // BK OK
        if (isYes) {
            // BK OK
            yesVoteSum = yesVoteSum.add(voteWeight);
        // BK OK
        } else {
            // BK OK
            noVoteSum = noVoteSum.add(voteWeight);
        }
        // BK OK
        require(getTime().sub(tokenContract.lastMovement(msg.sender)) > 7 days);
        // BK OK
        uint256 quorumPercent = getQuorumPercent();
        // BK OK
        if (quorumPercent == 0) {
            // BK OK
            isVotingActive = false;
        // BK OK
        } else {
            // BK OK
            decide();
        }
        // BK OK
        votesByAddress[msg.sender] = true;
    }

    // BK OK
    function getTime() internal returns (uint256) {
        // Just returns `now` value
        // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
        // to allow testing contract behaviour at different time moments
        // BK OK
        return now;
    }

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
        // BK NOTE - Month is 5 weeks
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
