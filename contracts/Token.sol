pragma solidity >=0.7.0 <0.8.0;

contract Token {
    address owner;
    string tokenName;
    string tokenSymbol;
    uint8 tokenDecimals;
    uint256 tokenTotalSupply;
    mapping (address => uint256) private balances;
    mapping (address => mapping(address => uint256)) private allowances;
    
    // events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    constructor() {
        // when the contract is deployed, save the sender address
        owner = msg.sender;
        // token data
        tokenName = "Token";
        tokenSymbol = "TOK";
        tokenDecimals = 8;
        tokenTotalSupply = 69 * 1000000;
        // initial balance of the owner
        balances[owner] = tokenTotalSupply;
    }
    
    function name() public view returns (string memory) {
        return tokenName;
    }
    
    function symbol() public view returns (string memory) {
        return tokenSymbol;
    }
    
    function decimals() public view returns (uint8) {
        return tokenDecimals;
    }
    
    function totalSupply() public view returns (uint256) {
        return tokenTotalSupply;   
    }
    
    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (balances[msg.sender] < _value)
            return false;
        
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if (allowances[_from][msg.sender] < _value)
            return false;
        if (balances[_from] < _value)
            return false;
        
        balances[_from] -= _value;
        allowances[_from][msg.sender] -= _value;
        balances[_to] += _value;
        
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        if (balances[msg.sender] < _value)
            return false;
        
        allowances[msg.sender][_spender] += _value;
        emit Approval(msg.sender, _spender, _value);
        
        return true;
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
}