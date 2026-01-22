//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @title A sample Raffle contract
 * @author Hassan Ahmed
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */

contract Raffle {
    /* Errors */
    error Raffle__SendMoreToEnterRaffle();
    //     ^^^ good practise, place contract name before error

    uint256 private immutable I_ENTRANCEFEE;
    address payable[] private s_players;

    /**Events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee) {
        I_ENTRANCEFEE = entranceFee;
    }

    function enterRaffle() public payable {
        // require(msg.value >= I_ENTRANCEFEE, "Not enough ETH sent!");

        //require(msg.value >= I_ENTRANCEFEE, SendMoreToEnterRaffle()); << Only ^0.8.26

        if (msg.value < I_ENTRANCEFEE) {
            //Still most gas efficient way
            revert Raffle__SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));

        emit RaffleEntered(msg.sender);
    }

    function pickWinner() public {}

    function getEntranceFee() external view returns (uint256) {
        return I_ENTRANCEFEE;
    }
}
