// Nov 29 2017
var ethPriceUSD = 469.82;
var defaultGasPrice = web3.toWei(1, "gwei");

// -----------------------------------------------------------------------------
// Accounts
// -----------------------------------------------------------------------------
var accounts = [];
var accountNames = {};

addAccount(eth.accounts[0], "Account #0 - Miner");
addAccount(eth.accounts[1], "Account #1 - Contract Owner");
addAccount(eth.accounts[2], "Account #2 - Whitelisted");
addAccount(eth.accounts[3], "Account #3 - Whitelisted");
addAccount(eth.accounts[4], "Account #4");
addAccount(eth.accounts[5], "Account #5");
addAccount(eth.accounts[6], "Account #6");
addAccount(eth.accounts[7], "Account #7");
addAccount(eth.accounts[8], "Account #8");
addAccount(eth.accounts[9], "Account #9");
addAccount(eth.accounts[10], "Account #10 - Owner #1");
addAccount(eth.accounts[11], "Account #11 - Owner #2");
addAccount(eth.accounts[12], "Account #12 - Team Wallet");


var minerAccount = eth.accounts[0];
var contractOwnerAccount = eth.accounts[1];
var account2 = eth.accounts[2];
var account3 = eth.accounts[3];
var account4 = eth.accounts[4];
var account5 = eth.accounts[5];
var account6 = eth.accounts[6];
var account7 = eth.accounts[7];
var account8 = eth.accounts[8];
var account9 = eth.accounts[9];
var owner1 = eth.accounts[10];
var owner2 = eth.accounts[11];
var teamWallet = eth.accounts[12];

var baseBlock = eth.blockNumber;

function unlockAccounts(password) {
  for (var i = 0; i < eth.accounts.length && i < accounts.length; i++) {
    personal.unlockAccount(eth.accounts[i], password, 100000);
  }
}

function addAccount(account, accountName) {
  accounts.push(account);
  accountNames[account] = accountName;
}


// -----------------------------------------------------------------------------
// Token Contract
// -----------------------------------------------------------------------------
var tokenContractAddress = null;
var tokenContractAbi = null;

function addTokenContractAddressAndAbi(address, tokenAbi) {
  tokenContractAddress = address;
  tokenContractAbi = tokenAbi;
}


// -----------------------------------------------------------------------------
// Account ETH and token balances
// -----------------------------------------------------------------------------
function printBalances() {
  var token = tokenContractAddress == null || tokenContractAbi == null ? null : web3.eth.contract(tokenContractAbi).at(tokenContractAddress);
  var decimals = token == null ? 18 : token.decimals();
  var i = 0;
  var totalTokenBalance = new BigNumber(0);
  console.log("RESULT:  # Account                                             EtherBalanceChange                          Token Name");
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  accounts.forEach(function(e) {
    var etherBalanceBaseBlock = eth.getBalance(e, baseBlock);
    var etherBalance = web3.fromWei(eth.getBalance(e).minus(etherBalanceBaseBlock), "ether");
    var tokenBalance = token == null ? new BigNumber(0) : token.balanceOf(e).shift(-decimals);
    totalTokenBalance = totalTokenBalance.add(tokenBalance);
    console.log("RESULT: " + pad2(i) + " " + e  + " " + pad(etherBalance) + " " + padToken(tokenBalance, decimals) + " " + accountNames[e]);
    i++;
  });
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  console.log("RESULT:                                                                           " + padToken(totalTokenBalance, decimals) + " Total Token Balances");
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  console.log("RESULT: ");
}

function pad2(s) {
  var o = s.toFixed(0);
  while (o.length < 2) {
    o = " " + o;
  }
  return o;
}

function pad(s) {
  var o = s.toFixed(18);
  while (o.length < 27) {
    o = " " + o;
  }
  return o;
}

function padToken(s, decimals) {
  var o = s.toFixed(decimals);
  var l = parseInt(decimals)+12;
  while (o.length < l) {
    o = " " + o;
  }
  return o;
}


