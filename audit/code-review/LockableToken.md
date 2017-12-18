# LockableToken

Source file [../../contracts/LockableToken.sol](../../contracts/LockableToken.sol).

<br />

<hr />

```javascript
// BK Ok - Will be replaced
pragma solidity ^0.4.15;

// BK Next 2 Ok
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';

// BK Ok
contract LockableToken is StandardToken, Ownable {
    // BK Ok
    bool public isLocked = true;
    // BK Ok
    mapping (address => uint256) public lastMovement;
    // BK Ok - Event
    event Burn(address _owner, uint256 _amount);


    // BK Ok - Only owner can execute
    function unlock() public onlyOwner {
        // BK Ok
        isLocked = false;
    }

    // BK Ok
    function transfer(address _to, uint256 _amount) public returns (bool) {
        // BK Ok
        require(!isLocked);
        // BK Ok
        lastMovement[msg.sender] = getTime();
        // BK Ok
        lastMovement[_to] = getTime();
        // BK Ok
        return super.transfer(_to, _amount);
    }

    // BK Ok
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        // BK Ok
        require(!isLocked);
        // BK Ok
        lastMovement[_from] = getTime();
        // BK Ok
        lastMovement[_to] = getTime();
        // BK Ok
        super.transferFrom(_from, _to, _value);
    }

    // BK Ok
    function approve(address _spender, uint256 _value) public returns (bool) {
        // BK Ok
        require(!isLocked);
        // BK Ok
        super.approve(_spender, _value);
    }

    // BK Ok - Only approve(...)-d account can burn another account's tokens
    function burnFrom(address _from, uint256 _value) public  returns (bool) {
        // BK Ok
        require(_value <= balances[_from]);
        // BK Ok
        require(_value <= allowed[_from][msg.sender]);
        // BK Ok
        balances[_from] = balances[_from].sub(_value);
        // BK Ok
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        // BK Ok
        totalSupply = totalSupply.sub(_value);
        // BK Ok - Log event
        Burn(_from, _value);
        // BK Ok
        return true;
    }

    // BK Ok - Internal function
    function getTime() internal returns (uint256) {
        // Just returns `now` value
        // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
        // to allow testing contract behaviour at different time moments
        // BK Ok
        return now;
    }

}

```
