// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
// import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
// import "hardhat/console.sol";

Raffle_NotEnoughETHEntered();

contract Raffle is VRFConsumerBaseV2{
    /* State Variables*/
    uint256 private immutable i_enteranceFee;
    address payable[] private  s_players;

    /* Events */
    event RaffleEnter(address indexed player);

    constructor(address vrfCoordinatorV2,uint256 enteranceFee) {
        i_enteranceFee = enteranceFee;
    } VRFConsumerBaseV2(vrfCoordinatorV2) {
        // i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        // i_gasLane = gasLane;
        // i_interval = interval;
        // i_subscriptionId = subscriptionId;
        // i_entranceFee = entranceFee;
        // s_raffleState = RaffleState.OPEN;
        // s_lastTimeStamp = block.timestamp;
        // i_callbackGasLimit = callbackGasLimit;
    }


    function enterRaffle() public payable{
        if (msg.value < i_enteranceFee) {
            revert Raffle_NotEnoughETHEntered();
        }
        s_players.push(payable(msg.sender));

        //Emit event when s_players is updated
        emit RaffleEnter(msg.sender);
    }

    function requestRandomWinner() external {

    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) 
        internal 
        override
    {
        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable recentWinner = s_players[indexOfWinner];
        s_recentWinner = recentWinner;
        s_players = new address payable[](0);
        s_raffleState = RaffleState.OPEN;
        s_lastTimeStamp = block.timestamp;
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        // require(success, "Transfer failed");
        if (!success) {
            revert Raffle__TransferFailed();
        }
        emit WinnerPicked(recentWinner);
    }

    
    /*  View / Pure Functions */
    function getEnteranceFee() public view returns (uint256) {
        return i_enteranceFee;
    }


    function getPlayers(uint256 index) public view returns (address){
        return s_players[index];
    }
}