// -----------------------------------------------------------------------------
// Transaction status
// -----------------------------------------------------------------------------
function printTxData(name, txId) {
  var tx = eth.getTransaction(txId);
  var txReceipt = eth.getTransactionReceipt(txId);
  var gasPrice = tx.gasPrice;
  var gasCostETH = tx.gasPrice.mul(txReceipt.gasUsed).div(1e18);
  var gasCostUSD = gasCostETH.mul(ethPriceUSD);
  var block = eth.getBlock(txReceipt.blockNumber);
  console.log("RESULT: " + name + " status=" + txReceipt.status + (txReceipt.status == 0 ? " Failure" : " Success") + " gas=" + tx.gas +
    " gasUsed=" + txReceipt.gasUsed + " costETH=" + gasCostETH + " costUSD=" + gasCostUSD +
    " @ ETH/USD=" + ethPriceUSD + " gasPrice=" + web3.fromWei(gasPrice, "gwei") + " gwei block=" +
    txReceipt.blockNumber + " txIx=" + tx.transactionIndex + " txId=" + txId +
    " @ " + block.timestamp + " " + new Date(block.timestamp * 1000).toUTCString());
}

function assertEtherBalance(account, expectedBalance) {
  var etherBalance = web3.fromWei(eth.getBalance(account), "ether");
  if (etherBalance == expectedBalance) {
    console.log("RESULT: OK " + account + " has expected balance " + expectedBalance);
  } else {
    console.log("RESULT: FAILURE " + account + " has balance " + etherBalance + " <> expected " + expectedBalance);
  }
}

function failIfTxStatusError(tx, msg) {
  var status = eth.getTransactionReceipt(tx).status;
  if (status == 0) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function passIfTxStatusError(tx, msg) {
  var status = eth.getTransactionReceipt(tx).status;
  if (status == 1) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function gasEqualsGasUsed(tx) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  return (gas == gasUsed);
}

function failIfGasEqualsGasUsed(tx, msg) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  if (gas == gasUsed) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function passIfGasEqualsGasUsed(tx, msg) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  if (gas == gasUsed) {
    console.log("RESULT: PASS " + msg);
    return 1;
  } else {
    console.log("RESULT: FAIL " + msg);
    return 0;
  }
}

function failIfGasEqualsGasUsedOrContractAddressNull(contractAddress, tx, msg) {
  if (contractAddress == null) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    var gas = eth.getTransaction(tx).gas;
    var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
    if (gas == gasUsed) {
      console.log("RESULT: FAIL " + msg);
      return 0;
    } else {
      console.log("RESULT: PASS " + msg);
      return 1;
    }
  }
}


//-----------------------------------------------------------------------------
//Wait until some unixTime + additional seconds
//-----------------------------------------------------------------------------
function waitUntil(message, unixTime, addSeconds) {
  var t = parseInt(unixTime) + parseInt(addSeconds) + parseInt(1);
  var time = new Date(t * 1000);
  console.log("RESULT: Waiting until '" + message + "' at " + unixTime + "+" + addSeconds + "s =" + time + " now=" + new Date());
  while ((new Date()).getTime() <= time.getTime()) {
  }
  console.log("RESULT: Waited until '" + message + "' at at " + unixTime + "+" + addSeconds + "s =" + time + " now=" + new Date());
  console.log("RESULT: ");
}


//-----------------------------------------------------------------------------
//Wait until some block
//-----------------------------------------------------------------------------
function waitUntilBlock(message, block, addBlocks) {
  var b = parseInt(block) + parseInt(addBlocks);
  console.log("RESULT: Waiting until '" + message + "' #" + block + "+" + addBlocks + " = #" + b + " currentBlock=" + eth.blockNumber);
  while (eth.blockNumber <= b) {
  }
  console.log("RESULT: Waited until '" + message + "' #" + block + "+" + addBlocks + " = #" + b + " currentBlock=" + eth.blockNumber);
  console.log("RESULT: ");
}


