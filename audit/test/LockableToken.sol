pragma solidity ^0.4.15;

import 'ownership/Ownable.sol';
import 'token/StandardToken.sol';

contract LockableToken is StandardToken, Ownable {
    bool public isLocked = true;
    mapping (address => uint256) public lastMovement;
    event Burn(address _owner, uint256 _amount);


    function unlock() public onlyOwner {
        isLocked = false;
    }

    function transfer(address _to, uint256 _amount) public returns (bool) {
        require(!isLocked);
        lastMovement[msg.sender] = getTime();
        lastMovement[_to] = getTime();
        return super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
        require(!isLocked);
        lastMovement[_from] = getTime();
        lastMovement[_to] = getTime();
        super.transferFrom(_from, _to, _value);
    }

    function approve(address _spender, uint256 _value) public returns (bool) {
        require(!isLocked);
        super.approve(_spender, _value);
    }

    function burnFrom(address _from, uint256 _value) public  returns (bool) {
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        balances[_from] = balances[_from].sub(_value);
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

        totalSupply = totalSupply.sub(_value);
        Burn(_from, _value);
        return true;
    }

    function getTime() internal returns (uint256) {
        // Just returns `now` value
        // This function is redefined in EthearnalRepTokenCrowdsaleMock contract
        // to allow testing contract behaviour at different time moments
        return now;
    }

}
