// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "./IERC20Metadata.sol";

contract Token is IERC20Metadata
{
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;

    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowed;

    constructor(string memory _name_, string memory _symbol_, uint8 _decimals_, uint256 _totalSupply_)
    {
        _name = _name_;
        _symbol = _symbol_;
        _decimals = _decimals_;
        _totalSupply = _totalSupply_ * (10 ** _decimals);

        _balance[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() external view returns (string memory)
    {
        return _name;
    }

    function symbol() external view returns (string memory)
    {
        return _symbol;
    }

    function decimals() external view returns (uint8)
    {
        return _decimals;
    }

    function totalSupply() external view returns (uint256)
    {
        return _totalSupply;
    }

    function balanceOf(address owner) external view returns (uint256)
    {
        return _balance[owner];
    }

    function transfer(address recipient, uint256 amount) external returns (bool)
    {
        require(_balance[msg.sender] > 0, "Zero Balance!");
        require(_balance[msg.sender] >= amount, "Low Balance!");
        _balance[msg.sender] -= amount;
        _balance[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256)
    {
        return _allowed[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool)
    {
        _allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
    {
        require(_allowed[sender][msg.sender] > 0, "Zero Allowance!");
        require(_allowed[sender][msg.sender] >= amount, "Low Allowance!");
        require(_balance[sender] > 0, "Zero Balance!");
        require(_balance[sender] >= amount, "Low Balance!");
        _allowed[sender][msg.sender] -= amount;
        _balance[sender] -= amount;
        _balance[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
