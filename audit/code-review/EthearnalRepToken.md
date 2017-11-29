# EthearnalRepToken

Source file [../../contracts/EthearnalRepToken.sol](../../contracts/EthearnalRepToken.sol).

<br />

<hr />

```javascript
// BK Ok - Will be replaced
pragma solidity ^0.4.15;

// BK Next 2 Ok
import 'zeppelin-solidity/contracts/token/MintableToken.sol';
import './LockableToken.sol';

// BK Ok
contract EthearnalRepToken is MintableToken, LockableToken {
    // BK Ok
    string public constant name = 'Ethearnal Rep Token';
    // BK Ok
    string public constant symbol = 'ERT';
    // BK NOTE - The following should be `uint8` instead of `uint256`, but no adverse effects have been observed from
    // BK NOTE - using `uint256`
    // BK Ok
    uint256 public constant decimals = 18;
}

```