//-----------------------------------------------------------------------------
// Token Contract
//-----------------------------------------------------------------------------
var tokenFromBlock = 0;
function printTokenContractDetails() {
  console.log("RESULT: tokenContractAddress=" + tokenContractAddress);
  if (tokenContractAddress != null && tokenContractAbi != null) {
    var contract = eth.contract(tokenContractAbi).at(tokenContractAddress);
    var decimals = contract.decimals();
    console.log("RESULT: token.owner=" + contract.owner());
    console.log("RESULT: token.name=" + contract.name());
    console.log("RESULT: token.symbol=" + contract.symbol());
    console.log("RESULT: token.decimals=" + decimals);
    console.log("RESULT: token.totalSupply=" + contract.totalSupply().shift(-decimals));
    console.log("RESULT: token.isLocked=" + contract.isLocked());
    console.log("RESULT: token.mintingFinished=" + contract.mintingFinished());

    /*
    console.log("RESULT: token.DATE_PRESALE_START=" + contract.DATE_PRESALE_START() + " " + new Date(contract.DATE_PRESALE_START() * 1000).toUTCString());
    console.log("RESULT: token.DATE_PRESALE_END=" + contract.DATE_PRESALE_END() + " " + new Date(contract.DATE_PRESALE_END() * 1000).toUTCString());
    */

    var latestBlock = eth.blockNumber;
    var i;

    var ownershipTransferredEvents = contract.OwnershipTransferred({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferredEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferred " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferredEvents.stopWatching();

    var burnEvents = contract.Burn({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    burnEvents.watch(function (error, result) {
      console.log("RESULT: Burn " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    burnEvents.stopWatching();

    var mintEvents = contract.Mint({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    mintEvents.watch(function (error, result) {
      console.log("RESULT: Mint " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    mintEvents.stopWatching();

    var mintFinishedEvents = contract.MintFinished({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    mintFinishedEvents.watch(function (error, result) {
      console.log("RESULT: MintFinished " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    mintFinishedEvents.stopWatching();

    var approvalEvents = contract.Approval({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    approvalEvents.watch(function (error, result) {
      console.log("RESULT: Approval " + i++ + " #" + result.blockNumber + " owner=" + result.args.owner + " spender=" + result.args.spender +
        " value=" + result.args.value.shift(-decimals));
    });
    approvalEvents.stopWatching();

    var transferEvents = contract.Transfer({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    transferEvents.watch(function (error, result) {
      console.log("RESULT: Transfer " + i++ + " #" + result.blockNumber + ": from=" + result.args.from + " to=" + result.args.to +
        " value=" + result.args.value.shift(-decimals));
    });
    transferEvents.stopWatching();

    tokenFromBlock = latestBlock + 1;
  }
}


//-----------------------------------------------------------------------------
// Treasury Contract
//-----------------------------------------------------------------------------
var treasuryContractAddress = null;
var treasuryContractAbi = null;
function addTreasuryContractAddressAndAbi(address, abi) {
  treasuryContractAddress = address;
  treasuryContractAbi = abi;
}
var treasuryFromBlock = 0;
function printTreasuryContractDetails() {
  console.log("RESULT: treasuryContractAddress=" + treasuryContractAddress);
  if (treasuryContractAddress != null && treasuryContractAbi != null) {
    var contract = eth.contract(treasuryContractAbi).at(treasuryContractAddress);
    // console.log("RESULT: treasury.getOwners()=" + JSON.stringify(contract.getOwners()));
    console.log("RESULT: treasury.weiWithdrawed=" + contract.weiWithdrawed() + " " + contract.weiWithdrawed().shift(-18) + " ETH");
    console.log("RESULT: treasury.weiUnlocked=" + contract.weiUnlocked() + " " + contract.weiUnlocked().shift(-18) + " ETH");
    console.log("RESULT: treasury.isCrowdsaleFinished=" + contract.isCrowdsaleFinished());
    // console.log("RESULT: treasury.teamWallet=" + contract.teamWallet());
    console.log("RESULT: treasury.crowdsaleContract=" + contract.crowdsaleContract());
    console.log("RESULT: treasury.tokenContract=" + contract.tokenContract());
    console.log("RESULT: treasury.isRefundsEnabled=" + contract.isRefundsEnabled());
    console.log("RESULT: treasury.withdrawChunk=" + contract.withdrawChunk() + " " + contract.withdrawChunk().shift(-18) + " ETH");
    console.log("RESULT: treasury.votingProxyContract=" + contract.votingProxyContract());

    var latestBlock = eth.blockNumber;
    var i;

    var depositEvents = contract.Deposit({}, { fromBlock: treasuryFromBlock, toBlock: latestBlock });
    i = 0;
    depositEvents.watch(function (error, result) {
      console.log("RESULT: Deposit " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    depositEvents.stopWatching();

    var withdrawEvents = contract.Withdraw({}, { fromBlock: treasuryFromBlock, toBlock: latestBlock });
    i = 0;
    withdrawEvents.watch(function (error, result) {
      console.log("RESULT: Withdraw " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    withdrawEvents.stopWatching();

    var unlockWeiEvents = contract.UnlockWei({}, { fromBlock: treasuryFromBlock, toBlock: latestBlock });
    i = 0;
    unlockWeiEvents.watch(function (error, result) {
      console.log("RESULT: UnlockWei " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    unlockWeiEvents.stopWatching();

    var refundedInvestorEvents = contract.RefundedInvestor({}, { fromBlock: treasuryFromBlock, toBlock: latestBlock });
    i = 0;
    refundedInvestorEvents.watch(function (error, result) {
      console.log("RESULT: RefundedInvestor " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    refundedInvestorEvents.stopWatching();

    treasuryFromBlock = latestBlock + 1;
  }
}


//-----------------------------------------------------------------------------
// VotingProxy Contract
//-----------------------------------------------------------------------------
var votingProxyContractAddress = null;
var votingProxyContractAbi = null;
function addVotingProxyContractAddressAndAbi(address, abi) {
  votingProxyContractAddress = address;
  votingProxyContractAbi = abi;
}
function printVotingProxyContractDetails() {
  console.log("RESULT: votingProxyContractAddress=" + votingProxyContractAddress);
  if (votingProxyContractAddress != null && votingProxyContractAbi != null) {
    var contract = eth.contract(votingProxyContractAbi).at(votingProxyContractAddress);
    console.log("RESULT: votingProxy.owner=" + contract.owner());
    console.log("RESULT: votingProxy.treasuryContract=" + contract.treasuryContract());
    console.log("RESULT: votingProxy.tokenContract=" + contract.tokenContract());
    console.log("RESULT: votingProxy.currentIncreaseWithdrawalTeamBallot=" + contract.currentIncreaseWithdrawalTeamBallot());
    console.log("RESULT: votingProxy.currentRefundInvestorsBallot=" + contract.currentRefundInvestorsBallot());
  }
}


//-----------------------------------------------------------------------------
// Crowdsale Contract
//-----------------------------------------------------------------------------
var crowdsaleContractAddress = null;
var crowdsaleContractAbi = null;
function addCrowdsaleContractAddressAndAbi(address, abi) {
  crowdsaleContractAddress = address;
  crowdsaleContractAbi = abi;
}
var crowdsaleFromBlock = 0;
function printCrowdsaleContractDetails() {
  console.log("RESULT: crowdsaleContractAddress=" + crowdsaleContractAddress);
  if (crowdsaleContractAddress != null && crowdsaleContractAbi != null) {
    var contract = eth.contract(crowdsaleContractAbi).at(crowdsaleContractAddress);
    // console.log("RESULT: crowdsale.getOwners=" + contract.getOwners());
    console.log("RESULT: crowdsale.token=" + contract.token());
    console.log("RESULT: crowdsale.etherRateUsd=" + contract.etherRateUsd());
    console.log("RESULT: crowdsale.tokenRateUsd=" + contract.tokenRateUsd() + " " + contract.tokenRateUsd().shift(-3) + " USD");
    console.log("RESULT: crowdsale.saleStartDate=" + contract.saleStartDate() + " " + new Date(contract.saleStartDate() * 1000).toUTCString());
    console.log("RESULT: crowdsale.saleEndDate=" + contract.saleEndDate() + " " + new Date(contract.saleEndDate() * 1000).toUTCString());
    console.log("RESULT: crowdsale.teamTokenRatio=" + contract.teamTokenRatio() + " " + contract.teamTokenRatio().shift(-3));
    console.log("RESULT: crowdsale.saleCapUsd=" + contract.saleCapUsd());
    console.log("RESULT: crowdsale.weiRaised=" + contract.weiRaised() + " " + contract.weiRaised().shift(-18) + " ETH");
    console.log("RESULT: crowdsale.isFinalized=" + contract.isFinalized());
    console.log("RESULT: crowdsale.teamTokenWallet=" + contract.teamTokenWallet());
    console.log("RESULT: crowdsale.whitelistedInvestorCounter=" + contract.whitelistedInvestorCounter());
    console.log("RESULT: crowdsale.hourLimitByAddressUsd=" + contract.hourLimitByAddressUsd());
    console.log("RESULT: crowdsale.treasuryContract=" + contract.treasuryContract());
    // console.log("RESULT: crowdsale.getCurrentState()=" + contract.getCurrentState());

    var latestBlock = eth.blockNumber;
    var i;

    var changeReturnEvents = contract.ChangeReturn({}, { fromBlock: crowdsaleFromBlock, toBlock: latestBlock });
    i = 0;
    changeReturnEvents.watch(function (error, result) {
      console.log("RESULT: ChangeReturn " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    changeReturnEvents.stopWatching();

    var tokenPurchaseEvents = contract.TokenPurchase({}, { fromBlock: crowdsaleFromBlock, toBlock: latestBlock });
    i = 0;
    tokenPurchaseEvents.watch(function (error, result) {
      console.log("RESULT: TokenPurchase " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    tokenPurchaseEvents.stopWatching();

   crowdsaleFromBlock = latestBlock + 1;
  }
}