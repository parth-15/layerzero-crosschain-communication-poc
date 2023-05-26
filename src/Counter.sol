// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

interface  ILayerZeroEndpoint {
    // @notice send a LayerZero message to the specified address at a LayerZero endpoint.
    // @param _dstChainId - the destination chain identifier
    // @param _destination - the address on destination chain (in bytes). address length/format may vary by chains
    // @param _payload - a custom bytes payload to send to the destination contract
    // @param _refundAddress - if the source transaction is cheaper than the amount of value passed, refund the additional amount to this address
    // @param _zroPaymentAddress - the address of the ZRO token holder who would pay for the transaction
    // @param _adapterParams - parameters for custom functionality. e.g. receive airdropped native gas from the relayer on destination
    function send(uint16 _dstChainId, bytes calldata _destination, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable; 
}

//SOURCE CHAIN CONTRACT = GOERLI ETHEREUM TESTNET
contract Counter {
    ILayerZeroEndpoint public endpoint;
    uint256 public number;

    constructor() {
        endpoint = ILayerZeroEndpoint(0xbfD2135BFfbb0B5378b56643c2Df8a87552Bfa23);
    }

    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    function increment(address remoteAddress) public payable {
            // remote address concated with local address packed into 40 bytes
            bytes memory remoteAndLocalAddresses = abi.encodePacked(remoteAddress, address(this));
            // call send() to send a message/payload to another chain
            endpoint.send{value:msg.value}(
            10106,                   // destination LayerZero chainId
            remoteAndLocalAddresses, // send to this address on the destination          
            bytes("hello"),          // bytes payload
            payable(msg.sender),              // refund address
            address(0x0),            // future parameter
            bytes("")                // adapterParams (see "Advanced Features")
        );
    }
}

// forge create --rpc-url https://goerli.infura.io/v3/9847152628bd4aa5920716d4174f3d89 --private-key f1b1b9e55b55f9ae8b0053ba16feb7be14afc842de5051b115ced8802453d3b0 src/Counter.sol:Counter

// Deployer: 0x9b94804efaD7202c646df5B2227a6EeF6E0F73dB
// Deployed to: 0x028285D0Ab2bF2D90432A26AB2C4Fc7484bc5e93
// Transaction hash: 0x7dcf43d6499452528d4dacb5d444b0332648346279c4bfc6f77b453e9c2da730

// forge verify-contract --chain-id 10121 --num-of-optimizations 200 --compiler-version v0.8.13+commit.abaa5c0e 0x028285D0Ab2bF2D90432A26AB2C4Fc7484bc5e93 src/Counter.sol:Counter IUT61U3TJ85DCUTZ7EE1CXWMW459ZFWIG7

// Create a makefile to make it easier to load env vars from .env




// 2. add these 2 params in your command `--verify --etherscan-api-key $(SNOWTRACE_API_KEY)`