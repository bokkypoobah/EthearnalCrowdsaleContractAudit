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
    // BK Ok
    uint8 public constant decimals = 18;
}

```
