// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EOC is ERC20, Ownable {

    
    mapping(address => uint256) private _stakes;
    mapping(address => uint256) private stakeTimeStamp;
    uint256 private _rewardRate = 5 ;
    uint256 private Locking = 15;
    
    constructor(address initialOwner) 
        ERC20("EntranceOnlyCoin", "EOC") 
        Ownable(initialOwner)
    {}
    
        
    
    function minting(address to, uint256 amount) public {
        uint256 weiConvert = amount * (10**(18));
        _mint(to, weiConvert);
    }

    function staking(uint256 amount) public {

        uint256 weiConvert = amount * (10**(18));

        require(weiConvert > 0, "Cannot stake 0 tokens");
        require(balanceOf(msg.sender) >= weiConvert, "Insufficient balance");

        _stakes[msg.sender] += weiConvert;

        stakeTimeStamp[msg.sender] = block.timestamp;
        _transfer(msg.sender, address(this), weiConvert);
  }


    function withdraw() public {
        require(block.timestamp > (stakeTimeStamp[msg.sender] + Locking), "YOU ARE IN LOCK PERIOD");
        require(_stakes[msg.sender] > 0, "Stake Tokens First");

        uint256 stakedAmount = _stakes[msg.sender];
        uint256 reward = ((block.timestamp - stakeTimeStamp[msg.sender]) * _rewardRate) * (10**(18));

        _stakes[msg.sender] = 0;
        _transfer(address(this), msg.sender, stakedAmount);
        _mint(msg.sender, reward);
  }

    
}