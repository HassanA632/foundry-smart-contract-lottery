//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/** 
 * @title A sample Raffle contract
 * @author Hassan Ahmed
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
*/

contract Raffle{
    uint256 private immutable I_ENTRANCEFEE;

    constructor(uint256 entranceFee) {
        I_ENTRANCEFEE = entranceFee;
    }

    function enterRaffle()public payable {
        
    }

    function pickWinner()public {}

    function getEntranceFee()external view returns(uint256){
        return I_ENTRANCEFEE;
    }


}