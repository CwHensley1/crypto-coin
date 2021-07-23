/**
 *Submitted for verification at BscScan.com on 2021-07-23
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

// Every transaction, there is a 1.5% fee:
//     0.5% gets burned
//     1% gets donated

abstract contract ERC20Interface {
    function totalSupply() public virtual view returns (uint256);
    function balanceOf(address tokenOwner) public virtual view returns (uint256 balance);
    function allowance(address tokenOwner, address spender) public virtual view returns (uint256 remaining);
    function transfer(address to, uint256 tokens) public virtual returns (bool success);
    function approve(address spender, uint256 tokens) public virtual returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) public virtual returns (bool success);

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}

contract SafeMath {
    function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }
    function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
        require(b > 0);
        c = a / b;
    }
}

contract Coin is ERC20Interface, SafeMath {
    string public name = "MuscleCoin";
    string public symbol = "MuC";
    uint8 public decimals = 18;
    uint256 public _totalSupply = 2000000000000000000000000000; // Two billion in supply
    
    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor() {
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public override view returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public override view returns (uint256 remaining) {
        return allowed[tokenOwner][spender];
    }
    
    function _transfer(address from, address to, uint256 tokens) private returns (bool success) {
        uint256 amountToBurn = safeDiv(tokens, 200); // 0.5% of the transaction shall be burned
        uint256 amountToDonate = safeDiv(tokens, 100); // 1% of the transaction shall be donated
        uint256 amountToTransfer = safeSub(safeSub(tokens, amountToBurn), amountToDonate);
        
        // Donations are made to the Spread the Love Commission
        // https://giveth.io/project/Spread-the-Love-Commission
        address charity = address(0xA032518dc6E76DC7B269901a2a1Fcc4065a154Bb);
        
        balances[from] = safeSub(balances[from], tokens);
        balances[address(0)] = safeAdd(balances[address(0)], amountToBurn);
        balances[charity] = safeAdd(balances[charity], amountToDonate);
        balances[to] = safeAdd(balances[to], amountToTransfer);
        
        emit Transfer(from, address(0), amountToBurn);
        emit Transfer(from, charity, amountToDonate);
        emit Transfer(from, to, amountToTransfer);
        return true;
    }

    function transfer(address to, uint256 tokens) public override returns (bool success) {
        _transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint256 tokens) public override returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success) {
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        _transfer(from, to, tokens);
        return true;
    }
    
    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
    }
}