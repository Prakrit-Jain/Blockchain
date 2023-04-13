// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;
import "./IERC20.sol";

/**
 * @dev Implementation of the IERC20 interface
 */
contract ERC20 is IERC20 {
    /**
     * @notice provides the total no. of tokens in whole network.
     * @return uint , amount of total tokens
     */
    uint256 public totalSupply;

    /**
     * @notice provides name of token.
     * @return string , name of token.
     */
    string public name;

    /**
     * @notice provides symbol of token.
     * @return string , symbol of token.
     */
    string public symbol;

    /**
     * @notice decimals value for the token.
     * @dev Stores the decimal value in bytecode
     */
    uint256 constant decimals = 18;

    /**
     * @notice owner address who owns the contract
     * @dev Address will be assigned through constructor during deploymnet time
     */
    address private _owner;

    /**
     * @notice provides the amount of tokens , the account owned.
     * @dev key - [Address] , value - balance
     * @return uint, returns the balance.
     */
    mapping(address => uint) public balanceOf;

    /**
     * @notice provides the remaining allownace left to be spend by the spender.
     * @dev key [ownerAddress][spenderAddress] , value - remaning tokens
     * @return uint, returns the remaining tokens.
     */
    mapping(address => mapping(address => uint)) public allowance;

    /**
     * @dev Sets the values for {name}, {symbol}, and {amount}.
     * 'amount' no. of tokens is minted to deployer address and added to totalSupply.
     */
    constructor(string memory _name, string memory _symbol, uint256 amount) {
        name = _name;
        symbol = _symbol;
        _owner = msg.sender;
        _mint(amount);
    }

    /**
     * @dev Modifier for checking the only owner address i.e who have deployed the contract.
     */
    modifier onlyOwner() {
        require(msg.sender == _owner, "Not a owner");
        _;
    }

    /**
     * @notice  Moves 'amount' of tokens from the callers account to (account 'to')
     * @dev Moves 'amount' of tokens from the callers account to (account 'to') , here
     * to cannot be the zero address and senders account should have enough balance to transfer
     * @param to The address of the recipient.
     * @param amount The amount of tokens to transfer.
     * @return bool, Returns a boolean value indicating whether the operation succeeded or not.
     */
    function transfer(address to, uint256 amount) external returns (bool) {
        require(to != address(0), "Transfer to Zero Address");
        uint256 _balance = balanceOf[msg.sender];
        require(_balance >= amount, "No Sufficient Balance");
        balanceOf[msg.sender] =_balance - amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * @notice Approves the amount of Token to 'spender' account to spend on
     * behalf of the callers account.
     * @dev Transaction reverts if the spender is zero address.
     * @param spender The address of the spender whosesoever needs to spend token.
     * @param amount  The amount of tokens to be approved.
     * @return bool, Returns a boolean value indicating whether the operation succeeded or not.
     */
    function approve(address spender, uint256 amount) external returns (bool) {
        require(spender != address(0), "spender cannot be the zero address.");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice Transfers `amount` tokens from the (account `from`) to the (account `to`),
     * if the caller has been approved by `from` to spend `amount` tokens on their behalf.
     * @dev Transaction reverts if 'from' and 'to' addresses are the zero address, or if `from` 
     * does not have enough tokens to make the transfer, or if the caller's allowance is insufficient.
     * @param from The address of the account to transfer tokens from.
     * @param to The address of the account to transfer tokens to.
     * @param amount The amount of tokens to transfer.
     * @return bool, Returns a boolean value indicating whether the operation succeeded or not..
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(from != address(0), "Transfer from Zero Address");
        require(to != address(0), "Transfer to Zero Address");
        require(from != to, "Same address Transfers");
        uint256 _allownace = allowance[from][msg.sender];
        require(_allownace >= amount, "Not Enough Allowance");
        require(balanceOf[from] >= amount, "Not enough balance in owners account");
        if ( _allownace != type(uint256).max) {
            balanceOf[from] -= amount;
            balanceOf[to] += amount;
            allowance[from][msg.sender] = _allownace - amount;
            emit Approval(from, msg.sender, _allownace - amount);
        }   
        emit Transfer(from, to, amount);
        return true;
    }

    /**
     * @dev This function is private and can only be called by the contract itself.
     * @param amount The amount of tokens to be mint.
     * @return bool `true` if the minting was successful.
     */
    function _mint(uint256 amount) private returns (bool) {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
        return true;
    }

    /**
     * @notice Mints new tokens and adds them to the balance of the contract owner's account.
     * @dev Reverts if the caller is not the contract owner.
     * @param amount The amount of tokens to mint.
     * @return bool `true` if the minting was successful.
     */
    function mint(uint256 amount) external onlyOwner returns (bool) {
        _mint(amount);
        return true;
    }

    /**
     * @notice Burns a specified amount of tokens from the owner's balance.
     * @dev Reverts if the amount exceeds msg.sender balance is not the contract owner
     * @param amount The amount of tokens to be burned.
     * @return bool A boolean indicating whether the burn operation was successful.
     */
    function burn(uint256 amount) external onlyOwner returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Burn amount exceeds balance");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
        return true;
    }

    /**
     *@dev Allows the current owner to temporarily transfer ownership to a new address.
     *@param tempOwner The address to which ownership will be temporarily transferred.
     *@return bool Returns a boolean value indicating whether the operation succeeded or not.
     */
    function temporaryOwner(address tempOwner) external onlyOwner returns (bool) {
        require(tempOwner != address(0), "Ownership can't be transfered to zero address");
        _owner = tempOwner;
        return true;
    }
}
