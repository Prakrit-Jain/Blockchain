// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;
import "./IERC20.sol";

contract ERC20 is IERC20 {
    uint256 public totalSupply;
    string public name;
    string public symbol;
    uint8 constant decimals = 18;
    address private owner; 
    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;
    
    constructor(string memory _name, string memory _symbol, uint256 amount) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        _mint(amount);
    }

    modifier onlyOwner {
        require (msg.sender == owner, "Not a owner");
        _;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), 'Transfer to Zero Address');
        require(balanceOf[msg.sender] >= amount, "No Sufficient Balance");
        balanceOf[to] += amount;
        balanceOf[msg.sender] -= amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), 'spender cannot be the zero address.');
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(from != address(0), 'Transfer from Zero Address');
        require(to != address(0), 'Transfer to Zero Address');
        require(from != to, "Same address Transfers");
        uint256 _allownace = allowance[from][msg.sender];
        require(_allownace >= amount, "Not Enough Allowance");
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        allowance[from][msg.sender] =_allownace - amount;
        emit Approval(from, msg.sender, amount);
        emit Transfer(from, to, amount);
        return true;
    }

    function _mint(uint256 amount) private returns (bool) {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
        return true;
    }

    function mint(uint256 amount) external onlyOwner returns (bool) {
        _mint(amount);
        return true;
    }

}