// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

Raffle_NotEnoughETHEntered();

contract Raffle {
    /* State Variables*/
    uint256 private immutable i_enteranceFee;
    address payable[] private  s_players;

    constructor(uint256 enteranceFee) {
        i_enteranceFee = enteranceFee;
    }

    function getEnteranceFee() public view returns (uint256) {
        return i_enteranceFee;
    }

    function enterRaffle() public payable{
        if (msg.value < i_enteranceFee) {
            revert Raffle_NotEnoughETHEntered();
        }
        s_players.push(payable(msg.sender));
    }

    function getPlayers(uint256 index) public view returns (address){
        return s_players[index];
    }

    //function pickRandomWinner() {}
}
