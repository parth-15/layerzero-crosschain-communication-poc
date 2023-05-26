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

interface ILayerZeroReceiver {
    // @notice LayerZero endpoint will invoke this function to deliver the message on the destination
    // @param _srcChainId - the source endpoint identifier
    // @param _srcAddress - the source sending contract address from the source chain
    // @param _nonce - the ordered message nonce
    // @param _payload - the signed payload is the UA bytes has encoded to be sent
    function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) external;
}

//DESTINATION CHAIN CONTRACT = FUJI AVALANCHE TESTNET
contract CounterDest is ILayerZeroReceiver {
    ILayerZeroEndpoint endpoint;
    uint256 public counter;

    constructor() {
        endpoint = ILayerZeroEndpoint(0x93f54D755A063cE7bB9e6Ac47Eccc8e33411d706);
    }

   

    // override from ILayerZeroReceiver.sol
    function lzReceive(uint16 _srcChainId, bytes memory _srcAddress, uint64 _nonce, bytes memory _payload) override external {
        require(msg.sender == address(endpoint));
        // require(keccak256(_srcAddress) == keccak256(trustedRemoteLookup[_srcChainId]);
        // address fromAddress;
        // assembly {
        //     fromAddress := mload(add(_srcAddress, 20))
        // }
        counter += 100;
    }

}


// Deployer: 0x9b94804efaD7202c646df5B2227a6EeF6E0F73dB
// Deployed to: 0x2822b90D08f0b2f791d571fCA92b4A3AFD818fF3
// Transaction hash: 0xb8ba52d55185f44a6eb321710570e66eb861727a6ed9ae57955dda8981e4f2b5