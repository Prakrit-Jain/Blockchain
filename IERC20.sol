// SPDX-License-Identifier: MIT
pragma solidity =0.8.19;

/** 
 * @dev Interface for the ERC20 token standard as defined in EIP
 */

interface IERC20 {
    /**
     *@dev Event Emmited when 'value' amount of tokens are moved from (account 'from') 
     * to (account 'to')
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     *@dev Event Emmited when 'value' amount of tokens are approved using approve function call by (account 'owner') 
     * to (account 'spender')
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
     /**
     * @dev Returns the amount of total no. of tokens in whole network.
     */
    function totalSupply() external view returns (uint256);

    /** 
     * @dev Returns the amount of tokens , the account owned.
    */
    function balanceOf(address account) external view returns (uint256);

    /** 
     * @dev Moves 'amount' of tokens from the callers account
     * to (account 'to')
     * 
     * Emits a {Transfer} event.
    */
    function transfer(address to, uint256 amount) external returns (bool);

    /** 
     * @dev Returns the remaining number of tokens 'spender' have to spend on behalf 
     * of 'owner' account.
    */
    function allowance(address owner, address spender) external view returns (uint256);

    /** 
     * @dev Approves the amount of Token to 'spender' account to spend on 
     * behalf of the callers account.
     * 
     * Emits an {Approval} event. 
    */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves number of `amount` tokens from (account `from`) to (account `to`) using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}