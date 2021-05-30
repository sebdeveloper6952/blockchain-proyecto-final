pragma solidity >=0.7.0 <0.8.0;

contract Token {
    address owner;
    string tokenName;
    string tokenSymbol;
    uint8 tokenDecimals;
    uint256 tokenTotalSupply;
    
    struct Transactions {
        address sender;
        address receiver;
        uint256 tokenAmount;
    }
    
    Transactions[] transactions;
    
    mapping (address => uint256) private walletToPos;
    mapping (address => bool) private isRegistered;
    mapping (uint256 => address) private posToWallet;
    uint256[] private balances;

    mapping (address => mapping(address => uint256)) private allowances;
    
    uint private lastId;
    
    function getLastId() private returns (uint) {
        return lastId++;
    }
    
    // modifiers

    // modifier to check if caller has funds
    modifier hasFunds(uint256 amount) {
        require( balances[walletToPos[msg.sender]] >= amount, "Caller has no funds");
        _;
    }
    
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
        tokenTotalSupply = 69 * 100000000;
        // initial balance of the owner
        posToWallet[0] = owner;
        walletToPos[owner] = 0;
        balances.push(tokenTotalSupply);
        isRegistered[owner] = true;
        lastId = 1;
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
        return balances[walletToPos[_owner]];
    }
    
    function transfer(address _to, uint256 _value) public hasFunds(_value)  returns (bool success) {
 
        if (!isRegistered[_to]){
            uint256 id = getLastId();
            posToWallet[id] = _to;
            walletToPos[_to] = id;
            isRegistered[_to] = true;
            balances.push(0);
        }
        
        balances[walletToPos[msg.sender]] -= _value;
        balances[walletToPos[_to]] += _value;
        emit Transfer(msg.sender, _to, _value);
        
        Transactions memory transferValue = Transactions(msg.sender, _to, _value);
        transactions.push(transferValue);
        
        return true;
    }
    
    function lastTransfers() public view returns (address[] memory, address[] memory, uint256[] memory) {
        
        address[] memory senders = new address[](10);
        address[] memory receivers = new address[](10);
        uint256[] memory amounts = new uint256[](10);
        
        uint256 limit;
        
        if (transactions.length < 10) {
            limit = transactions.length;
        } else {
            limit = 10;
        }
        
        for (uint256 i = 0; i < limit; i++){
                
            Transactions memory tempTransaction = transactions[transactions.length - 1 - i];
                
            senders[i] = tempTransaction.sender;
            receivers [i] = tempTransaction.receiver;
            amounts[i] = tempTransaction.tokenAmount;
        }
        return (senders, receivers, amounts);   
    }
    
    function topTen() public view returns (address[] memory, uint256[] memory) {
        
        address[] memory owners = new address[](10);
        uint256[] memory amounts = new uint256[](10);
        
        uint256 limit;
        
        if (balances.length < 10) {
            limit = balances.length;
        } else {
            limit = 10;
        }

        uint256 lastAmount = 999999999999999999999999;
        for (uint256 i = 0; i < limit; i++){
            address tempOwner;
            uint256 tempAmount = 0;
            for (uint256 j = 0; j < balances.length; j++){    
                if (balances[j] > tempAmount && balances[j] < lastAmount){
                    tempOwner = posToWallet[j];
                    tempAmount = balances[j];
                }
            }
            lastAmount = tempAmount;
            owners[i] = tempOwner;
            amounts[i] = tempAmount;
        }
        return (owners, amounts);  
    }

}