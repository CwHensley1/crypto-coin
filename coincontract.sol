pragma solidity >=0.4.16 <0.9.0;

contract ERC20Interface {
    function totalSupply() public view returns (uint256);
    function balanceOf(address tokenOwner) public view returns (uint256 balance);
    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
    function transfer(address to, uint256 tokens) public returns (bool success);
    function approve(address spender, uint256 tokens) public returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) public returns (bool success);

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
    uint256 public _totalSupply = 21000000000000000000000000; // 21 million coins
    
    address[] public charities =  [
        0x634977e11C823a436e587C1a1Eca959588C64287, // The Giveth Community of Makers (https://giveth.io/project/giveth)
        0x701d0ECB3BA780De7b2b36789aEC4493A426010a, // Bridging Digital Communities (https://giveth.io/project/Bridging-Digital-Communities-1)
        0xa0527bA80D811cd45d452481Caf902DFd6F5b8c2, // The Commons Simulator: Level Up! (https://giveth.io/project/The-Commons-Simulator:-Level-Up)
        0xc172542e7F4F625Bb0301f0BafC423092d9cAc71, // AmwFund (https://giveth.io/project/AmwFund)
        0x8b535BeD09a0431Bc4dc62215b6d0199943a1816, // Colorado Multiversity (https://giveth.io/project/colorado-multiversity)
        0x21e0Ca21F517a26db49Ec8FCf05FCeAbBABe98FA, // Free The Food (https://giveth.io/project/free-the-food)
        0xEDD425359FB15e894c639B6A74112954486146B9, // Diamante Luz Center for Regenerative Living (https://giveth.io/project/diamante-luz-center-for-regenerative-living)
        0x5219ffb88175588510e9752A1ecaA3cd217ca783, // Bloom Network (https://giveth.io/project/bloom-network)
        0x7554f10Da3Ed7128300577e55abCd8F8835BCee4, // Diamante Bridge Collective (https://giveth.io/project/diamante-bridge-collective)
        0xCCa88b952976DA313Fb928111f2D5c390eE0D723, // Women of Crypto Art (WOCA) (https://giveth.io/project/women-of-crypto-art-(woca))
        0x8110d1D04ac316fdCACe8f24fD60C86b810AB15A, // Commons Stack: Iteration 0 (https://giveth.io/project/commons-stack:-iteration-0)
        0x4bbeEB066eD09B7AEd07bF39EEe0460DFa261520  // MyCrypto (https://giveth.io/project/mycrypto)
    ];

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor() public {
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply - balances[address(0)];
    }

    function balanceOf(address tokenOwner) public view returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
        return allowed[tokenOwner][spender];
    }

    function transfer(address to, uint256 tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint256 tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
}
