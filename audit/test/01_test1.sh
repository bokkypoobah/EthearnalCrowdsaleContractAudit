#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

SOURCEDIR=`grep ^SOURCEDIR= settings.txt | sed "s/^.*=//"`

TOKENSOL=`grep ^TOKENSOL= settings.txt | sed "s/^.*=//"`
TOKENJS=`grep ^TOKENJS= settings.txt | sed "s/^.*=//"`
TREASURYSOL=`grep ^TREASURYSOL= settings.txt | sed "s/^.*=//"`
TREASURYJS=`grep ^TREASURYJS= settings.txt | sed "s/^.*=//"`
VOTINGPROXYSOL=`grep ^VOTINGPROXYSOL= settings.txt | sed "s/^.*=//"`
VOTINGPROXYJS=`grep ^VOTINGPROXYJS= settings.txt | sed "s/^.*=//"`
CROWDSALESOL=`grep ^CROWDSALESOL= settings.txt | sed "s/^.*=//"`
CROWDSALEJS=`grep ^CROWDSALEJS= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`

START_DATE=`echo "$CURRENTTIME+75" | bc`
START_DATE_S=`date -r $START_DATE -u`
END_DATE=`echo "$CURRENTTIME+90" | bc`
END_DATE_S=`date -r $END_DATE -u`

printf "MODE               = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT    = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD           = '$PASSWORD'\n" | tee -a $TEST1OUTPUT
printf "SOURCEDIR          = '$SOURCEDIR'\n" | tee -a $TEST1OUTPUT
printf "TOKENSOL           = '$TOKENSOL'\n" | tee -a $TEST1OUTPUT
printf "TOKENJS            = '$TOKENJS'\n" | tee -a $TEST1OUTPUT
printf "TREASURYSOL        = '$TREASURYSOL'\n" | tee -a $TEST1OUTPUT
printf "TREASURYJS         = '$TREASURYJS'\n" | tee -a $TEST1OUTPUT
printf "VOTINGPROXYSOL     = '$VOTINGPROXYSOL'\n" | tee -a $TEST1OUTPUT
printf "VOTINGPROXYJS      = '$VOTINGPROXYJS'\n" | tee -a $TEST1OUTPUT
printf "CROWDSALESOL       = '$CROWDSALESOL'\n" | tee -a $TEST1OUTPUT
printf "CROWDSALEJS        = '$CROWDSALEJS'\n" | tee -a $TEST1OUTPUT
printf "DEPLOYMENTDATA     = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS          = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT        = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS       = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT
printf "CURRENTTIME        = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "START_DATE         = '$START_DATE' '$START_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "END_DATE           = '$END_DATE' '$END_DATE_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
# `cp modifiedContracts/SnipCoin.sol .`
`cp -rp $SOURCEDIR/* .`
`cp -rp ../zeppelin-contracts/* .`

# --- Modify parameters ---
`perl -pi -e "s/zeppelin-solidity\/contracts\///" *.sol`
`perl -pi -e "s/saleStartDate \= 1510416000;.*$/saleStartDate \= $START_DATE; \/\/ $START_DATE_S/" $CROWDSALESOL`
`perl -pi -e "s/saleEndDate \= 1513008000;.*$/saleEndDate \= $END_DATE; \/\/ $END_DATE_S/" $CROWDSALESOL`
`perl -pi -e "s/getOwners\(\) public returns/getOwners\(\) public constant returns/" $TREASURYSOL`
`perl -pi -e "s/uint256 etherRateUsd/uint256 public etherRateUsd/" $CROWDSALESOL`

for FILE in Ballot.sol EthearnalRepTokenCrowdsale.sol LockableToken.sol MultiOwnable.sol Treasury.sol EthearnalRepToken.sol IBallot.sol RefundInvestorsBallot.sol VotingProxy.sol
do
  DIFFS1=`diff $SOURCEDIR/$FILE $FILE`
  echo "--- Differences $SOURCEDIR/$FILE $FILE ---" | tee -a $TEST1OUTPUT
  echo "$DIFFS1" | tee -a $TEST1OUTPUT
done

solc_0.4.16 --version | tee -a $TEST1OUTPUT

# --pretty-json does not work with 0.4.16
echo "var tokenOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $TOKENSOL`;" > $TOKENJS
echo "var treasuryOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $TREASURYSOL`;" > $TREASURYJS
echo "var votingProxyOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $VOTINGPROXYSOL`;" > $VOTINGPROXYJS
echo "var crowdsaleOutput=`solc_0.4.16 --optimize --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS

geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("$TREASURYJS");
loadScript("$VOTINGPROXYJS");
loadScript("$CROWDSALEJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:EthearnalRepToken"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:EthearnalRepToken"].bin;
var treasuryAbi = JSON.parse(treasuryOutput.contracts["$TREASURYSOL:Treasury"].abi);
var treasuryBin = "0x" + treasuryOutput.contracts["$TREASURYSOL:Treasury"].bin;
var votingProxyAbi = JSON.parse(votingProxyOutput.contracts["$VOTINGPROXYSOL:VotingProxy"].abi);
var votingProxyBin = "0x" + votingProxyOutput.contracts["$VOTINGPROXYSOL:VotingProxy"].bin;
var crowdsaleAbi = JSON.parse(crowdsaleOutput.contracts["$CROWDSALESOL:EthearnalRepTokenCrowdsale"].abi);
var crowdsaleBin = "0x" + crowdsaleOutput.contracts["$CROWDSALESOL:EthearnalRepTokenCrowdsale"].bin;

// console.log("DATA: tokenAbi=" + JSON.stringify(tokenAbi));
// console.log("DATA: tokenBin=" + JSON.stringify(tokenBin));
// console.log("DATA: treasuryAbi=" + JSON.stringify(treasuryAbi));
// console.log("DATA: treasuryBin=" + JSON.stringify(treasuryBin));
// console.log("DATA: votingProxyAbi=" + JSON.stringify(votingProxyAbi));
// console.log("DATA: votingProxyBin=" + JSON.stringify(votingProxyBin));
// console.log("DATA: crowdsaleAbi=" + JSON.stringify(crowdsaleAbi));
// console.log("DATA: crowdsaleBin=" + JSON.stringify(crowdsaleBin));


unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var tokenMessage = "Deploy Token Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + tokenMessage + " ---");
var tokenContract = web3.eth.contract(tokenAbi);
// console.log(JSON.stringify(tokenContract));
var tokenTx = null;
var tokenAddress = null;
var token = tokenContract.new({from: contractOwnerAccount, data: tokenBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        console.log("DATA: tokenAddress=" + tokenAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(tokenTx, tokenMessage);
printTxData("tokenAddress=" + tokenAddress, tokenTx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var treasuryMessage = "Deploy Treasury Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + treasuryMessage + " ---");
var treasuryContract = web3.eth.contract(treasuryAbi);
// console.log(JSON.stringify(treasuryContract));
var treasuryTx = null;
var treasuryAddress = null;
var treasury = treasuryContract.new(teamWallet, {from: contractOwnerAccount, data: treasuryBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        treasuryTx = contract.transactionHash;
      } else {
        treasuryAddress = contract.address;
        addAccount(treasuryAddress, "Treasury");
        addTreasuryContractAddressAndAbi(treasuryAddress, treasuryAbi);
        console.log("DATA: treasuryAddress=" + treasuryAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(treasuryTx, treasuryMessage);
printTxData("treasuryAddress=" + treasuryAddress, treasuryTx);
printTreasuryContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var votingProxyMessage = "Deploy Voting Proxy Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + votingProxyMessage + " ---");
var votingProxyContract = web3.eth.contract(votingProxyAbi);
// console.log(JSON.stringify(votingProxyContract));
var votingProxyTx = null;
var votingProxyAddress = null;
var votingProxy = votingProxyContract.new(treasuryAddress, tokenAddress, {from: contractOwnerAccount, data: votingProxyBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        votingProxyTx = contract.transactionHash;
      } else {
        votingProxyAddress = contract.address;
        addAccount(votingProxyAddress, "VotingProxy");
        addVotingProxyContractAddressAndAbi(votingProxyAddress, votingProxyAbi);
        console.log("DATA: votingProxyAddress=" + votingProxyAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("votingProxyAddress=" + votingProxyAddress, votingProxyTx);
failIfTxStatusError(votingProxyTx, votingProxyMessage);
printVotingProxyContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var setupTreasury1_Message = "Setup Treasury #1";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + setupTreasury1_Message + " ---");
var setupTreasury1_1Tx = treasury.setupOwners([owner1, owner2], {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var setupTreasury1_2Tx = treasury.setTokenContract(tokenAddress, {from: owner1, gas: 400000, gasPrice: defaultGasPrice});
var setupTreasury1_3Tx = treasury.setVotingProxy(votingProxyAddress, {from: owner2, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(setupTreasury1_1Tx, setupTreasury1_Message + " - treasury.setupOwners([owner1, owner2])");
failIfTxStatusError(setupTreasury1_2Tx, setupTreasury1_Message + " - treasury.setTokenContract(token)");
failIfTxStatusError(setupTreasury1_3Tx, setupTreasury1_Message + " - treasury.setVotingProxy(votingProxy)");
printTxData("setupTreasury1_1Tx", setupTreasury1_1Tx);
printTxData("setupTreasury1_2Tx", setupTreasury1_2Tx);
printTxData("setupTreasury1_3Tx", setupTreasury1_3Tx);
printTreasuryContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var crowdsaleMessage = "Deploy Crowdsale Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + crowdsaleMessage + " ---");
var crowdsaleContract = web3.eth.contract(crowdsaleAbi);
// console.log(JSON.stringify(crowdsaleContract));
var crowdsaleTx = null;
var crowdsaleAddress = null;
var crowdsale = crowdsaleContract.new([owner1, owner2], treasuryAddress, teamWallet, {from: contractOwnerAccount, data: crowdsaleBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        crowdsaleTx = contract.transactionHash;
      } else {
        crowdsaleAddress = contract.address;
        addAccount(crowdsaleAddress, "Crowdsale");
        addCrowdsaleContractAddressAndAbi(crowdsaleAddress, crowdsaleAbi);
        console.log("DATA: crowdsaleAddress=" + crowdsaleAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(crowdsaleTx, crowdsaleMessage);
printTxData("crowdsaleAddress=" + crowdsaleAddress, crowdsaleTx);
printCrowdsaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var setup2_Message = "Setup #2";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + setup2_Message + " ---");
var setup2_1Tx = treasury.setCrowdsaleContract(crowdsaleAddress, {from: owner1, gas: 400000, gasPrice: defaultGasPrice});
var setup2_2Tx = token.transferOwnership(crowdsaleAddress, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var setup2_3Tx = crowdsale.setTokenContract(tokenAddress, {from: owner1, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(setup2_1Tx, setup2_Message + " - treasury.setCrowdsaleContract(crowdsale)");
failIfTxStatusError(setup2_2Tx, setup2_Message + " - token.transferOwnership(crowdsale)");
failIfTxStatusError(setup2_3Tx, setup2_Message + " - crowdsale.setTokenContract(token)");
printTxData("setup2_1Tx", setup2_1Tx);
printTxData("setup2_2Tx", setup2_2Tx);
printTxData("setup2_3Tx", setup2_3Tx);
printTreasuryContractDetails();
console.log("RESULT: ");


waitUntil("crowdsale.saleStartDate()", crowdsale.saleStartDate(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: tokenAddress, gas: 400000, value: web3.toWei("100.01", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac3 100 ETH");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac4 100 ETH");
failIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " - ac5 100 ETH");
failIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " - ac5 100 ETH");
printCrowdsaleContractDetails();
printTreasuryContractDetails();
printTokenContractDetails();
console.log("RESULT: ");




exit;

// -----------------------------------------------------------------------------
var deployLibraryMessage = "Deploy SafeMath Library";
// -----------------------------------------------------------------------------
console.log("RESULT: " + deployLibraryMessage);
var libContract = web3.eth.contract(libAbi);
var libTx = null;
var libAddress = null;
var lib = libContract.new({from: contractOwnerAccount, data: libBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        libTx = contract.transactionHash;
      } else {
        libAddress = contract.address;
        addAccount(libAddress, "Lib SafeMath");
        console.log("DATA: libAddress=" + libAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("libAddress=" + libAddress, libTx);
failIfTxStatusError(libTx, deployLibraryMessage);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var tokenMessage = "Deploy Crowdsale/Token Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: " + tokenMessage);
// console.log("RESULT: old='" + tokenBin + "'");
var newTokenBin = tokenBin.replace(/__GizerTokenPresale\.sol\:SafeMath________/g, libAddress.substring(2, 42));
// console.log("RESULT: new='" + newTokenBin + "'");
var tokenContract = web3.eth.contract(tokenAbi);
// console.log(JSON.stringify(tokenContract));
var tokenTx = null;
var tokenAddress = null;
var token = tokenContract.new({from: contractOwnerAccount, data: newTokenBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        console.log("DATA: tokenAddress=" + tokenAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("tokenAddress=" + tokenAddress, tokenTx);
failIfTxStatusError(tokenTx, tokenMessage);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var setupMessage = "Setup";
// -----------------------------------------------------------------------------
console.log("RESULT: " + setupMessage);
var setup1Tx = token.setWallet(wallet, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
var setup2Tx = token.setRedemptionWallet(redemptionWallet, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("setup1Tx", setup1Tx);
printTxData("setup2Tx", setup2Tx);
failIfTxStatusError(setup1Tx, setupMessage + " - setWallet(...)");
failIfTxStatusError(setup2Tx, setupMessage + " - setRedemptionWallet(...)");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var sendPrivateSaleContrib1Message = "Send Private Sale Contribution";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendPrivateSaleContrib1Message);
var sendPrivateSaleContrib1_1Tx = token.privateSaleContribution(account3, web3.toWei("100", "ether"), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
var sendPrivateSaleContrib1_2Tx = token.privateSaleContribution(account4, web3.toWei("200", "ether"), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("sendPrivateSaleContrib1_1Tx", sendPrivateSaleContrib1_1Tx);
printTxData("sendPrivateSaleContrib1_2Tx", sendPrivateSaleContrib1_2Tx);
failIfTxStatusError(sendPrivateSaleContrib1_1Tx, sendPrivateSaleContrib1Message + " - ac3 100 ETH");
failIfTxStatusError(sendPrivateSaleContrib1_2Tx, sendPrivateSaleContrib1Message + " - ac4 200 ETH");
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("DATE_PRESALE_START", token.DATE_PRESALE_START(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution In Presale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: tokenAddress, gas: 400000, value: web3.toWei("100.01", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac3 100 ETH");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac4 100 ETH");
failIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " - ac5 100 ETH");
passIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " - ac5 100.01 ETH - Expecting failure as over the contrib limit");
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("DATE_PRESALE_END", token.DATE_PRESALE_END(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution After Presale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: tokenAddress, gas: 400000, value: web3.toWei("1", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
passIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac3 1 ETH - Expecting failure as sale over");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveToken1_Message = "Move Tokens After Presale - To Redemption Wallet";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveToken1_Message);
var moveToken1_1Tx = token.transfer(redemptionWallet, "1000000", {from: account3, gas: 100000});
var moveToken1_2Tx = token.approve(account6,  "30000000", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken1_3Tx = token.transferFrom(account4, redemptionWallet, "30000000", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("moveToken1_1Tx", moveToken1_1Tx);
printTxData("moveToken1_2Tx", moveToken1_2Tx);
printTxData("moveToken1_3Tx", moveToken1_3Tx);
failIfTxStatusError(moveToken1_1Tx, moveToken1_Message + " - transfer 1 token ac3 -> redemptionWallet. CHECK for movement");
failIfTxStatusError(moveToken1_2Tx, moveToken1_Message + " - approve 30 tokens ac4 -> ac6");
failIfTxStatusError(moveToken1_3Tx, moveToken1_Message + " - transferFrom 30 tokens ac4 -> redemptionWallet by ac6. CHECK for movement");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveToken2_Message = "Move Tokens After Presale - Not To Redemption Wallet";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveToken2_Message);
var moveToken2_1Tx = token.transfer(account5, "1000000", {from: account3, gas: 100000});
var moveToken2_2Tx = token.approve(account6,  "30000000", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken2_3Tx = token.transferFrom(account4, account7, "30000000", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("moveToken2_1Tx", moveToken2_1Tx);
printTxData("moveToken2_2Tx", moveToken2_2Tx);
printTxData("moveToken2_3Tx", moveToken2_3Tx);
passIfTxStatusError(moveToken2_1Tx, moveToken2_Message + " - transfer 1 token ac3 -> ac5. Expecting failure");
failIfTxStatusError(moveToken2_2Tx, moveToken2_Message + " - approve 30 tokens ac4 -> ac6");
passIfTxStatusError(moveToken2_3Tx, moveToken2_Message + " - transferFrom 30 tokens ac4 -> ac7 by ac6. Expecting failure");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var freezeMessage = "Freeze Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + freezeMessage);
var freeze1Tx = token.freezeTokens({from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("freeze1Tx", freeze1Tx);
failIfTxStatusError(freeze1Tx, freezeMessage + " - freezeTokens()");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveToken3_Message = "Move Tokens After Presale - To Redemption Wallet";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveToken3_Message);
var moveToken3_1Tx = token.transfer(redemptionWallet, "1000000", {from: account3, gas: 100000});
var moveToken3_2Tx = token.approve(account6,  "30000000", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken3_3Tx = token.transferFrom(account4, redemptionWallet, "30000000", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("moveToken3_1Tx", moveToken3_1Tx);
printTxData("moveToken3_2Tx", moveToken3_2Tx);
printTxData("moveToken3_3Tx", moveToken3_3Tx);
passIfTxStatusError(moveToken3_1Tx, moveToken3_Message + " - transfer 1 token ac3 -> redemptionWallet. Expecting failure as tokens frozen");
failIfTxStatusError(moveToken3_2Tx, moveToken3_Message + " - approve 30 tokens ac4 -> ac6");
passIfTxStatusError(moveToken3_3Tx, moveToken3_Message + " - transferFrom 30 tokens ac4 -> redemptionWallet by ac6. Expecting failure as tokens frozen");
printTokenContractDetails();
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
