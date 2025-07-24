// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract TokenSwap {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;
    
    // A to B rate : example 1 A = 2 B → swapRate = 2
    uint256 public swapRate;

    event Swapped(address indexed user, uint256 amountA, uint256 amountB);
    event TokenBDeposited(address indexed sender, uint256 amount);
    event SwapRateChanged(uint256 oldRate, uint256 newRate);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(address _tokenA, address _tokenB, uint256 _swapRate) {
        require(_tokenA != _tokenB, "Tokens must differ");
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        swapRate = _swapRate;
        owner = msg.sender;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function getAllowance(address user) external view returns (uint256) {
        return tokenA.allowance(user, address(this));
    }

    function getAvailableA() external view returns (uint256) {
        return tokenA.balanceOf(address(this));
    }

    function getAvailableB() external view returns (uint256) {
        return tokenB.balanceOf(address(this));
    }

    function depositTokenB(uint256 amountB) external onlyOwner {
        require(amountB > 0, "Amount must be > 0");
        require(tokenB.transferFrom(msg.sender, address(this), amountB), "Token B deposit failed");

        emit TokenBDeposited(msg.sender, amountB);
    }
    
    function setSwapRate(uint256 newRate) external onlyOwner {
        require(newRate > 0, "Rate must be > 0");
        emit SwapRateChanged(swapRate, newRate);
        swapRate = newRate;
    }

    function swapAToB(uint256 amountA) external {
        require(amountA > 0, "Amount must be > 0");

        // Overflow safe since Solidity 0.8+ checks automatically
        uint256 amountB = amountA * swapRate;
        uint256 availableB = tokenB.balanceOf(address(this));
        require(availableB >= amountB, "Not enough token B in contract");

        // Receive Token A from User
        require(tokenA.transferFrom(msg.sender, address(this), amountA), "Token A transfer failed");

        // Pay Token B to User
        require(tokenB.transfer(msg.sender, amountB), "Token B transfer failed");

        emit Swapped(msg.sender, amountA, amountB);
    }

    function withdrawToken(address tokenAddress, uint256 amount) external onlyOwner {
        require(tokenAddress != address(0), "Zero address");
        IERC20 token = IERC20(tokenAddress);
        require(token.transfer(msg.sender, amount), "Withdraw failed");
    }
}
