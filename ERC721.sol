// SPDX-License-Identifier: MIT
pragma solidity =0.8.18;

import "./IERC721.sol";
import "./IERC721Receiver.sol";

contract ERC721 is IERC721 {

    string private _name;
    string private _symbol;
    mapping(address => uint) public balanceOf;
    mapping(uint => address) public ownerOf;
    mapping(address => mapping(address => bool)) private _approveAll;
    mapping(uint => address) private _approve;

    constructor (string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata data
    ) external payable {
        require(ownerOf[_tokenId] == _from, "Owner not verified");
        require(_to != address(0), "to cannot be zero address");
        require(_from == msg.sender || _approveAll[_from][msg.sender] == true || _approve[_tokenId] == _from, "Not authorized to transfer");
        delete _approve[_tokenId];
        balanceOf[_from]--;
        balanceOf[_to]++;
        ownerOf[_tokenId] = _to;
        require(_checkOnERC721Received(_from, _to, _tokenId, data), "transfer to non ERC721Receiver implementer"); 
        emit Transfer(_from, _to, _tokenId);

    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(ownerOf[_tokenId] == _from, "Owner not verified");
        require(_to != address(0), "to cannot be zero address");
        require(_from == msg.sender || _approveAll[_from][msg.sender] == true || _approve[_tokenId] == _from, "Not authorized to transfer");
        delete _approve[_tokenId];
        balanceOf[_from]--;
        balanceOf[_to]++;
        ownerOf[_tokenId] = _to;
        require(_checkOnERC721Received(_from, _to, _tokenId, ""), "transfer to non ERC721Receiver implementer"); 
        emit Transfer(_from, _to, _tokenId);  
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
        require(ownerOf[_tokenId] == _from, "Owner not verified");
        require(_to != address(0), "to cannot be zero address");
        require(_from == msg.sender || _approveAll[_from][msg.sender] == true || _approve[_tokenId] == _from, "Not authorized to transfer");
        delete _approve[_tokenId];
        balanceOf[_from]--;
        balanceOf[_to]++;
        ownerOf[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external payable {
        address currentOwner = ownerOf[_tokenId];
        require(_approved != currentOwner, "approval to current owner");
        require(msg.sender == currentOwner || _approveAll[currentOwner][msg.sender] == true, "Not Authorized to approve");
        _approve[_tokenId] = _approved;
        emit Approval(currentOwner, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(msg.sender != _operator, "approve to caller");
        _approveAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        require(ownerOf[_tokenId] != address(0), "invalid token");
        return _approve[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return _approveAll[_owner][_operator];
    }

    function isContract(address addr) private view returns (bool) {
        uint size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (isContract(to)) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("transfer to non ERC721Receiver implementer");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

}