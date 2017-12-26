# MultiOwnable

Source file [../../contracts/MultiOwnable.sol](../../contracts/MultiOwnable.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.15;


// BK Ok
contract MultiOwnable {
    // BK Ok
    mapping (address => bool) public ownerRegistry;
    // BK Ok
    address[] owners;
    // BK Ok
    address public multiOwnableCreator = 0x0;

    // BK Ok - Constructor
    function MultiOwnable() public {
        // BK Ok
        multiOwnableCreator = msg.sender;
    }

    // BK Ok - Only original owner can execute, once. Note that there is no ability to transfer ownership of contracts that use this
    function setupOwners(address[] _owners) public {
        // Owners are allowed to be set up only one time
        // BK Ok
        require(multiOwnableCreator == msg.sender);
        // BK Ok - Can only be done once
        require(owners.length == 0);
        // BK Ok
        for(uint256 idx=0; idx < _owners.length; idx++) {
            // BK Ok
            require(
                !ownerRegistry[_owners[idx]] &&
                _owners[idx] != 0x0 &&
                _owners[idx] != address(this)
            );
            // BK Ok
            ownerRegistry[_owners[idx]] = true;
        }
        // BK Ok
        owners = _owners;
    }

    // BK Ok
    modifier onlyOwner() {
        // BK Ok
        require(ownerRegistry[msg.sender] == true);
        // BK Ok
        _;
    }

    // BK Ok - Constant function
    function getOwners() public constant returns (address[]) {
        // BK Ok
        return owners;
    }
}

```
