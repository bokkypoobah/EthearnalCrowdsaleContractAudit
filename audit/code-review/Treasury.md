# Treasury

Source file [../../contracts/Treasury.sol](../../contracts/Treasury.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// BK Next 6 Ok
import './MultiOwnable.sol';
import './EthearnalRepTokenCrowdsale.sol';
import './EthearnalRepToken.sol';
import './VotingProxy.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import "zeppelin-solidity/contracts/token/ERC20Basic.sol";

// BK Ok
contract Treasury is MultiOwnable {
    // BK Ok
    using SafeMath for uint256;

    // Total amount of ether withdrawed
    // BK Ok
    uint256 public weiWithdrawed = 0;

    // Total amount of ther unlocked
    // BK Ok
    uint256 public weiUnlocked = 0;

    // Wallet withdraw is locked till end of crowdsale
    // BK Ok
    bool public isCrowdsaleFinished = false;

    // Withdrawed team funds go to this wallet
    // BK Ok
    address teamWallet = 0x0;

    // Crowdsale contract address
    // BK Ok
    EthearnalRepTokenCrowdsale public crowdsaleContract;
    // BK Ok
    EthearnalRepToken public tokenContract;
    // BK Ok
    bool public isRefundsEnabled = false;

    // Amount of ether that could be withdrawed each withdraw iteration
    // BK Ok
    uint256 public withdrawChunk = 0;
    // BK Ok
    VotingProxy public votingProxyContract;
    // BK Ok
    uint256 public refundsIssued = 0;
    // BK Ok
    uint256 public percentLeft = 0;


    // BK Next 4 Ok
    event Deposit(uint256 amount);
    event Withdraw(uint256 amount);
    event UnlockWei(uint256 amount);
    event RefundedInvestor(address indexed investor, uint256 amountRefunded, uint256 tokensBurn);

    // BK Ok - Constructor
    function Treasury(address _teamWallet) public {
        // BK Ok
        require(_teamWallet != 0x0);
        // TODO: check address integrity
        // BK Ok
        teamWallet = _teamWallet;
    }

    // TESTED
    // BK Ok - Fallback function, payable
    function() public payable {
        // BK Ok - Only receive ETH from the crowdsale contract
        require(msg.sender == address(crowdsaleContract));
        // BK Ok - Log event
        Deposit(msg.value);
    }

    // BK Ok - Only owner can execute, once
    function setVotingProxy(address _votingProxyContract) public onlyOwner {
        // BK Ok
        require(votingProxyContract == address(0x0));
        // BK Ok
        votingProxyContract = VotingProxy(_votingProxyContract);
    }

    // TESTED
    // BK OK - Only owner can execute, once
    function setCrowdsaleContract(address _address) public onlyOwner {
        // Could be set only once
        // BK Ok
        require(crowdsaleContract == address(0x0));
        // BK Ok
        require(_address != 0x0);
        // BK Ok
        crowdsaleContract = EthearnalRepTokenCrowdsale(_address); 
    }

    // BK OK - Only owner can execute, once
    function setTokenContract(address _address) public onlyOwner {
        // Could be set only once
        // BK Ok
        require(tokenContract == address(0x0));
        // BK Ok
        require(_address != 0x0);
        // BK Ok
        tokenContract = EthearnalRepToken(_address);
    }

    // TESTED
    // BK OK - Only crowdsale contract can execute, once
    function setCrowdsaleFinished() public {
        // BK Ok
        require(crowdsaleContract != address(0x0));
        // BK Ok
        require(msg.sender == address(crowdsaleContract));
        // BK Ok 10%
        withdrawChunk = getWeiRaised().div(10);
        // BK Ok
        weiUnlocked = withdrawChunk;
        // BK OK
        isCrowdsaleFinished = true;
    }

    // TESTED
    // BK Ok - Only owner can execute
    function withdrawTeamFunds() public onlyOwner {
        // BK OK
        require(isCrowdsaleFinished);
        // BK Ok
        require(weiUnlocked > weiWithdrawed);
        // BK Ok
        uint256 toWithdraw = weiUnlocked.sub(weiWithdrawed);
        // BK Ok
        weiWithdrawed = weiUnlocked;
        // BK Ok
        teamWallet.transfer(toWithdraw);
        // BK Ok - Log event
        Withdraw(toWithdraw);
    }

    // BK Ok - Constant function
    function getWeiRaised() public constant returns(uint256) {
        // BK Ok
       return crowdsaleContract.weiRaised();
    }

    // BK Ok - Only voting proxy contract can execute, after crowdsale end
    function increaseWithdrawalChunk() {
        // BK OK
        require(isCrowdsaleFinished);
        // BK Ok
        require(msg.sender == address(votingProxyContract));
        // BK Ok
        weiUnlocked = weiUnlocked.add(withdrawChunk);
        // BK Ok - Log event
        UnlockWei(weiUnlocked);
    }

    // BK Ok
    function getTime() internal returns (uint256) {
        // Just returns `now` value
        // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
        // to allow testing contract behaviour at different time moments
        // BK Ok
        return now;
    }

    // BK Ok - Only voting proxy contract can execute
    function enableRefunds() public {
        require(msg.sender == address(votingProxyContract));
        // BK Ok
        isRefundsEnabled = true;
    }
    
    // BK Ok - Any investor can execute, if refunds enabled, and burnFrom(...) approve(...)-d
    function refundInvestor(uint256 _tokensToBurn) public {
        // BK Ok
        require(isRefundsEnabled);
        // BK Ok
        require(address(tokenContract) != address(0x0));
        // BK Ok
        if (refundsIssued == 0) {
            // BK Ok
            percentLeft = percentLeftFromTotalRaised().mul(100*1000).div(1 ether);
        }
        // BK Ok
        uint256 tokenRate = crowdsaleContract.getTokenRateEther();
        // BK Ok
        uint256 toRefund = tokenRate.mul(_tokensToBurn).div(1 ether);
        // BK Ok
        toRefund = toRefund.mul(percentLeft).div(100*1000);
        // BK Ok
        require(toRefund > 0);
        // BK Ok
        tokenContract.burnFrom(msg.sender, _tokensToBurn);
        // BK Ok
        msg.sender.transfer(toRefund);
        // BK Ok
        refundsIssued = refundsIssued.add(1);
        // BK Ok - Log event
        RefundedInvestor(msg.sender, toRefund, _tokensToBurn);
    }

    // BK Ok - Constant function
    function percentLeftFromTotalRaised() public constant returns(uint256) {
        // BK Ok
        return percent(this.balance, getWeiRaised(), 18);
    }

    // BK Ok - Constant function
    function percent(uint numerator, uint denominator, uint precision) internal constant returns(uint quotient) {
        // caution, check safe-to-multiply here
        // BK Ok
        uint _numerator  = numerator * 10 ** (precision+1);
        // with rounding of last digit
        // BK Ok
        uint _quotient =  ((_numerator / denominator) + 5) / 10;
        // BK Ok
        return ( _quotient);
    }

    // BK Ok
    function claimTokens(address _token, address _to) public onlyOwner {    
    	// BK Ok
        ERC20Basic token = ERC20Basic(_token);
        // BK Ok
        uint256 balance = token.balanceOf(this);
        // BK Ok
        token.transfer(_to, balance);
    }
}

```
