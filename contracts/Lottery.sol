pragma solidity ^0.4.17;

contract Lottery {
    address public manager;
    address[] public players;

    function Lottery() public {
        manager = msg.sender;
    }
    
    function enter() public payable {
        // Some requirement needs to be satisfied before executing the following code, msg.value stores the value in wei
        // Using require we can do early validation
        require(msg.value > .01 ether);

        players.push(msg.sender);
    }
    

    function random() private view returns(uint) {
        return uint(sha3(block.difficulty, now, players));
    }


    // pickWinner function has to find the restricted modifier
    function pickWinner() public restricted {
        // Only manager can pick the winner
        // require (msg.sender == manager);

        uint index = random() % players.length;
        // this is the instance of the current contract
        players[index].transfer(this.balance);
        players = new address[](0);
    }
    
    // Function modifier are used to reduce the amount of code.
    modifier restricted() {
        // Only manager can pick the winner
        require(msg.sender == manager);
        // The underscore places all the code of pickWinner function below require statement.
        _;
    }

    // View defines that this function is not going to change any data in the contract.
    function getPlayers() public view returns(address[]) {
        return players;
    }

}