# Ownable

Source file [../../zeppelin-contracts/ownership/Ownable.sol](../../zeppelin-contracts/ownership/Ownable.sol).

<br />

<hr />

```javascript
// BK Ok - Will be replaced
pragma solidity ^0.4.11;


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
// BK Ok
contract Ownable {
  // BK Ok
  address public owner;


  // BK Ok
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  // BK Ok - Constructor
  function Ownable() {
    // BK Ok
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  // BK Ok
  modifier onlyOwner() {
    // BK Ok
    require(msg.sender == owner);
    // BK Ok
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  // BK Ok
  function transferOwnership(address newOwner) onlyOwner public {
    // BK Ok
    require(newOwner != address(0));
    // BK OK
    OwnershipTransferred(owner, newOwner);
    // BK OK
    owner = newOwner;
  }

}

```
