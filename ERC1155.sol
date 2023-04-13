// SPDX-License-Identifier: MIT
pragma solidity =0.8.18;

import "./IERC115.sol";

contract ERC1155 is IERC1155 {

    mapping(address => mapping(uint => uint)) private _balance;
    mapping(address => mapping(address => bool)) private _approveAll;

    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) external {
        require(_to != address(0), "to cannot be zero address");
        require(_from == msg.sender || _approveAll[_from][msg.sender] == true, "Not authorized to transfer");
        uint256 fromBalance = _balance[_from][_id];
        require(fromBalance >= _value, "insufficient balance for transfer");
        _balance[_from][_id] -= _value;
        _balance[_to][_id] += _value;
        emit TransferSingle(msg.sender, _from, _to, _id, _value);  
    }

    function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _values, bytes calldata _data) external {
        require(_to != address(0), "transfer to the zero address");
        require(_from == msg.sender || _approveAll[_from][msg.sender] == true, "Not authorized to transfer");
        require(_ids.length == _values.length, "ids and amounts length mismatch");
        for(uint i = 0; i < _ids.length; i++) {
            uint256 id = _ids[i];
            uint256 value = _values[i];
            uint256 fromBalance = _balance[_from][id];
            require(fromBalance >= value, "insufficient balance for transfer");
            _balance[_from][id] -= value;
            _balance[_to][id] += value;
        }
        emit TransferBatch(msg.sender, _from, _to, _ids, _values);
    }

    function balanceOf(address _owner, uint256 _id) external view returns (uint256) {
        require(_owner != address(0), "address zero is not a valid owner");
        return _balance[_owner][_id];
    }

    function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory) {
        require(_owners.length == _ids.length, "accounts and ids length mismatch");
        uint256[] memory balances = new uint256[](_owners.length);
        for(uint i = 0; i < _owners.length; i++) {
            balances[i] = _balance[_owners[i]][_ids[i]];
        }
        return balances;
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(_operator != msg.sender, "setting approval status for self");
        _approveAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
        return  _approveAll[_owner][_operator];
    }
    
}