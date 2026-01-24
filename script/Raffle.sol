//SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title A sample Raffle contract
 * @author Hassan Ahmed
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2.5
 */

abstract contract Raffle is VRFConsumerBaseV2Plus {
    /* Errors */
    error Raffle__SendMoreToEnterRaffle();
    //     ^^^ good practise, place contract name before error

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    uint256 private immutable I_ENTRANCEFEE;
    address payable[] private s_players;
    // @ Duration of lottery (seconds)
    uint256 private immutable I_INTERVAL;
    uint256 private s_lastTimeStamp;
    bytes32 private i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    /**Events */
    event RaffleEntered(address indexed player);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 calbackGasLimit
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        I_ENTRANCEFEE = entranceFee;
        I_INTERVAL = interval;
        s_lastTimeStamp = block.timestamp;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = calbackGasLimit;
    }

    function enterRaffle() external payable {
        // require(msg.value >= I_ENTRANCEFEE, "Not enough ETH sent!");

        //require(msg.value >= I_ENTRANCEFEE, SendMoreToEnterRaffle()); << Only ^0.8.26

        if (msg.value < I_ENTRANCEFEE) {
            //Still most gas efficient way
            revert Raffle__SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));

        emit RaffleEntered(msg.sender);
    }

    function pickWinner() external {
        if ((block.timestamp - s_lastTimeStamp) < I_INTERVAL) {
            revert();
        }
        // Getting random num from chainlink is a 2 tx process:
        // 1. Request RNG
        // 2. Get RNG

        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: i_callbackGasLimit,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            });

        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);
    }

    function getEntranceFee() external view returns (uint256) {
        return I_ENTRANCEFEE;
    }
}
