 // SPDX-License-Identifier: GPL-3.0

 pragma solidity >=0.5.0 <0.9.0;

 contract Lottery{
     address payable[] public players;
     address public manager;

     constructor(){
        manager = msg.sender;
     }
   
   // declaring the receive() function that is necessary to receive ETH
     receive() external payable {
         require(msg.value == 0.1 ether);
         players.push(payable(msg.sender));
     }
 
    // returning the contract's balance in wei
     function getBalance() public view returns(uint){
         require(msg.sender == manager);
         return address(this).balance;
     }
     
     // helper function that returns a big random integer
     function random() public view returns(uint){
         return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp,players.length)));
     }

     function pickWinner() public{
         require(msg.sender == manager);
         require(players.length >= 3);

         uint r = random();
         address payable winner;

         uint index = r % players.length;
         winner = players[index];
         
         winner.transfer(getBalance());
         players = new address payable[](0); // resetting the lottery

     }

 }