# EthearnalRepTokenCrowdsale

Source file [../../contracts/EthearnalRepTokenCrowdsale.sol](../../contracts/EthearnalRepTokenCrowdsale.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;

// BK Next 4 Ok
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import './EthearnalRepToken.sol';
import './Treasury.sol';
import "./MultiOwnable.sol";

// BK NOTE - Whitelisted investors can contribute before saleStartDate
// BK NOTE - Non-whitelisted investors can contribute after saleStartDate and before saleEndDate
// BK Ok
contract EthearnalRepTokenCrowdsale is MultiOwnable {
    using SafeMath for uint256;

    /* *********************
     * Variables & Constants
     */

    // Token Contract
    // BK Ok
    EthearnalRepToken public token;

    // Ethereum rate, how much USD does 1 ether cost
    // The actual value is set by setEtherRateUsd
    // BK Ok
    uint256 etherRateUsd = 300;

    // Token price in Ether, 1 token is 0.5 USD, 3 decimals
    // BK Ok
    uint256 public tokenRateUsd = (1 * 1000) / uint256(2);

    // Mainsale Start Date (11 Nov 16:00 UTC)
    // BK Ok
    uint256 public constant saleStartDate = 1510416000;

    // Mainsale End Date (11 Dec 16:00 UTC)
    // BK Ok
    uint256 public constant saleEndDate = 1513008000;

    // How many tokens generate for the team, ratio with 3 decimals digits
    // BK Ok
    uint256 public constant teamTokenRatio = uint256(1 * 1000) / 3;

    // Crowdsale State
    // BK Next block Ok
    enum State {
        BeforeMainSale, // pre-sale finisehd, before main sale
        MainSale, // main sale is active
        MainSaleDone, // main sale done, ICO is not finalized
        Finalized // the final state till the end of the world
    }

    // Hard cap for total sale
    // BK Ok
    uint256 public saleCapUsd = 30 * (10**6);

    // Money raised totally
    // BK Ok
    uint256 public weiRaised = 0;

    // This event means everything is finished and tokens
    // are allowed to be used by their owners
    // BK Ok
    bool public isFinalized = false;

    // Wallet to send team tokens
    // BK Ok
    address public teamTokenWallet = 0x0;

    // money received from each customer
    // BK Ok
    mapping(address => uint256) public raisedByAddress;

    // whitelisted investors
    // BK Ok
    mapping(address => bool) public whitelist;
    // how many whitelisted investors
    // BK Ok
    uint256 public whitelistedInvestorCounter;


    // Extra money each address can spend each hour
    // BK Ok
    uint256 hourLimitByAddressUsd = 1000;

    // Wallet to store all raised money
    // BK Ok
    Treasury public treasuryContract = Treasury(0x0);

    /* *******
     * Events
     */
    
    event ChangeReturn(address recipient, uint256 amount);
    event TokenPurchase(address buyer, uint256 weiAmount, uint256 tokenAmount);
    /* **************
     * Public methods
     */

    // BK Ok - Constructor
    function EthearnalRepTokenCrowdsale(
        address[] _owners,
        address _treasuryContract,
        address _teamTokenWallet
    ) {
        // BK Ok
        require(_owners.length > 1);
        // BK Ok
        require(_treasuryContract != 0x0);
        // BK Ok
        require(_teamTokenWallet != 0x0);
        // BK Ok
        require(Treasury(_treasuryContract).votingProxyContract() != address(0));
        // BK Ok
        require(Treasury(_treasuryContract).tokenContract() != address(0));
        // BK Ok
        treasuryContract = Treasury(_treasuryContract);
        // BK Ok
        teamTokenWallet = _teamTokenWallet;
        // BK Ok
        setupOwners(_owners);
    }

    // BK Ok - Fallback function, payable
    function() public payable {
        // BK Ok
        if (whitelist[msg.sender]) {
            // BK Ok
            buyForWhitelisted();
        // BK Ok
        } else {
            // BK Ok
            buyTokens();
        }
    }

    // BK Ok - Only owner can execute
    function setTokenContract(address _token) public onlyOwner {
        // BK Ok
        require(_token != 0x0 && token == address(0));
        // BK Ok
        require(EthearnalRepToken(_token).owner() == address(this));
        // BK Ok
        require(EthearnalRepToken(_token).totalSupply() == 0);
        // BK Ok
        require(EthearnalRepToken(_token).isLocked());
        // BK Ok
        require(!EthearnalRepToken(_token).mintingFinished());
        // BK Ok
        token = EthearnalRepToken(_token);
    }

    // BK Ok - Can be executed by whitelisted accounts, payable
    function buyForWhitelisted() public payable {
        // BK Ok
        require(token != address(0));
        // BK Ok
        address whitelistedInvestor = msg.sender;
        // BK Ok
        require(whitelist[whitelistedInvestor]);
        // BK Ok
        uint256 weiToBuy = msg.value;
        // BK Ok
        require(weiToBuy > 0);
        // BK Ok
        uint256 tokenAmount = getTokenAmountForEther(weiToBuy);
        // BK Ok
        require(tokenAmount > 0);
        // BK Ok
        weiRaised = weiRaised.add(weiToBuy);
        // BK Ok
        raisedByAddress[whitelistedInvestor] = raisedByAddress[whitelistedInvestor].add(weiToBuy);
        // BK Ok
        assert(token.mint(whitelistedInvestor, tokenAmount));
        // BK Ok
        forwardFunds(weiToBuy);
        // BK Ok - Log event
        TokenPurchase(whitelistedInvestor, weiToBuy, tokenAmount);
    }

    // BK Ok - Can be executed by anyone, payable
    function buyTokens() public payable {
        // BK Ok
        require(token != address(0));
        // BK Ok
        address recipient = msg.sender;
        // BK Ok
        State state = getCurrentState();
        // BK Ok
        uint256 weiToBuy = msg.value;
        // BK Ok
        require(
            (state == State.MainSale) &&
            (weiToBuy > 0)
        );
        // BK Ok - 3.333333333333333333 ETH per hour from start of sale - amount already contributed
        weiToBuy = min(weiToBuy, getWeiAllowedFromAddress(recipient));
        // BK Ok
        require(weiToBuy > 0);
        // BK Ok
        weiToBuy = min(weiToBuy, convertUsdToEther(saleCapUsd).sub(weiRaised));
        // BK Ok - Following statement is redundant due to check above and the min(...) function, but Ok
        require(weiToBuy > 0);
        // BK Ok
        uint256 tokenAmount = getTokenAmountForEther(weiToBuy);
        // BK Ok
        require(tokenAmount > 0);
        // BK Ok
        uint256 weiToReturn = msg.value.sub(weiToBuy);
        // BK Ok
        weiRaised = weiRaised.add(weiToBuy);
        // BK Ok
        raisedByAddress[recipient] = raisedByAddress[recipient].add(weiToBuy);
        // BK Ok
        if (weiToReturn > 0) {
            // BK Ok
            recipient.transfer(weiToReturn);
            // BK Ok - Log event
            ChangeReturn(recipient, weiToReturn);
        }
        // BK Ok
        assert(token.mint(recipient, tokenAmount));
        // BK Ok
        forwardFunds(weiToBuy);
        // BK Ok - Log event
        TokenPurchase(recipient, weiToBuy, tokenAmount);
    }

    // TEST
    // BK Ok - Can only be executed by owner
    function finalizeByAdmin() public onlyOwner {
        // BK Ok
        finalize();
    }

    /* ****************
     * Internal methods
     */

    // BK Ok
    function forwardFunds(uint256 _weiToBuy) internal {
        // BK Ok
        treasuryContract.transfer(_weiToBuy);
    }

    // TESTED
    // BK Ok
    function convertUsdToEther(uint256 usdAmount) constant internal returns (uint256) {
        // BK Ok
        return usdAmount.mul(1 ether).div(etherRateUsd);
    }

    // TESTED
    // BK Ok
    function getTokenRateEther() public constant returns (uint256) {
        // div(1000) because 3 decimals in tokenRateUsd
        // BK Ok
        return convertUsdToEther(tokenRateUsd).div(1000);
    }

    // TESTED
    // BK Ok
    function getTokenAmountForEther(uint256 weiAmount) constant internal returns (uint256) {
        // BK Ok
        return weiAmount
            .div(getTokenRateEther())
            .mul(10 ** uint256(token.decimals()));
    }

    // TESTED
    // BK Ok
    function isReadyToFinalize() internal returns (bool) {
        // BK Ok
        return(
            (weiRaised >= convertUsdToEther(saleCapUsd)) ||
            (getCurrentState() == State.MainSaleDone)
        );
    }

    // TESTED
    // BK Ok
    function min(uint256 a, uint256 b) internal returns (uint256) {
        // BK Ok
        return (a < b) ? a: b;
    }

    // TESTED
    // BK Ok
    function max(uint256 a, uint256 b) internal returns (uint256) {
        // BK Ok
        return (a > b) ? a: b;
    }

    // TESTED
    // BK Ok
    function ceil(uint a, uint b) internal returns (uint) {
        // BK Ok
        return ((a.add(b).sub(1)).div(b)).mul(b);
    }

    // TESTED
    // BK Ok
    function getWeiAllowedFromAddress(address _sender) internal returns (uint256) {
        // BK Ok
        uint256 secondsElapsed = getTime().sub(saleStartDate);
        // BK Ok
        uint256 fullHours = ceil(secondsElapsed, 3600).div(3600);
        // BK Ok
        fullHours = max(1, fullHours);
        // BK Ok -  convertUsdToEther(hourLimitByAddressUsd) = 3.333333333333333333
        uint256 weiLimit = fullHours.mul(convertUsdToEther(hourLimitByAddressUsd));
        // BK Ok
        return weiLimit.sub(raisedByAddress[_sender]);
    }

    // BK Ok
    function getTime() internal returns (uint256) {
        // Just returns `now` value
        // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
        // to allow testing contract behaviour at different time moments
        // BK Ok
        return now;
    }

    // TESTED
    // BK Ok
    function getCurrentState() internal returns (State) {
        // BK Ok
        return getStateForTime(getTime());
    }

    // TESTED
    // BK Ok
    function getStateForTime(uint256 unixTime) internal returns (State) {
        // BK Ok
        if (isFinalized) {
            // This could be before end date of ICO
            // if hard cap is reached
            // BK Ok
            return State.Finalized;
        }
        // BK Ok
        if (unixTime < saleStartDate) {
            // BK Ok
            return State.BeforeMainSale;
        }
        // BK Ok
        if (unixTime < saleEndDate) {
            // BK Ok
            return State.MainSale;
        }
        // BK Ok
        return State.MainSaleDone;
    }

    // TESTED
    // BK Ok
    function finalize() private {
        // BK Ok
        if (!isFinalized) {
            // BK Ok
            require(isReadyToFinalize());
            // BK Ok
            isFinalized = true;
            // BK Ok
            mintTeamTokens();
            // BK Ok
            token.unlock();
            // BK Ok
            treasuryContract.setCrowdsaleFinished();
        }
    }

    // TESTED
    // BK Ok
    function mintTeamTokens() private {
        // div by 1000 because of 3 decimals digits in teamTokenRatio
        // BK Ok
        var tokenAmount = token.totalSupply().mul(teamTokenRatio).div(1000);
        // BK Ok
        token.mint(teamTokenWallet, tokenAmount);
    }


    // BK Ok - Only owner can execute
    function whitelistInvestor(address _newInvestor) public onlyOwner {
        // BK Ok
        if(!whitelist[_newInvestor]) {
            // BK Ok
            whitelist[_newInvestor] = true;
            // BK Ok
            whitelistedInvestorCounter++;
        }
    }
    // BK Ok - Only owner can execute
    function whitelistInvestors(address[] _investors) external onlyOwner {
        // BK Ok
        require(_investors.length <= 250);
        // BK Ok
        for(uint8 i=0; i<_investors.length;i++) {
            // BK Ok
            address newInvestor = _investors[i];
            // BK Ok
            if(!whitelist[newInvestor]) {
                // BK Ok
                whitelist[newInvestor] = true;
                // BK Ok
                whitelistedInvestorCounter++;
            }
        }
    }
    // BK Ok - Only owner can execute
    function blacklistInvestor(address _investor) public onlyOwner {
        // BK Ok
        if(whitelist[_investor]) {
            // BK Ok
            delete whitelist[_investor];
            // BK Ok
            if(whitelistedInvestorCounter != 0) {
                // BK Ok
                whitelistedInvestorCounter--;
            }
        }
    }

}

```
